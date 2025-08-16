/**
 * @description Handler class for Task trigger logic
 */
public class TaskTriggerHandler {
    public void beforeInsert(List<Task__c> newTasks) {
        // ...existing code...
    }
    public void beforeUpdate(List<Task__c> newTasks, Map<Id, Task__c> oldTaskMap) {
        // ...existing code...
    }
    public void afterInsert(List<Task__c> newTasks) {
        // ...existing code...
    }
    public void afterUpdate(List<Task__c> newTasks, Map<Id, Task__c> oldTaskMap) {
        // ...existing code...
    }
    private void assignCurrentUserIfOwnerBlank(List<Task__c> tasks) {
        // ...existing code...
    }
    private void setDefaultDueDate(List<Task__c> tasks) {
        // ...existing code...
    }
    private void enforceMaxTasksPerDay(List<Task__c> tasks) {
        // ...existing code...
    }
    private void updatePastDueStatus(List<Task__c> tasks) {
        // ...existing code...
    }
    private void logStatusChanges(List<Task__c> newTasks, Map<Id, Task__c> oldTaskMap) {
        // ...existing code...
    }
    private void sendEmailNotifications(List<Task__c> tasks) {
        // ...existing code...
    }
}
