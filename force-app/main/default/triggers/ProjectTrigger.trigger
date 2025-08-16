/**
 * @description Trigger on Project__c object for business logic automation
 */
trigger ProjectTrigger on Project__c (before delete, after insert, after update) {
    ProjectTriggerHandler handler = new ProjectTriggerHandler();
    if (Trigger.isBefore && Trigger.isDelete) {
        handler.beforeDelete(Trigger.old);
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.afterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            handler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
