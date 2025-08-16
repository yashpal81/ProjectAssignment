/**
 * @description Controller without sharing for admin operations and template access
 */
public without sharing class ProjectTaskWithoutSharingController {
    @AuraEnabled(cacheable=true)
    public static List<ProjectWrapper> getTemplateProjects() {
        // ...existing code...
        return new List<ProjectWrapper>();
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
        public ProjectWrapper(Project__c proj) {
            // ...existing code...
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
