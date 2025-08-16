/**
 * @description Controller with sharing for user-specific Project and Task operations
 */
public with sharing class ProjectTaskWithSharingController {
    @AuraEnabled(cacheable=true)
    public static List<Task__c> getUserTasks(Id projectId) {
        // Query tasks for the given project
        List<Task__c> tasks = [
            SELECT Id, Name, Description__c, Status__c, DueDate__c, Priority__c, AssignedTo__c, AssignedTo__r.Name, User_Lookup__c, User_Lookup__r.Name, EstimatedHours__c
            FROM Task__c
            WHERE Project__c = :projectId
            ORDER BY Priority__c DESC, DueDate__c ASC
        ];
        return tasks;
    }
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getUserProjects() {
        // Query projects assigned to the current user, return all details for grid
        Id userId = UserInfo.getUserId();
        List<Project__c> projects = [
            SELECT Id, Name, Description__c, Status__c, StartDate__c, EndDate__c, AssignedTo__c, AssignedTo__r.Name, isTemplate__c
            FROM Project__c
            WHERE AssignedTo__c = :userId OR OwnerId = :userId
            ORDER BY LastModifiedDate DESC
            LIMIT 50
        ];
        return projects;
    }
    @AuraEnabled
    public static Id createProject(String projectName, String description) {
        // ...existing code...
        return null;
    }

    /**
     * @description Create a new Task__c record for a project
     * @param projectId Id of the parent project
     * @param name Task name
     * @param description Task description
     * @param dueDate Due date (yyyy-MM-dd)
     * @param status Status value
     * @param priority Priority value
     * @return Id of newly created Task__c
     */
    @AuraEnabled
    public static Id createTask(Id projectId, String name, String description, Date dueDate, String status, String priority) {
        Task__c newTask = new Task__c();
        newTask.Project__c = projectId;
        newTask.Name = name;
        newTask.Description__c = description;
        newTask.DueDate__c = dueDate;
        newTask.Status__c = status;
        newTask.Priority__c = priority;
        insert newTask;
        return newTask.Id;
    }
    @AuraEnabled
    public static Boolean updateTaskDescriptionAndStatus(Id taskId, String description, String status) {
        // ...existing code...
        return true;
    }
}
