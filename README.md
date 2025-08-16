# Epic: Salesforce Trainee Engineer Project Assignment

## Objective
This Epic is designed for trainee engineers to gain hands-on practical experience with Salesforce development concepts including:
- **Data modeling** with custom objects and relationships (Master-Detail, Lookup)
- **Lightning Web Components (LWC):** UI development, component interaction, Lightning Messaging Service
- **Apex programming:** CRUD operations, triggers, sharing models, security enforcement
- **Custom Settings:** Hierarchical configuration management
- **Security & Permissions:** CRUD, FLS checks, sharing rules, permission sets
- **Version Control:** Git workflows, branch protection, pull request reviews

---

## Project Timeline Overview
**Total Duration:** 8 Days  
**Daily Commitment:** 6-8 hours  
**Review Points:** End of each day with mentor  
**Final Demo:** Day 8  

---

## Story 0: Project Repository Setup  
**Expected Timeline:** Day 0 (2 hours)  
**Prerequisites:** GitHub account, Git installed locally  

### Detailed Steps:
1. **Create Private Repository:**
   - Repository name: `salesforce-project-assignment-[your-name]`
   - Description: "Salesforce Trainee Engineer Project Assignment"
   - Set to Private
   - Initialize with README.md

2. **Branch Protection Setup:**
   - Navigate to Settings → Branches
   - Add rule for `main` branch:
     - ✅ Require pull request reviews before merging
     - ✅ Require review from code owners
     - ✅ Dismiss stale PR approvals when new commits are pushed
     - ✅ Require status checks to pass before merging
     - ✅ Require branches to be up to date before merging
     - ✅ Restrict pushes that create files larger than 100 MB

3. **Add Mentor as Contributor:**
   - Go to Settings → Manage access
   - Click "Invite a collaborator"
   - Add mentor's GitHub username with "Write" access

4. **Daily Workflow Setup:**
   - Create feature branch for each day: `feature/day-1`, `feature/day-2`, etc.
   - At end of each day, create PR from feature branch to `main`
   - Add mentor as reviewer
   - Merge only after approval

### Deliverables:
- [ ] Private repository created
- [ ] Branch protection configured
- [ ] Mentor added as collaborator
- [ ] README.md with project overview

---

## Object Model Structure

### 1. Project__c (Parent Object)
**API Name:** `Project__c`  
**Label:** Project  
**Plural Label:** Projects  

| Field API Name    | Label           | Data Type       | Length | Required | Description                                 |
|-------------------|----------------|----------------|---------|----------|---------------------------------------------|
| Name              | Project Name    | Text           | 80      | Yes      | Auto-generated name field                   |
| Description__c    | Description     | Long Text      | 32,768  | No       | Detailed project description                |
| isTemplate__c     | Is Template     | Checkbox       | -       | No       | Marks project as reusable template          |
| AssignedTo__c     | Assigned To     | Lookup(Contact)| -       | No       | Primary contact assigned to project         |
| Status__c         | Status          | Picklist       | -       | Yes      | Active, Inactive, Completed, On Hold        |
| StartDate__c      | Start Date      | Date           | -       | No       | Project start date                          |
| EndDate__c        | End Date        | Date           | -       | No       | Project end date                            |

### 2. Task__c (Child Object)
**API Name:** `Task__c`  
**Label:** Task  
**Plural Label:** Tasks  

| Field API Name    | Label           | Data Type       | Length | Required | Description                                 |
|-------------------|----------------|----------------|---------|----------|---------------------------------------------|
| Name              | Task Name       | Text           | 80      | Yes      | Auto-generated name field                   |
| Project__c        | Project         | Master-Detail(Project__c) | - | Yes | Parent project reference                    |
| Description__c    | Description     | Long Text      | 32,768  | No       | Detailed task description                   |
| isTemplate__c     | Is Template     | Checkbox       | -       | No       | Marks task as reusable template             |
| AssignedTo__c     | Assigned To     | Lookup(Contact)| -       | No       | Contact assigned to task                    |
| User_Lookup__c    | Assigned User   | Lookup(User)   | -       | No       | User assigned to task                       |
| DueDate__c        | Due Date        | Date           | -       | No       | Task deadline                               |
| Status__c         | Status          | Picklist       | -       | Yes      | Open, In Progress, Completed, Past Due      |
| Priority__c       | Priority        | Picklist       | -       | No       | Low, Medium, High, Critical                 |
| EstimatedHours__c | Estimated Hours | Number(3,1)    | -       | No       | Estimated effort in hours                   |

### 3. Assignment_Config__c (Custom Setting)
**Type:** Hierarchy  
**API Name:** `Assignment_Config__c`  

| Field API Name         | Label                  | Data Type | Description                    |
|------------------------|------------------------|-----------|--------------------------------|
| Max_Tasks_Per_Day__c   | Max Tasks Per Day      | Number(2,0) | Maximum tasks assignable per day |
| Default_Due_Days__c    | Default Due Days       | Number(3,0) | Default days for task due date |
| Email_Notifications__c | Enable Email Notifications | Checkbox | Enable/disable email alerts |

---

## Story 1: Create Custom Objects with Relationships  
**Expected Timeline:** Day 1 (6 hours)  
**Prerequisite:** Access to Salesforce org with System Administrator profile  

### Detailed Steps:

#### 1.1 Create Project__c Object (2 hours)
1. **Navigate to Setup → Object Manager**
2. **Click "Create" → "Custom Object"**
3. **Object Details:**
   - Label: `Project`
   - Plural Label: `Projects`
   - Object Name: `Project`
   - Record Name: `Project Name` (Text)
   - Allow Reports: ✅
   - Allow Activities: ✅
   - Track Field History: ✅
   - Allow Sharing: ✅
   - Allow Bulk API Access: ✅
   - Allow Streaming API Access: ✅

4. **Create Custom Fields:**
   ```
   Description__c:
   - Data Type: Long Text Area (32,768)
   - Visible Length: 5
   - # of Lines: 5
   
   isTemplate__c:
   - Data Type: Checkbox
   - Default Value: Unchecked
   
   AssignedTo__c:
   - Data Type: Lookup Relationship
   - Related To: Contact
   - Field Label: Assigned To
   - Child Relationship Name: Projects
   
   Status__c:
   - Data Type: Picklist
   - Values: Active, Inactive, Completed, On Hold
   - Default: Active
   - Alphabetical: No
   
   StartDate__c:
   - Data Type: Date
   
   EndDate__c:
   - Data Type: Date
   ```

