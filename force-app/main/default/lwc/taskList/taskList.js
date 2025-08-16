import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUserTasks from '@salesforce/apex/ProjectTaskWithSharingController.getUserTasks';
import createTask from '@salesforce/apex/ProjectTaskWithSharingController.createTask';

export default class TaskList extends LightningElement {
    @api recordId;

    tasks;
    error;
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Description', fieldName: 'Description__c' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Due Date', fieldName: 'DueDate__c', type: 'date' },
        { label: 'Priority', fieldName: 'Priority__c' },
        { label: 'Assigned To', fieldName: 'AssignedTo__r.Name' },
        { label: 'Assigned User', fieldName: 'User_Lookup__r.Name' },
        { label: 'Estimated Hours', fieldName: 'EstimatedHours__c', type: 'number' }
    ];

    isModalOpen = false;
    newTaskName = '';
    newTaskDescription = '';
    newTaskDueDate = '';
    newTaskStatus = 'Open';
    newTaskPriority = 'Medium';

    statusOptions = [
        { label: 'Open', value: 'Open' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Completed', value: 'Completed' },
        { label: 'Past Due', value: 'Past Due' }
    ];
    priorityOptions = [
        { label: 'Low', value: 'Low' },
        { label: 'Medium', value: 'Medium' },
        { label: 'High', value: 'High' },
        { label: 'Critical', value: 'Critical' }
    ];

    wiredTasksResult;
    @wire(getUserTasks, { projectId: '$recordId' })
    wiredTasks(result) {
        this.wiredTasksResult = result;
        const { error, data } = result;
        if (data) {
            this.tasks = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.tasks = undefined;
        }
    }

    handleOpenModal() {
        this.isModalOpen = true;
    }
    handleCloseModal() {
        this.isModalOpen = false;
        this.newTaskName = '';
        this.newTaskDescription = '';
        this.newTaskDueDate = '';
        this.newTaskStatus = 'Open';
        this.newTaskPriority = 'Medium';
    }
    handleNameChange(event) {
        this.newTaskName = event.target.value;
    }
    handleDescriptionChange(event) {
        this.newTaskDescription = event.target.value;
    }
    handleDueDateChange(event) {
        this.newTaskDueDate = event.target.value;
    }
    handleStatusChange(event) {
        this.newTaskStatus = event.detail.value;
    }
    handlePriorityChange(event) {
        this.newTaskPriority = event.detail.value;
    }
    async handleSaveTask() {
        try {
            await createTask({
                projectId: this.recordId,
                name: this.newTaskName,
                description: this.newTaskDescription,
                dueDate: this.newTaskDueDate,
                status: this.newTaskStatus,
                priority: this.newTaskPriority
            });
            this.handleCloseModal();
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Task created successfully!',
                    variant: 'success'
                })
            );
            // Refresh the task list
            return this.refreshTasks();
        } catch (error) {
            this.error = error.body ? error.body.message : error.message;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: this.error,
                    variant: 'error'
                })
            );
        }
    }

    async refreshTasks() {
        // Use refreshApex to update wire data
        if (this.wiredTasksResult) {
            await refreshApex(this.wiredTasksResult);
        }
    }
}
