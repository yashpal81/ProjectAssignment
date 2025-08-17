import { LightningElement, wire } from 'lwc';
import getUserProjects from '@salesforce/apex/ProjectTaskWithSharingController.getUserProjects';
import getTemplateProjects from '@salesforce/apex/ProjectTaskWithoutSharingController.getTemplateProjects';
import startProjectCopyProcess from '@salesforce/apex/ProjectTaskWithoutSharingController.startProjectCopyProcess';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

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

    isTemplateModalOpen = false;
    templateProjects = [];
    templateColumns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'No. of Tasks', fieldName: 'TaskCount', type: 'number' },
        { label: 'Created By', fieldName: 'CreatedByName' }
    ];
    selectedTemplateId = null;
    isCreateDisabled = true;
    newProjectName = '';
    newStartDate = '';
    newEndDate = '';
    // Modal event handlers for child component
    handleModalChange(event) {
        const { selectedTemplateId, newProjectName, newStartDate, newEndDate } = event.detail;
        this.selectedTemplateId = selectedTemplateId;
        this.newProjectName = newProjectName;
        this.newStartDate = newStartDate;
        this.newEndDate = newEndDate;
        this.isCreateDisabled = !selectedTemplateId;
    }
    async handleModalCreate(event) {
        const { templateProjectId, newName, newStartDate, newEndDate } = event.detail;
        if (!templateProjectId) return;
        try {
            await startProjectCopyProcess({
                templateProjectId,
                newName,
                newStartDate,
                newEndDate
            });
            this.handleCloseTemplateModal();
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Project Creation Started',
                    message: 'You will be notified when the project and its tasks are copied.',
                    variant: 'info'
                })
            );
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body ? error.body.message : error.message,
                    variant: 'error'
                })
            );
        }
    }

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

    handleOpenTemplateModal() {
        this.isTemplateModalOpen = true;
        this.loadTemplateProjects();
    }
    handleCloseTemplateModal() {
        this.isTemplateModalOpen = false;
        this.selectedTemplateId = null;
        this.isCreateDisabled = true;
    }
    async loadTemplateProjects() {
        try {
            const result = await getTemplateProjects();
            // Map wrapper fields to grid
            this.templateProjects = result.map(tp => ({
                Id: tp.id,
                Name: tp.name,
                TaskCount: tp.taskCount,
                CreatedByName: tp.createdByName
            }));
        } catch (error) {
            this.templateProjects = [];
        }
    }
    handleTemplateSelection(event) {
        const selectedRows = event.detail.selectedRows;
        if (selectedRows.length === 1) {
            this.selectedTemplateId = selectedRows[0].Id;
            this.isCreateDisabled = false;
        } else {
            this.selectedTemplateId = null;
            this.isCreateDisabled = true;
        }
    }
    async handleCreateFromTemplate() {
        if (!this.selectedTemplateId) return;
        try {
            await startProjectCopyProcess({
                templateProjectId: this.selectedTemplateId,
                newName: this.newProjectName,
                newStartDate: this.newStartDate,
                newEndDate: this.newEndDate
            });
            this.handleCloseTemplateModal();
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Project Creation Started',
                    message: 'You will be notified when the project and its tasks are copied.',
                    variant: 'info'
                })
            );
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body ? error.body.message : error.message,
                    variant: 'error'
                })
            );
        }
    }
}
