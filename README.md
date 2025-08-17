# Epic: Salesforce Trainee Engineer Project Assignment

## Lightning Web Component (LWC) Architecture Overview

This project uses a modular LWC architecture for maintainable and scalable UI development. Below are the main components and their interactions:

### Main Components

- **projectList**: Displays the list of projects in a grid. Handles opening the modal for creating a project from a template.
- **templateProjectModal**: Modal dialog for selecting a template project and entering details for the new project. Handles validation and user input.
- **projectDetails**: Subcomponent of the modal, responsible for collecting the new project's name, start date, and end date.
- **templateSelection**: Subcomponent of the modal, responsible for displaying available template projects and allowing the user to select one.

### Component Interactions

- `projectList` opens `templateProjectModal` when the user wants to create a project from a template.
- `templateProjectModal` uses `projectDetails` and `templateSelection` for a clean separation of concerns:
  - `projectDetails` collects user input for the new project's name and dates.
  - `templateSelection` displays template projects and manages selection.
- Events are used for communication:
  - `projectDetails` emits events when the user changes the name or dates.
  - `templateSelection` emits an event when a template project is selected.
  - `templateProjectModal` validates that a template is selected before allowing creation, and emits a create event to `projectList`.
- `projectList` listens for the create event and calls the Apex method to start the project copy process.

### Validation

- The modal enforces that a template project must be selected before creation. If not, an error event is emitted and can be displayed to the user.

### Extensibility

- The modular structure allows future enhancements, such as splitting `templateProjectModal` into more granular components or adding additional validation and UI features.


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
Create a utility Apex class to access Assignment Configuration settings, including methods to retrieve max tasks per day, default due days, email notification status, and max projects per user. The class should also provide a method to log configuration values for debugging. No code block included per assignment requirements.

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

#### Create ProjectTaskWithoutSharingController.cls (1.5 hours)
Implementation summary: This controller is intended for admin operations and template access, without enforcing sharing rules. It should provide methods for retrieving all projects, template projects, and project statistics, using best practices for security and bulk data handling. 
  
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
Implementation summary: This service class should handle CRUD operations for Project and Task objects, including security checks, business logic validation, and exception handling. All logic must follow Salesforce best practices for bulk operations and error management. (Code block omitted for assignment compliance.)

#### 4.2 TaskTrigger.trigger (2 hours)

#### 4.3 TaskTriggerHandler.cls (2 hours)

#### 4.4 ProjectTrigger.trigger (1 hour)

### Testing Implementation:

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
Create a queueable Apex job to update overdue task statuses and send notifications, including logic for retrieving overdue tasks, updating statuses, sending emails, and error logging. No code block included per assignment requirements.
#### 5.2 CreateProjectFromTemplateQueueable.cls (3 hours)
