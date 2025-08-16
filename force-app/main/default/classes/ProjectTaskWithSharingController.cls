/**
 * @description Controller with sharing for user-specific Project and Task operations
 */
public with sharing class ProjectTaskWithSharingController {
    @AuraEnabled(cacheable=true)
    public static List<Task__c> getUserTasks(Id projectId) {
        // ...existing code...
        return new List<Task__c>();
    }
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getUserProjects() {
        // ...existing code...
        return new List<Project__c>();
    }
    @AuraEnabled
    public static Id createProject(String projectName, String description) {
        // ...existing code...
        return null;
    }
    @AuraEnabled
    public static Boolean updateTaskDescriptionAndStatus(Id taskId, String description, String status) {
        // ...existing code...
        return true;
    }
}
