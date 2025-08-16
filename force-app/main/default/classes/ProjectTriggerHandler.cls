/**
 * @description Handler class for Project trigger logic
 */
public class ProjectTriggerHandler {
    public void beforeDelete(List<Project__c> oldProjects) {
        // ...existing code...
    }
    public void afterInsert(List<Project__c> newProjects) {
        // ...existing code...
    }
    public void afterUpdate(List<Project__c> newProjects, Map<Id, Project__c> oldProjectMap) {
        // ...existing code...
    }
    private void preventDeletionWithOpenTasks(List<Project__c> projects) {
        // ...existing code...
    }
    private void logProjectCreation(List<Project__c> projects) {
        // ...existing code...
    }
    private void logProjectUpdates(List<Project__c> newProjects, Map<Id, Project__c> oldProjectMap) {
        // ...existing code...
    }
}
