import { LightningElement, wire } from 'lwc';
import getUserProjects from '@salesforce/apex/ProjectTaskWithSharingController.getUserProjects';

export default class ProjectList extends LightningElement {
    projects;
    error;

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