#### 1.2 Create Task__c Object (2 hours)
1. **Navigate to Setup → Object Manager**
2. **Click "Create" → "Custom Object"**
3. **Object Details:**
   - Label: `Task`
   - Plural Label: `Tasks`
   - Object Name: `Task`
   - Record Name: `Task Name` (Text)
   - Allow Reports: ✅
   - Allow Activities: ✅
   - Track Field History: ✅

4. **Create Master-Detail Relationship:**
   ```
   Project__c:
   - Data Type: Master-Detail Relationship
   - Related To: Project__c
   - Field Label: Project
   - Child Relationship Name: Tasks
   - Sharing Setting: Read/Write
   - Reparenting: Allow reparenting
   ```

5. **Create Additional Fields:**
   ```
   Description__c, isTemplate__c, AssignedTo__c (same as Project__c)
   
   User_Lookup__c:
   - Data Type: Lookup Relationship
   - Related To: User
   - Field Label: Assigned User
   
   DueDate__c:
   - Data Type: Date
   
   Status__c:
   - Data Type: Picklist
   - Values: Open, In Progress, Completed, Past Due
   - Default: Open
   
   Priority__c:
   - Data Type: Picklist
   - Values: Low, Medium, High, Critical
   - Default: Medium
   
   EstimatedHours__c:
   - Data Type: Number(3,1)
   ```

#### 1.3 Create Page Layouts (1 hour)
1. **Project__c Layout:**
   - Section 1: Project Information (Name, Status__c, AssignedTo__c)
   - Section 2: Details (Description__c, StartDate__c, EndDate__c)
   - Section 3: System Information (Created By, Modified By, etc.)
   - Related List: Tasks

2. **Task__c Layout:**
   - Section 1: Task Information (Name, Project__c, Status__c, Priority__c)
   - Section 2: Assignment (AssignedTo__c, User_Lookup__c, DueDate__c)
   - Section 3: Details (Description__c, EstimatedHours__c)

#### 1.4 Create Tabs (1 hour)
1. **Create Custom Tabs:**
   - Project__c tab with appropriate icon
   - Task__c tab with appropriate icon
2. **Add to App:**
   - Add tabs to Lightning Experience app

### Testing Checklist:
- [ ] Create sample Project record
- [ ] Create sample Task records linked to Project
- [ ] Verify Master-Detail relationship working
- [ ] Verify Lookup relationships working
- [ ] Test page layouts display correctly

### Deliverables:
- [ ] Project__c object with all fields
- [ ] Task__c object with all fields and relationships
- [ ] Custom tabs created
- [ ] Sample data created for testing
- [ ] Documentation of object schema

---

## Story 2: Implement Custom Settings  
**Expected Timeline:** Day 2 (4 hours)  

### Detailed Steps:

#### 2.1 Create Assignment_Config__c Custom Setting (2 hours)
1. **Navigate to Setup → Custom Settings**
2. **Click "New"**
3. **Setting Details:**
   - Label: `Assignment Configuration`
   - Object Name: `Assignment_Config`
   - Setting Type: `Hierarchy`
   - Visibility: `Public`
   - Description: `Configuration settings for project assignment management`

4. **Create Custom Fields:**
   ```
   Max_Tasks_Per_Day__c:
   - Data Type: Number(2,0)
   - Default Value: 5
   
   Default_Due_Days__c:
   - Data Type: Number(3,0)
   - Default Value: 7
   
   Email_Notifications__c:
   - Data Type: Checkbox
   - Default Value: True
   
   Max_Projects_Per_User__c:
   - Data Type: Number(2,0)
   - Default Value: 3
   ```

#### 2.2 Create Apex Class for Custom Setting Access (2 hours)
```apex
/**
 * @description Utility class to access Assignment Configuration settings
 * @author yashpal81
 * @date 2025-08-15
 */
public class AssignmentConfigUtil {
    
    private static Assignment_Config__c config;
    
    /**
     * @description Get the assignment configuration for current user
     * @return Assignment_Config__c configuration instance
     */
    public static Assignment_Config__c getConfig() {
        if (config == null) {
            config = Assignment_Config__c.getInstance();
            if (config == null) {
                // Return default values if no custom setting found
                config = new Assignment_Config__c();
                config.Max_Tasks_Per_Day__c = 5;
                config.Default_Due_Days__c = 7;
                config.Email_Notifications__c = true;
                config.Max_Projects_Per_User__c = 3;
            }
        }
        return config;
    }
    
    /**
     * @description Get maximum tasks allowed per day
     * @return Decimal max tasks per day
     */
    public static Decimal getMaxTasksPerDay() {
        return getConfig().Max_Tasks_Per_Day__c;
    }
    
    /**
     * @description Get default due days for tasks
     * @return Decimal default due days
     */
    public static Decimal getDefaultDueDays() {
        return getConfig().Default_Due_Days__c;
    }
    
    /**
     * @description Check if email notifications are enabled
     * @return Boolean email notifications enabled
     */
    public static Boolean isEmailNotificationEnabled() {
        return getConfig().Email_Notifications__c;
    }
    
    /**
     * @description Get maximum projects per user
     * @return Decimal max projects per user
     */
    public static Decimal getMaxProjectsPerUser() {
        return getConfig().Max_Projects_Per_User__c;
    }
    
    /**
     * @description Log configuration values for debugging
     */
    public static void logConfigValues() {
        Assignment_Config__c cfg = getConfig();
        System.debug('=== Assignment Configuration ===');
        System.debug('Max Tasks Per Day: ' + cfg.Max_Tasks_Per_Day__c);
        System.debug('Default Due Days: ' + cfg.Default_Due_Days__c);
        System.debug('Email Notifications: ' + cfg.Email_Notifications__c);
        System.debug('Max Projects Per User: ' + cfg.Max_Projects_Per_User__c);
        System.debug('================================');
    }
}
```

### Testing:
1. **Create test data in custom setting**
2. **Execute anonymous code:**
```apex
AssignmentConfigUtil.logConfigValues();
System.debug('Max tasks: ' + AssignmentConfigUtil.getMaxTasksPerDay());
```

### Deliverables:
- [ ] Assignment_Config__c custom setting created
- [ ] AssignmentConfigUtil.cls created and tested
- [ ] Test data populated in custom setting

---

## Story 7: Create Permission Sets for Team Lead and Developer Personas  
**Expected Timeline:** Day 2 (2 hours)  

### Detailed Steps:

