import { LightningElement, api } from 'lwc';

export default class TemplateSelection extends LightningElement {
    @api templateProjects = [];
    @api templateColumns = [];
    @api selectedTemplateId = null;
    @api isCreateDisabled = false;

    handleTemplateSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.dispatchEvent(new CustomEvent('templateselect', { detail: selectedRows.length === 1 ? selectedRows[0].Id : null }));
    }
}
