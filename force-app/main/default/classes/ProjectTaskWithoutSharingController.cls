    
 
 /**
 * @description Controller without sharing for admin operations and template access
 */
public without sharing class ProjectTaskWithoutSharingController {
    
    /**
     * @description Get all template projects (for modal grid)
     * @return List<ProjectWrapper> template projects with task count and created by
     */
    @AuraEnabled(cacheable=true)
    public static List<ProjectWrapper> getTemplateProjects() {
        List<Project__c> projects = [
            SELECT Id, Name, Description__c, Status__c, AssignedTo__c, StartDate__c, EndDate__c, CreatedBy.Name, isTemplate__c
            FROM Project__c
            WHERE isTemplate__c = true
        ];
        Map<Id, Integer> taskCounts = new Map<Id, Integer>();
        for (AggregateResult ar : [SELECT Project__c, COUNT(Id) cnt FROM Task__c WHERE Project__c IN :projects GROUP BY Project__c]) {
            taskCounts.put((Id)ar.get('Project__c'), (Integer)ar.get('cnt'));
        }
        List<ProjectWrapper> wrappers = new List<ProjectWrapper>();
        for (Project__c proj : projects) {
            Integer cnt = taskCounts.containsKey(proj.Id) ? taskCounts.get(proj.Id) : 0;
            wrappers.add(new ProjectWrapper(proj, cnt));
        }
        return wrappers;
    }

    /**
     * @description Start async process to copy project and tasks with custom name and dates
     * @param templateProjectId Id of template project
     * @param newName Name for the new project
     * @param newStartDate Start date for the new project
     * @param newEndDate End date for the new project
     */
    @AuraEnabled
    public static void startProjectCopyProcess(Id templateProjectId, String newName, Date newStartDate, Date newEndDate) {
        System.enqueueJob(new ProjectCopyQueueable(templateProjectId, UserInfo.getUserId(), newName, newStartDate, newEndDate));
    }

    @AuraEnabled(cacheable=true)
    public static List<Project__c> getAllProjects() {
        // ...existing code...
        return new List<Project__c>();
    }
    @AuraEnabled(cacheable=true)
    public static ProjectStats getProjectStatistics() {
        // ...existing code...
        return new ProjectStats();
    }
    public class ProjectWrapper {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String description { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public Integer taskCount { get; set; }
        @AuraEnabled public String assignedToName { get; set; }
        @AuraEnabled public Date startDate { get; set; }
        @AuraEnabled public Date endDate { get; set; }
        public ProjectWrapper(Project__c proj, Integer taskCount) {
            this.id = proj.Id;
            this.name = proj.Name;
            this.description = proj.Description__c;
            this.status = proj.Status__c;
            this.taskCount = taskCount;
            this.assignedToName = proj.AssignedTo__c != null ? [SELECT Name FROM User WHERE Id = :proj.AssignedTo__c LIMIT 1].Name : null;
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
            // ...existing code...
        }
    }
}