#### 7.1 Create Team Lead Permission Set (1 hour)
1. **Navigate to Setup → Permission Sets**
2. **Click "New"**
3. **Permission Set Details:**
   - Label: `Project Team Lead`
   - API Name: `Project_Team_Lead`
   - Description: `Full CRUD access to Projects and Tasks for Team Leads`

4. **Object Settings:**
   ```
   Project__c:
   - Read: ✅
   - Create: ✅
   - Edit: ✅
   - Delete: ✅
   - View All: ✅
   - Modify All: ✅
   
   Task__c:
   - Read: ✅
   - Create: ✅
   - Edit: ✅
   - Delete: ✅
   - View All: ✅
   - Modify All: ✅
   ```

5. **Field Permissions:** Grant access to all custom fields on both objects

#### 7.2 Create Developer Permission Set (1 hour)
1. **Permission Set Details:**
   - Label: `Project Developer`
   - API Name: `Project_Developer`
   - Description: `Read access to Projects/Tasks, limited edit on Task Description and Status`

2. **Object Settings:**
   ```
   Project__c:
   - Read: ✅
   - Create: ❌
   - Edit: ❌
   - Delete: ❌
   - View All: ❌
   - Modify All: ❌
   
   Task__c:
   - Read: ✅
   - Create: ❌
   - Edit: ✅ (Limited to specific fields)
   - Delete: ❌
   - View All: ❌
   - Modify All: ❌
   ```

3. **Field Permissions:**
   ```
   Project__c - All fields: Read Only
   
   Task__c:
   - Name: Read Only
   - Project__c: Read Only
   - Description__c: Read ✅, Edit ✅
   - Status__c: Read ✅, Edit ✅
   - Priority__c: Read Only
   - AssignedTo__c: Read Only
   - User_Lookup__c: Read Only
   - DueDate__c: Read Only
   - EstimatedHours__c: Read Only
   - isTemplate__c: Read Only
   ```

### Testing Instructions:
1. **Create test users**
2. **Assign permission sets**
3. **Login as different personas and test CRUD operations**

### Deliverables:
- [ ] Project_Team_Lead permission set created
- [ ] Project_Developer permission set created
- [ ] Test users created and permission sets assigned
- [ ] Testing documentation with screenshots

---

## Controller Creation (Before Story 3)
**Expected Timeline:** Day 2.5 (3 hours)  

### Detailed Steps:

#### Create ProjectTaskWithSharingController.cls (1.5 hours)
```apex
/**
 * @description Controller with sharing for user-specific Project and Task operations
 * @author yashpal81
 * @date 2025-08-15
 */
public with sharing class ProjectTaskWithSharingController {
    
    /**
     * @description Get tasks for current project that user has access to
     * @param projectId Id of the project
     * @return List<Task__c> tasks visible to current user
     */
    @AuraEnabled(cacheable=true)
    public static List<Task__c> getUserTasks(Id projectId) {
        // CRUD and FLS Security Check
        if (!Schema.sObjectType.Task__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Tasks');
        }
        
        // Field level security check
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Task__c.fields.getMap();
        List<String> fieldsToCheck = new List<String>{
            'Id', 'Name', 'Description__c', 'Status__c', 'DueDate__c', 
            'AssignedTo__c', 'User_Lookup__c', 'Priority__c', 'EstimatedHours__c'
        };
        
        for (String fieldName : fieldsToCheck) {
            if (!fieldMap.get(fieldName).getDescribe().isAccessible()) {
                throw new AuraHandledException('Insufficient permissions to access field: ' + fieldName);
            }
        }
        
        try {
            String currentUserId = UserInfo.getUserId();
            
            return [
                SELECT Id, Name, Description__c, Status__c, DueDate__c,
                       AssignedTo__c, AssignedTo__r.Name, User_Lookup__c, User_Lookup__r.Name,
                       Priority__c, EstimatedHours__c, Project__c, CreatedDate,
                       CreatedBy.Name, LastModifiedDate
                FROM Task__c 
                WHERE Project__c = :projectId
                AND (OwnerId = :currentUserId 
                     OR User_Lookup__c = :currentUserId
                     OR AssignedTo__c IN (SELECT ContactId FROM User WHERE Id = :currentUserId))
                ORDER BY Priority__c DESC, DueDate__c ASC
                LIMIT 100
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving tasks: ' + e.getMessage());
        }
    }
    
    /**
     * @description Get projects where user is owner or assigned
     * @return List<Project__c> user's projects
     */
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getUserProjects() {
        if (!Schema.sObjectType.Project__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Projects');
        }
        
        try {
            String currentUserId = UserInfo.getUserId();
            
            return [
                SELECT Id, Name, Description__c, Status__c, StartDate__c, EndDate__c,
                       AssignedTo__c, AssignedTo__r.Name, isTemplate__c,
                       (SELECT COUNT() FROM Tasks__r) TaskCount
                FROM Project__c 
                WHERE OwnerId = :currentUserId
                OR AssignedTo__c IN (SELECT ContactId FROM User WHERE Id = :currentUserId)
                ORDER BY LastModifiedDate DESC
                LIMIT 50
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving projects: ' + e.getMessage());
        }
    }
    
    /**
     * @description Create new project
     * @param projectName Name of the project
     * @param description Project description
     * @return Id newly created project Id
     */
    @AuraEnabled
    public static Id createProject(String projectName, String description) {
        if (!Schema.sObjectType.Project__c.isCreateable()) {
            throw new AuraHandledException('Insufficient permissions to create Projects');
        }
        
        try {
            Project__c newProject = new Project__c();
            newProject.Name = projectName;
            newProject.Description__c = description;
            newProject.Status__c = 'Active';
            
            insert newProject;
            return newProject.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating project: ' + e.getMessage());
        }
    }
    
    /**
     * @description Update task description and status (for Developer persona)
     * @param taskId Id of the task to update
     * @param description New description
     * @param status New status
     * @return Boolean success indicator
     */
    @AuraEnabled
    public static Boolean updateTaskDescriptionAndStatus(Id taskId, String description, String status) {
        if (!Schema.sObjectType.Task__c.isUpdateable()) {
            throw new AuraHandledException('Insufficient permissions to update Tasks');
        }
        
        // Check field level security for specific fields
        if (!Schema.sObjectType.Task__c.fields.Description__c.isUpdateable() ||
            !Schema.sObjectType.Task__c.fields.Status__c.isUpdateable()) {
            throw new AuraHandledException('Insufficient permissions to update Task fields');
        }
        
        try {
            Task__c taskToUpdate = new Task__c();
            taskToUpdate.Id = taskId;
            taskToUpdate.Description__c = description;
            taskToUpdate.Status__c = status;
            
            update taskToUpdate;
            return true;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating task: ' + e.getMessage());
        }
    }
}
```

