   public class ProjectCopyQueueable implements Queueable {
        // Backward compatible constructor for legacy calls
        public ProjectCopyQueueable(Id templateProjectId, Id userId) {
            this.templateProjectId = templateProjectId;
            this.userId = userId;
            this.newName = null;
            this.newStartDate = null;
            this.newEndDate = null;
        }
        private Id templateProjectId;
        private Id userId;
        private String newName;
        private Date newStartDate;
        private Date newEndDate;

        public ProjectCopyQueueable(Id templateProjectId, Id userId, String newName, Date newStartDate, Date newEndDate) {
            this.templateProjectId = templateProjectId;
            this.userId = userId;
            this.newName = newName;
            this.newStartDate = newStartDate;
            this.newEndDate = newEndDate;
        }
        public void execute(QueueableContext context) {
            // Copy project
            Project__c template = [SELECT Name, Description__c, Status__c, StartDate__c, EndDate__c FROM Project__c WHERE Id = :templateProjectId LIMIT 1];
            Project__c newProject = template.clone(false, true, false, false);
            newProject.Name = (newName != null && newName != '') ? newName : template.Name + ' (Copy)';
            newProject.Status__c = 'Active';
            newProject.isTemplate__c = false;
            newProject.AssignedTo__c = null;
            if (newStartDate != null) newProject.StartDate__c = newStartDate;
            if (newEndDate != null) newProject.EndDate__c = newEndDate;
            insert newProject;
            // Copy tasks
            List<Task__c> templateTasks = [SELECT Name, Description__c, Status__c, DueDate__c, Priority__c, EstimatedHours__c FROM Task__c WHERE Project__c = :templateProjectId];
            List<Task__c> newTasks = new List<Task__c>();
            for (Task__c t : templateTasks) {
                Task__c nt = t.clone(false, true, false, false);
                nt.Project__c = newProject.Id;
                nt.Status__c = 'Open';
                newTasks.add(nt);
            }
            if (!newTasks.isEmpty()) {
                insert newTasks;
            }
            // Notify user
            sendNotification(userId, newProject.Id);
        }
        private void sendNotification(Id userId, Id newProjectId) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(userId);
            email.setSaveAsActivity(false);
            email.setSubject('Project Copy Complete');
            email.setPlainTextBody('Your new project and its tasks have been created. Project Id: ' + newProjectId);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        }
    }
