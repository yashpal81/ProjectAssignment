import { LightningElement, wire } from 'lwc';
import getUserProjects from '@salesforce/apex/ProjectTaskWithSharingController.getUserProjects';

export default class ProjectList extends LightningElement {
    projects;
    error;
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Description', fieldName: 'Description__c' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Start Date', fieldName: 'StartDate__c', type: 'date' },
        { label: 'End Date', fieldName: 'EndDate__c', type: 'date' },
        { label: 'Assigned To', fieldName: 'AssignedTo__r.Name' },
        { label: 'Is Template', fieldName: 'isTemplate__c', type: 'boolean' }
    ];

    @wire(getUserProjects)
    wiredProjects({ error, data }) {
        if (data) {
            this.projects = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.projects = undefined;
        }
    }
}