#### Create ProjectTaskWithoutSharingController.cls (1.5 hours)
```apex
/**
 * @description Controller without sharing for admin operations and template access
 * @author yashpal81
 * @date 2025-08-15
 */
public without sharing class ProjectTaskWithoutSharingController {
    
    /**
     * @description Get all template projects (for admin view)
     * @return List<ProjectWrapper> template projects with task count
     */
    @AuraEnabled(cacheable=true)
    public static List<ProjectWrapper> getTemplateProjects() {
        if (!Schema.sObjectType.Project__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Projects');
        }
        
        try {
            List<Project__c> projects = [
                SELECT Id, Name, Description__c, Status__c, StartDate__c, EndDate__c,
                       AssignedTo__c, AssignedTo__r.Name, isTemplate__c, CreatedDate,
                       CreatedBy.Name, (SELECT COUNT() FROM Tasks__r) TaskCount
                FROM Project__c 
                WHERE isTemplate__c = true
                ORDER BY Name ASC
            ];
            
            List<ProjectWrapper> wrapperList = new List<ProjectWrapper>();
            for (Project__c proj : projects) {
                wrapperList.add(new ProjectWrapper(proj));
            }
            
            return wrapperList;
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving template projects: ' + e.getMessage());
        }
    }
    
    /**
     * @description Get all projects (admin view)
     * @return List<Project__c> all projects
     */
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getAllProjects() {
        if (!Schema.sObjectType.Project__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Projects');
        }
        
        try {
            return [
                SELECT Id, Name, Description__c, Status__c, StartDate__c, EndDate__c,
                       AssignedTo__c, AssignedTo__r.Name, isTemplate__c,
                       (SELECT COUNT() FROM Tasks__r) TaskCount
                FROM Project__c 
                ORDER BY LastModifiedDate DESC
                LIMIT 200
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving projects: ' + e.getMessage());
        }
    }
    
    /**
     * @description Get project statistics
     * @return ProjectStats statistics object
     */
    @AuraEnabled(cacheable=true)
    public static ProjectStats getProjectStatistics() {
        try {
            ProjectStats stats = new ProjectStats();
            
            // Get project counts by status
            for (AggregateResult ar : [
                SELECT Status__c, COUNT(Id) projectCount 
                FROM Project__c 
                GROUP BY Status__c
            ]) {
                String status = (String) ar.get('Status__c');
                Integer count = (Integer) ar.get('projectCount');
                
                switch on status {
                    when 'Active' {
                        stats.activeProjects = count;
                    }
                    when 'Completed' {
                        stats.completedProjects = count;
                    }
                    when 'On Hold' {
                        stats.onHoldProjects = count;
                    }
                }
            }
            
            // Get task counts by status
            for (AggregateResult ar : [
                SELECT Status__c, COUNT(Id) taskCount 
                FROM Task__c 
                GROUP BY Status__c
            ]) {
                String status = (String) ar.get('Status__c');
                Integer count = (Integer) ar.get('taskCount');
                
                switch on status {
                    when 'Open' {
                        stats.openTasks = count;
                    }
                    when 'In Progress' {
                        stats.inProgressTasks = count;
                    }
                    when 'Completed' {
                        stats.completedTasks = count;
                    }
                    when 'Past Due' {
                        stats.pastDueTasks = count;
                    }
                }
            }
            
            return stats;
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving statistics: ' + e.getMessage());
        }
    }
    
    // Wrapper classes
    public class ProjectWrapper {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String description { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public Integer taskCount { get; set; }
        @AuraEnabled public String assignedToName { get; set; }
        @AuraEnabled public Date startDate { get; set; }
        @AuraEnabled public Date endDate { get; set; }
        
        public ProjectWrapper(Project__c proj) {
            this.id = proj.Id;
            this.name = proj.Name;
            this.description = proj.Description__c;
            this.status = proj.Status__c;
            this.taskCount = proj.Tasks__r?.size() ?? 0;
            this.assignedToName = proj.AssignedTo__r?.Name;
            this.startDate = proj.StartDate__c;
            this.endDate = proj.EndDate__c;
        }
    }
    
    public class ProjectStats {
        @AuraEnabled public Integer activeProjects { get; set; }
        @AuraEnabled public Integer completedProjects { get; set; }
        @AuraEnabled public Integer onHoldProjects { get; set; }
        @AuraEnabled public Integer openTasks { get; set; }
        @AuraEnabled public Integer inProgressTasks { get; set; }
        @AuraEnabled public Integer completedTasks { get; set; }
        @AuraEnabled public Integer pastDueTasks { get; set; }
        
        public ProjectStats() {
            this.activeProjects = 0;
            this.completedProjects = 0;
            this.onHoldProjects = 0;
            this.openTasks = 0;
            this.inProgressTasks = 0;
            this.completedTasks = 0;
            this.pastDueTasks = 0;
        }
    }
}
```

### Deliverables:
- [ ] ProjectTaskWithSharingController.cls created and tested
- [ ] ProjectTaskWithoutSharingController.cls created and tested
- [ ] Test classes created for both controllers
- [ ] Security documentation explaining sharing vs non-sharing usage

---

## Story 4: Write Apex Classes and Triggers  
**Expected Timeline:** Day 5 (8 hours)  

### Detailed Implementation:

