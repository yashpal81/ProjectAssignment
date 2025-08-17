import { LightningElement, api } from 'lwc';

export default class TemplateProjectModal extends LightningElement {
    @api templateProjects = [];
    @api templateColumns = [];
    @api isCreateDisabled = false;
    @api selectedTemplateId = null;
    @api newProjectName = '';
    @api newStartDate = '';
    @api newEndDate = '';

    handleNameChange(event) {
        this.newProjectName = event.detail;
        this.dispatchChange();
    }
    handleStartDateChange(event) {
        this.newStartDate = event.detail;
        this.dispatchChange();
    }
    handleEndDateChange(event) {
        this.newEndDate = event.detail;
        this.dispatchChange();
    }
    handleTemplateSelection(event) {
        this.selectedTemplateId = event.detail;
        this.isCreateDisabled = !this.selectedTemplateId;
        this.dispatchChange();
    }
    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }
    handleCreate() {
        if (!this.selectedTemplateId) {
            this.dispatchEvent(new CustomEvent('change', {
                detail: {
                    error: 'Please select a template project before creating.'
                }
            }));
            return;
        }
        this.dispatchEvent(new CustomEvent('create', {
            detail: {
                templateProjectId: this.selectedTemplateId,
                newName: this.newProjectName,
                newStartDate: this.newStartDate,
                newEndDate: this.newEndDate
            }
        }));
    }
    dispatchChange() {
        this.dispatchEvent(new CustomEvent('change', {
            detail: {
                selectedTemplateId: this.selectedTemplateId,
                newProjectName: this.newProjectName,
                newStartDate: this.newStartDate,
                newEndDate: this.newEndDate
            }
        }));
    }
}
