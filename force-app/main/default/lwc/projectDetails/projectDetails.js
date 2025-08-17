import { LightningElement, api } from 'lwc';

export default class ProjectDetails extends LightningElement {
    @api newProjectName = '';
    @api newStartDate = '';
    @api newEndDate = '';

    handleNameChange(event) {
        this.dispatchEvent(new CustomEvent('namechange', { detail: event.target.value }));
    }
    handleStartDateChange(event) {
        this.dispatchEvent(new CustomEvent('startdatechange', { detail: event.target.value }));
    }
    handleEndDateChange(event) {
        this.dispatchEvent(new CustomEvent('enddatechange', { detail: event.target.value }));
    }
}