#### 4.1 ProjectTaskCRUDService.cls (2 hours)
```apex
/**
 * @description Service class for CRUD operations on Project and Task objects
 * @author yashpal81
 * @date 2025-08-15
 */
public with sharing class ProjectTaskCRUDService {
    
    /**
     * @description Create multiple projects with security checks
     * @param projects List of projects to create
     * @return List<Database.SaveResult> save results
     */
    public static List<Database.SaveResult> createProjects(List<Project__c> projects) {
        // CRUD Security Check
        if (!Schema.sObjectType.Project__c.isCreateable()) {
            throw new ProjectTaskException('Insufficient permissions to create Projects');
        }
        
        // FLS Security Check
        List<String> requiredFields = new List<String>{'Name', 'Status__c', 'Description__c'};
        for (String fieldName : requiredFields) {
            if (!Schema.sObjectType.Project__c.fields.get(fieldName).getDescribe().isCreateable()) {
                throw new ProjectTaskException('Insufficient permissions to create field: ' + fieldName);
            }
        }
        
        // Business Logic Validation
        validateProjects(projects);
        
        return Database.insert(projects, false);
    }
    
    /**
     * @description Update projects with security checks
     * @param projects List of projects to update
     * @return List<Database.SaveResult> save results
     */
    public static List<Database.SaveResult> updateProjects(List<Project__c> projects) {
        // CRUD Security Check
        if (!Schema.sObjectType.Project__c.isUpdateable()) {
            throw new ProjectTaskException('Insufficient permissions to update Projects');
        }
        
        validateProjects(projects);
        
        return Database.update(projects, false);
    }
    
    /**
     * @description Delete projects with security checks
     * @param projects List of projects to delete
     * @return List<Database.DeleteResult> delete results
     */
    public static List<Database.DeleteResult> deleteProjects(List<Project__c> projects) {
        // CRUD Security Check
        if (!Schema.sObjectType.Project__c.isDeletable()) {
            throw new ProjectTaskException('Insufficient permissions to delete Projects');
        }
        
        // Business Logic - Check for open tasks
        Set<Id> projectIds = new Set<Id>();
        for (Project__c proj : projects) {
            projectIds.add(proj.Id);
        }
        
        List<Task__c> openTasks = [
            SELECT Id, Project__c, Status__c 
            FROM Task__c 
            WHERE Project__c IN :projectIds 
            AND Status__c IN ('Open', 'In Progress')
        ];
        
        if (!openTasks.isEmpty()) {
            throw new ProjectTaskException('Cannot delete projects with open tasks');
        }
        
        return Database.delete(projects, false);
    }
    
    /**
     * @description Create tasks with security and business logic checks
     * @param tasks List of tasks to create
     * @return List<Database.SaveResult> save results
     */
    public static List<Database.SaveResult> createTasks(List<Task__c> tasks) {
        // CRUD Security Check
        if (!Schema.sObjectType.Task__c.isCreateable()) {
            throw new ProjectTaskException('Insufficient permissions to create Tasks');
        }
        
        // Validate against custom setting limits
        validateTaskLimits(tasks);
        
        return Database.insert(tasks, false);
    }
    
    /**
     * @description Update tasks with security checks
     * @param tasks List of tasks to update
     * @return List<Database.SaveResult> save results
     */
    public static List<Database.SaveResult> updateTasks(List<Task__c> tasks) {
        // CRUD Security Check
        if (!Schema.sObjectType.Task__c.isUpdateable()) {
            throw new ProjectTaskException('Insufficient permissions to update Tasks');
        }
        
        return Database.update(tasks, false);
    }
    
    /**
     * @description Get tasks by project with sharing
     * @param projectId Project ID
     * @return List<Task__c> tasks
     */
    public static List<Task__c> getTasksByProject(Id projectId) {
        if (!Schema.sObjectType.Task__c.isAccessible()) {
            throw new ProjectTaskException('Insufficient permissions to access Tasks');
        }
        
        return [
            SELECT Id, Name, Description__c, Status__c, Priority__c, DueDate__c,
                   AssignedTo__c, User_Lookup__c, EstimatedHours__c, Project__c
            FROM Task__c
            WHERE Project__c = :projectId
            ORDER BY Priority__c DESC, DueDate__c ASC
        ];
    }
    
    /**
     * @description Validate project data
     * @param projects List of projects to validate
     */
    private static void validateProjects(List<Project__c> projects) {
        for (Project__c proj : projects) {
            if (String.isBlank(proj.Name)) {
                throw new ProjectTaskException('Project name is required');
            }
            
            if (proj.EndDate__c != null && proj.StartDate__c != null && 
                proj.EndDate__c < proj.StartDate__c) {
                throw new ProjectTaskException('End date cannot be before start date');
            }
        }
    }
    
    /**
     * @description Validate task limits based on custom settings
     * @param tasks List of tasks to validate
     */
    private static void validateTaskLimits(List<Task__c> tasks) {
        Decimal maxTasksPerDay = AssignmentConfigUtil.getMaxTasksPerDay();
        
        // Count existing tasks created today by current user
        Integer todayTaskCount = [
            SELECT COUNT() 
            FROM Task__c 
            WHERE CreatedDate = TODAY 
            AND OwnerId = :UserInfo.getUserId()
        ];
        
        if (todayTaskCount + tasks.size() > maxTasksPerDay) {
            throw new ProjectTaskException(
                'Cannot create more than ' + maxTasksPerDay + ' tasks per day. ' +
                'Current count: ' + todayTaskCount + ', Attempting to add: ' + tasks.size()
            );
        }
    }
    
    /**
     * @description Custom exception class
     */
    public class ProjectTaskException extends Exception {}
}
```

#### 4.2 TaskTrigger.trigger (2 hours)
```apex
/**
 * @description Trigger on Task__c object for business logic automation
 * @author yashpal81
 * @date 2025-08-15
 */
trigger TaskTrigger on Task__c (before insert, before update, after insert, after update) {
    
    TaskTriggerHandler handler = new TaskTriggerHandler();
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            handler.beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            handler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.afterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            handler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
```

