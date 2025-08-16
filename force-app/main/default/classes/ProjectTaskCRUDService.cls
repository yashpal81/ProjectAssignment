/**
 * @description Service class for CRUD operations on Project and Task objects
 */
public with sharing class ProjectTaskCRUDService {
    public static List<Database.SaveResult> createProjects(List<Project__c> projects) {
        // ...existing code...
        return new List<Database.SaveResult>();
    }
    public static List<Database.SaveResult> updateProjects(List<Project__c> projects) {
        // ...existing code...
        return new List<Database.SaveResult>();
    }
    public static List<Database.DeleteResult> deleteProjects(List<Project__c> projects) {
        // ...existing code...
        return new List<Database.DeleteResult>();
    }
    public static List<Database.SaveResult> createTasks(List<Task__c> tasks) {
        // ...existing code...
        return new List<Database.SaveResult>();
    }
    public static List<Database.SaveResult> updateTasks(List<Task__c> tasks) {
        // ...existing code...
        return new List<Database.SaveResult>();
    }
    public static List<Task__c> getTasksByProject(Id projectId) {
        // ...existing code...
        return new List<Task__c>();
    }
    private static void validateProjects(List<Project__c> projects) {
        // ...existing code...
    }
    private static void validateTaskLimits(List<Task__c> tasks) {
        // ...existing code...
    }
    public class ProjectTaskException extends Exception {}
}
