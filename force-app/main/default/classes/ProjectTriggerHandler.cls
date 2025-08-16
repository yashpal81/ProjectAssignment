/**
 * @description Handler class for Project trigger logic
 */
public class ProjectTriggerHandler {
    public void beforeDelete(List<Project__c> oldProjects) {
        preventDeletionWithOpenTasks(oldProjects);
    }

    public void afterInsert(List<Project__c> newProjects) {
        logProjectCreation(newProjects);
    }

    public void afterUpdate(List<Project__c> newProjects, Map<Id, Project__c> oldProjectMap) {
        logProjectUpdates(newProjects, oldProjectMap);
    }
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
    private void logProjectCreation(List<Project__c> projects) {
        for (Project__c proj : projects) {
            System.debug('Project Created - ID: ' + proj.Id +
                       ', Name: ' + proj.Name +
                       ', Status: ' + proj.Status__c +
                       ', Created By: ' + UserInfo.getName() +
                       ', Created Date: ' + System.now());
        }
    }
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
                           ', Changes: [' + String.join(changes, ', ') + ']'+
                           ', Updated By: ' + UserInfo.getName() +
                           ', Updated Date: ' + System.now());
            }
        }
    }
}