#### 4.3 TaskTriggerHandler.cls (2 hours)
```apex
/**
 * @description Handler class for Task trigger logic
 * @author yashpal81
 * @date 2025-08-15
 */
public class TaskTriggerHandler {
    
    /**
     * @description Before insert logic
     * @param newTasks List of new tasks
     */
    public void beforeInsert(List<Task__c> newTasks) {
        assignCurrentUserIfOwnerBlank(newTasks);
        setDefaultDueDate(newTasks);
        enforceMaxTasksPerDay(newTasks);
    }
    
    /**
     * @description Before update logic
     * @param newTasks List of updated tasks
     * @param oldTaskMap Map of old task values
     */
    public void beforeUpdate(List<Task__c> newTasks, Map<Id, Task__c> oldTaskMap) {
        updatePastDueStatus(newTasks);
        logStatusChanges(newTasks, oldTaskMap);
    }
    
    /**
     * @description After insert logic
     * @param newTasks List of newly inserted tasks
     */
    public void afterInsert(List<Task__c> newTasks) {
        sendEmailNotifications(newTasks);
    }
    
    /**
     * @description After update logic
     * @param newTasks List of updated tasks
     * @param oldTaskMap Map of old task values
     */
    public void afterUpdate(List<Task__c> newTasks, Map<Id, Task__c> oldTaskMap) {
        List<Task__c> statusChangedTasks = new List<Task__c>();
        
        for (Task__c task : newTasks) {
            Task__c oldTask = oldTaskMap.get(task.Id);
            if (task.Status__c != oldTask.Status__c) {
                statusChangedTasks.add(task);
            }
        }
        
        if (!statusChangedTasks.isEmpty()) {
            sendEmailNotifications(statusChangedTasks);
        }
    }
    
    /**
     * @description Assign current user if owner is blank
     * @param tasks List of tasks
     */
    private void assignCurrentUserIfOwnerBlank(List<Task__c> tasks) {
        for (Task__c task : tasks) {
            if (task.OwnerId == null) {
                task.OwnerId = UserInfo.getUserId();
            }
        }
    }
    
    /**
     * @description Set default due date based on custom setting
     * @param tasks List of tasks
     */
    private void setDefaultDueDate(List<Task__c> tasks) {
        Integer defaultDueDays = Integer.valueOf(AssignmentConfigUtil.getDefaultDueDays());
        
        for (Task__c task : tasks) {
            if (task.DueDate__c == null) {
                task.DueDate__c = Date.today().addDays(defaultDueDays);
            }
        }
    }
    
    /**
     * @description Enforce max tasks per day limit from custom setting
     * @param tasks List of tasks
     */
    private void enforceMaxTasksPerDay(List<Task__c> tasks) {
        Integer maxTasksPerDay = Integer.valueOf(AssignmentConfigUtil.getMaxTasksPerDay());
        
        // Count existing tasks created today by current user
        Integer todayTaskCount = [
            SELECT COUNT() 
            FROM Task__c 
            WHERE CreatedDate = TODAY 
            AND OwnerId = :UserInfo.getUserId()
        ];
        
        if (todayTaskCount + tasks.size() > maxTasksPerDay) {
            for (Task__c task : tasks) {
                task.addError(
                    'Cannot create more than ' + maxTasksPerDay + ' tasks per day. ' +
                    'You have already created ' + todayTaskCount + ' tasks today.'
                );
            }
        }
    }
    
    /**
     * @description Update status to Past Due for overdue tasks
     * @param tasks List of tasks
     */
    private void updatePastDueStatus(List<Task__c> tasks) {
        Date today = Date.today();
        
        for (Task__c task : tasks) {
            if (task.DueDate__c != null && 
                task.DueDate__c < today && 
                task.Status__c != 'Completed' &&
                task.Status__c != 'Past Due') {
                task.Status__c = 'Past Due';
            }
        }
    }
    
    /**
     * @description Log status changes for auditing
     * @param newTasks List of updated tasks
     * @param oldTaskMap Map of old task values
     */
    private void logStatusChanges(List<Task__c> newTasks, Map<Id, Task__c> oldTaskMap) {
        for (Task__c task : newTasks) {
            Task__c oldTask = oldTaskMap.get(task.Id);
            if (task.Status__c != oldTask.Status__c) {
                System.debug('Task Status Changed - ID: ' + task.Id + 
                           ', From: ' + oldTask.Status__c + 
                           ', To: ' + task.Status__c + 
                           ', User: ' + UserInfo.getName());
            }
        }
    }
    
    /**
     * @description Send email notifications for task assignments
     * @param tasks List of tasks
     */
    private void sendEmailNotifications(List<Task__c> tasks) {
        if (!AssignmentConfigUtil.isEmailNotificationEnabled()) {
            return;
        }
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (Task__c task : tasks) {
            if (task.User_Lookup__c != null && task.User_Lookup__c != UserInfo.getUserId()) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setTargetObjectId(task.User_Lookup__c);
                email.setSaveAsActivity(false);
                email.setSubject('New Task Assignment: ' + task.Name);
                
                String body = 'You have been assigned a new task:\n\n';
                body += 'Task Name: ' + task.Name + '\n';
                body += 'Priority: ' + task.Priority__c + '\n';
                body += 'Due Date: ' + (task.DueDate__c != null ? task.DueDate__c.format() : 'Not specified') + '\n';
                body += 'Description: ' + (task.Description__c != null ? task.Description__c : 'No description provided') + '\n\n';
                body += 'Please log in to Salesforce to view the full details.';
                
                email.setPlainTextBody(body);
                emails.add(email);
            }
        }
        
        if (!emails.isEmpty()) {
            try {
                Messaging.sendEmail(emails);
            } catch (Exception e) {
                System.debug('Error sending email notifications: ' + e.getMessage());
            }
        }
    }
}
```

#### 4.4 ProjectTrigger.trigger (1 hour)
```apex
/**
 * @description Trigger on Project__c object for business logic automation
 * @author yashpal81
 * @date 2025-08-15
 */
trigger ProjectTrigger on Project__c (before delete, after insert, after update) {
    
    ProjectTriggerHandler handler = new ProjectTriggerHandler();
    
    if (Trigger.isBefore && Trigger.isDelete) {
        handler.beforeDelete(Trigger.old);
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.afterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            handler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
```

