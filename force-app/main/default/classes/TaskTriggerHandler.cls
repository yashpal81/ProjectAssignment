/**
 * @description Handler class for Task trigger logic
 */
public class TaskTriggerHandler {
    public void beforeInsert(List<Task__c> newTasks) {
        assignCurrentUserIfOwnerBlank(newTasks);
        setDefaultDueDate(newTasks);
        enforceMaxTasksPerDay(newTasks);
    }

    public void beforeUpdate(List<Task__c> newTasks, Map<Id, Task__c> oldTaskMap) {
        updatePastDueStatus(newTasks);
        logStatusChanges(newTasks, oldTaskMap);
    }

    public void afterInsert(List<Task__c> newTasks) {
        sendEmailNotifications(newTasks);
    }

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
    private void assignCurrentUserIfOwnerBlank(List<Task__c> tasks) {
        for (Task__c task : tasks) {
            if (task.AssignedTo__c == null) {
                // Optionally set to a default Contact or User
                // task.AssignedTo__c = [SELECT Id FROM Contact WHERE Email = :UserInfo.getUserEmail() LIMIT 1].Id;
            }
        }
    }
    private void setDefaultDueDate(List<Task__c> tasks) {
        Integer defaultDueDays = Integer.valueOf(AssignmentConfigUtil.getDefaultDueDays());
        for (Task__c task : tasks) {
            if (task.DueDate__c == null) {
                task.DueDate__c = Date.today().addDays(defaultDueDays);
            }
        }
    }
    private void enforceMaxTasksPerDay(List<Task__c> tasks) {
        Integer maxTasksPerDay = Integer.valueOf(AssignmentConfigUtil.getMaxTasksPerDay());
        Integer todayTaskCount = [
            SELECT COUNT() FROM Task__c WHERE CreatedDate = TODAY AND AssignedTo__c != null
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