#### 4.5 ProjectTriggerHandler.cls (1 hour)
```apex
/**
 * @description Handler class for Project trigger logic
 * @author yashpal81
 * @date 2025-08-15
 */
public class ProjectTriggerHandler {
    
    /**
     * @description Before delete logic
     * @param oldProjects List of projects being deleted
     */
    public void beforeDelete(List<Project__c> oldProjects) {
        preventDeletionWithOpenTasks(oldProjects);
    }
    
    /**
     * @description After insert logic
     * @param newProjects List of newly created projects
     */
    public void afterInsert(List<Project__c> newProjects) {
        logProjectCreation(newProjects);
    }
    
    /**
     * @description After update logic
     * @param newProjects List of updated projects
     * @param oldProjectMap Map of old project values
     */
    public void afterUpdate(List<Project__c> newProjects, Map<Id, Project__c> oldProjectMap) {
        logProjectUpdates(newProjects, oldProjectMap);
    }
    
    /**
     * @description Prevent deletion of projects with open tasks
     * @param projects List of projects being deleted
     */
    private void preventDeletionWithOpenTasks(List<Project__c> projects) {
        Set<Id> projectIds = new Set<Id>();
        for (Project__c proj : projects) {
            projectIds.add(proj.Id);
        }
        
        // Check for open tasks
        Map<Id, Integer> projectToOpenTaskCount = new Map<Id, Integer>();
        
        for (AggregateResult ar : [
            SELECT Project__c, COUNT(Id) taskCount
            FROM Task__c
            WHERE Project__c IN :projectIds
            AND Status__c IN ('Open', 'In Progress')
            GROUP BY Project__c
        ]) {
            Id projectId = (Id) ar.get('Project__c');
            Integer taskCount = (Integer) ar.get('taskCount');
            projectToOpenTaskCount.put(projectId, taskCount);
        }
        
        for (Project__c proj : projects) {
            if (projectToOpenTaskCount.containsKey(proj.Id)) {
                Integer openTaskCount = projectToOpenTaskCount.get(proj.Id);
                proj.addError(
                    'Cannot delete project with ' + openTaskCount + 
                    ' open task(s). Please complete or delete all tasks first.'
                );
            }
        }
    }
    
    /**
     * @description Log project creation for auditing
     * @param projects List of newly created projects
     */
    private void logProjectCreation(List<Project__c> projects) {
        for (Project__c proj : projects) {
            System.debug('Project Created - ID: ' + proj.Id + 
                       ', Name: ' + proj.Name + 
                       ', Status: ' + proj.Status__c + 
                       ', Created By: ' + UserInfo.getName() + 
                       ', Created Date: ' + System.now());
        }
    }
    
    /**
     * @description Log project updates for auditing
     * @param newProjects List of updated projects
     * @param oldProjectMap Map of old project values
     */
    private void logProjectUpdates(List<Project__c> newProjects, Map<Id, Project__c> oldProjectMap) {
        for (Project__c proj : newProjects) {
            Project__c oldProj = oldProjectMap.get(proj.Id);
            
            List<String> changes = new List<String>();
            
            if (proj.Name != oldProj.Name) {
                changes.add('Name: "' + oldProj.Name + '" → "' + proj.Name + '"');
            }
            
            if (proj.Status__c != oldProj.Status__c) {
                changes.add('Status: "' + oldProj.Status__c + '" → "' + proj.Status__c + '"');
            }
            
            if (proj.Description__c != oldProj.Description__c) {
                changes.add('Description updated');
            }
            
            if (proj.AssignedTo__c != oldProj.AssignedTo__c) {
                changes.add('Assignment changed');
            }
            
            if (!changes.isEmpty()) {
                System.debug('Project Updated - ID: ' + proj.Id + 
                           ', Changes: [' + String.join(changes, ', ') + ']' +
                           ', Updated By: ' + UserInfo.getName() + 
                           ', Updated Date: ' + System.now());
            }
        }
    }
}
```

### Testing Implementation:
```apex
/**
 * @description Test class for Task trigger functionality
 * @author yashpal81
 * @date 2025-08-15
 */
@isTest
public class TaskTriggerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test custom setting
        Assignment_Config__c config = new Assignment_Config__c();
        config.Max_Tasks_Per_Day__c = 3;
        config.Default_Due_Days__c = 7;
        config.Email_Notifications__c = true;
        insert config;
        
        // Create test project
        Project__c testProject = new Project__c(
            Name = 'Test Project',
            Status__c = 'Active',
            Description__c = 'Test project description'
        );
        insert testProject;
    }
    
    @isTest
    static void testTaskCreationWithOwnerAssignment() {
        Project__c proj = [SELECT Id FROM Project__c LIMIT 1];
        
        Test.startTest();
        
        Task__c newTask = new Task__c(
            Name = 'Test Task',
            Project__c = proj.Id,
            Status__c = 'Open',
            Priority__c = 'Medium'
        );
        
        insert newTask;
        
        Test.stopTest();
        
        Task__c insertedTask = [SELECT Id, OwnerId, DueDate__c FROM Task__c WHERE Id = :newTask.Id];
        System.assertEquals(UserInfo.getUserId(), insertedTask.OwnerId, 'Owner should be set to current user');
        System.assertEquals(Date.today().addDays(7), insertedTask.DueDate__c, 'Due date should be set to default days');
    }
    
    @isTest
    static void testMaxTasksPerDayEnforcement() {
        Project__c proj = [SELECT Id FROM Project__c LIMIT 1];
        
        Test.startTest();
        
        // Create 3 tasks (should succeed)
        List<Task__c> tasks = new List<Task__c>();
        for (Integer i = 1; i <= 3; i++) {
            tasks.add(new Task__c(
                Name = 'Test Task ' + i,
                Project__c = proj.Id,
                Status__c = 'Open'
            ));
        }
        insert tasks;
        
        // Try to create 4th task (should fail)
        Task__c fourthTask = new Task__c(
            Name = 'Fourth Task',
            Project__c = proj.Id,
            Status__c = 'Open'
        );
        
        try {
            insert fourthTask;
            System.assert(false, 'Should have thrown exception for exceeding daily limit');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Cannot create more than'), 'Should show daily limit error');
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testPastDueStatusUpdate() {
        Project__c proj = [SELECT Id FROM Project__c LIMIT 1];
        
        Task__c task = new Task__c(
            Name = 'Overdue Task',
            Project__c = proj.Id,
            Status__c = 'Open',
            DueDate__c = Date.today().addDays(-5)
        );
        insert task;
        
        Test.startTest();
        
        task.Description__c = 'Updated description';
        update task;
        
        Test.stopTest();
        
        Task__c updatedTask = [SELECT Status__c FROM Task__c WHERE Id = :task.Id];
        System.assertEquals('Past Due', updatedTask.Status__c, 'Status should be updated to Past Due');
    }
}
```

### Deliverables:
- [ ] ProjectTaskCRUDService.cls with security checks
- [ ] TaskTrigger.trigger with proper handler pattern
- [ ] TaskTriggerHandler.cls with business logic
- [ ] ProjectTrigger.trigger with validation logic
- [ ] ProjectTriggerHandler.cls with audit logging
- [ ] Test classes with 100% code coverage
- [ ] Documentation of trigger logic and business rules

---

## Story 5: Asynchronous Programming with Apex  
**Expected Timeline:** Day 6 (8 hours)  

### Detailed Implementation:

#### 5.1 TaskStatusUpdateQueueable.cls (3 hours)
```apex
/**
 * @description Queueable job to update overdue task statuses and send notifications
 * @author yashpal81
 * @date 2025-08-15
 */
public class TaskStatusUpdateQueueable implements Queueable, Database.AllowsCallouts {
    
    private List<Id> taskIds;
    private Boolean sendEmails;
    
    /**
     * @description Constructor with default parameters
     */
    public TaskStatusUpdateQueueable() {
        this(null, true);
    }
    
    /**
     * @description Constructor with specific task IDs
     * @param taskIds List of task IDs to process (null for all overdue tasks)
     * @param sendEmails Whether to send email notifications
     */
    public TaskStatusUpdateQueueable(List<Id> taskIds, Boolean sendEmails) {
        this.taskIds = taskIds;
        this.sendEmails = sendEmails != null ? sendEmails : true;
    }
    
    /**
     * @description Execute the queueable job
     * @param context QueueableContext
     */
    public void execute(QueueableContext context) {
        try {
            List<Task__c> tasksToUpdate = getOverdueTasks();
            
            if (!tasksToUpdate.isEmpty()) {
                updateTaskStatuses(tasksToUpdate);
                
                if (sendEmails && AssignmentConfigUtil.isEmailNotificationEnabled()) {
                    sendOverdueNotifications(tasksToUpdate);
                }
                
                System.debug('TaskStatusUpdateQueueable: Updated ' + tasksToUpdate.size() + ' overdue tasks');
            } else {
                System.debug('TaskStatusUpdateQueueable: No overdue tasks found');
            }
            
        } catch (Exception e) {
            System.debug('TaskStatusUpdateQueueable Error: ' + e.getMessage());
            System.debug('TaskStatusUpdateQueueable Stack Trace: ' + e.getStackTraceString());
            
            // Log error for monitoring
            logError(e);
        }
    }
    
    /**
     * @description Get overdue tasks that need status update
     * @return List<Task__c> overdue tasks
     */
    private List<Task__c> getOverdueTasks() {
        String query = 'SELECT Id, Name, Status__c, DueDate__c, Priority__c, ' +
                      'AssignedTo__c, User_Lookup__c, User_Lookup__r.Email, ' +
                      'Project__c, Project__r.Name, Description__c ' +
                      'FROM Task__c ' +
                      'WHERE DueDate__c < TODAY ' +
                      'AND Status__c NOT IN (\'Completed\', \'Past Due\') ';
        
        if (taskIds != null && !taskIds.isEmpty()) {
            query += 'AND Id IN :taskIds ';
        }
        
        query += 'ORDER BY Priority__c DESC, DueDate__c ASC ' +
                'LIMIT 200';
        
        return Database.query(query);
    }
    
    /**
     * @description Update task statuses to Past Due
     * @param tasks List of tasks to update
     */
    private void updateTaskStatuses(List<Task__c> tasks) {
        List<Task__c> tasksToUpdate = new List<Task__c>();
        
        for (Task__c task : tasks) {
            Task__c taskUpdate = new Task__c();
            taskUpdate.Id = task.Id;
            taskUpdate.Status__c = 'Past Due';
            tasksToUpdate.add(taskUpdate);
        }
        
        if (!tasksToUpdate.isEmpty()) {
            Database.SaveResult[] results = Database.update(tasksToUpdate, false);
            
            // Log any failures
            for (Integer i = 0; i < results.size(); i++) {
                if (!results[i].isSuccess()) {
                    System.debug('Failed to update task: ' + tasksToUpdate[i].Id + 
                               ', Error: ' + results[i].getErrors()[0].getMessage());
                }
            }
        }
    }
    
    /**
     * @description Send email notifications for overdue tasks
     * @param tasks List of overdue tasks
     */
    private void sendOverdueNotifications(List<Task__c> tasks) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (Task__c task : tasks) {
            if (task.User_Lookup__c != null && task.User_Lookup__r.Email != null) {
                Messaging.SingleEmailMessage email = createOverdueEmail(task);
                if (email != null) {
                    emails.add(email);
                }
            }
        }
        
        if (!emails.isEmpty()) {
            try {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
                
                Integer successCount = 0;
                for (Messaging.SendEmailResult result : results) {
                    if (result.isSuccess()) {
                        successCount++;
                    } else {
                        System.debug('Failed to send email: ' + result.getErrors()[0].getMessage());
                    }
                }
                
                System.debug('Sent ' + successCount + ' overdue task notifications');
                
            } catch (Exception e) {
                System.debug('Error sending overdue notifications: ' + e.getMessage());
            }
        }
    }
    
    /**
     * @description Create email message for overdue task
     * @param task Overdue task
     * @return Messaging.SingleEmailMessage email message
     */
    private Messaging.SingleEmailMessage createOverdueEmail(Task__c task) {
        try {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(task.User_Lookup__c);
            email.setSaveAsActivity(false);
            email.setSubject('⚠️ OVERDUE: Task "' + task.Name + '" is Past Due');
            
            String body = buildEmailBody(task);
            email.setPlainTextBody(body);
            
            return email;
            
        } catch (Exception e) {
            System.debug('Error creating email for task ' + task.Id + ': ' + e.getMessage());
            return null;
        }
    }
    
    /**
     * @description Build email body for overdue notification
     * @param task Overdue task
     * @return String email body
     */
    private String buildEmailBody(Task__c task) {
        String body = 'Dear Team Member,\n\n';
        body += 'The following task is now PAST DUE and requires immediate attention:\n\n';
        body += '📋 Task Details:\n';
        body += '   • Task Name: ' + task.Name + '\n';
        body += '   • Project: ' + (task.Project__r?.Name != null ? task.Project__r.Name : 'N/A') + '\n';
        body += '   • Priority: ' + (task.Priority__c != null ? task.Priority__c : 'Medium') + '\n';
        body += '   • Original Due Date: ' + (task.DueDate__c != null ? task.DueDate__c.format() : 'Not specified') + '\n';
        body += '   • Days Overdue: ' + (task.DueDate__c != null ? Date.today().daysBetween(task.DueDate__c) : 0) + '\n\n';
        
        if (task.Description__c != null) {
            body += '📝 Description:\n';
            body += task.Description__c + '\n\n';
        }
        
        body += '⚡ Action Required:\n';
        body += 'Please log in to Salesforce immediately to:\n';
        body += '   1. Update the task status\n';
        body += '   2. Provide progress updates\n';
        body += '   3. Adjust timeline if needed\n\n';
        
        body += 'If you need assistance or have questions, please contact your project manager.\n\n';
        body += 'Best regards,\n';
        body += 'Project Management System\n';
        body += 'Sent on: ' + System.now().format();
        
        return body;
    }
    
    /**
     * @description Log error for monitoring purposes
     * @param e Exception to log
     */
    private void logError(Exception e) {
        // In a real implementation, you might want to create a custom object for error logging
        // or integrate with a monitoring system
        System.debug('=== TaskStatusUpdateQueueable Error Log ===');
        System.debug('Time: ' + System.now());
        System.debug('User: ' + UserInfo.getName() + ' (' + UserInfo.getUserId() + ')');
        System.debug('Error Type: ' + e.getTypeName());
        System.debug('Error Message: ' + e.getMessage());
        System.debug('Stack Trace: ' + e.getStackTrace