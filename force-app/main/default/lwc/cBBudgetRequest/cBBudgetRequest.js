import { LightningElement, api, wire, track } from "lwc";
import getBudgetRequestList from '@salesforce/apex/CBBudgetRequestCommunity.getCBRequests'; //saveCBRequests
import saveCBRequests from '@salesforce/apex/CBBudgetRequestCommunity.saveCBRequests';

const actions = [
    { label: 'Edit', name: 'editRequest' },
    { label: 'Delete', name: 'delete' },
];

const columns = [
    { label: 'Index', fieldName: 'Name' },
    { label: 'Title', fieldName: 'Title__c' },
    { label: 'Amount', fieldName: 'Amount__c', type: 'currency' },
    { label: 'Date', fieldName: 'InactDate__c', type: 'date' },
    { label: 'Description', fieldName: 'Description__c' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];

export default class CBBudgetRequest extends LightningElement {

    @track budgetRequests;
    @track error;
    @track warning;
    request;
    columns = columns;
    isModalOpen = false;
    data = [];


    /**
     * Instead of doInit
     */
    connectedCallback(objectApiName) {
        this.updateBudgetRequestList();
    }

    /*************Page Handlers*************************************************************************/
    updateBudgetRequestList() {
        getBudgetRequestList()
            .then(result => {
                this.budgetRequests = result;
                this.data = result;
            })
            .catch(error => {
                this.error = error;
            });
    }
    handleTableButtons(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                this.deleteRow(row);
                break;
            case 'editRequest':
                this.showRowDetails(row);
                break;
            default:
        }
    }
    handleModalChanges(event) {
        try {
            const field = event.target.name;
            const value = event.target.value;
            console.log(`Name: ${field} Value: ${value}`);
            if (field === 'title') {
                this.request.Title__c = value;
            } else if (field === 'amount') {
                this.request.Amount__c = value;
            } else if (field === 'inactDate') {
                this.request.InactDate__c = value;
            } else if (field === 'description') {
                this.request.Description__c = value;
            }
            console.log(`Result : ${JSON.stringify(this.request)} `);
        } catch (e) {
            alert(e);
        }
    }
    saveRequest(event) {
        alert('Try to saveRequest ' + JSON.stringify(this.request));
        try {
            saveCBRequests({ request: this.request })
                .then(result => {
                    this.warning = result;
                    alert(this.warning);
                    this.closeModal();
                })
                .catch(error => {
                    this.error = error;
                });
        } catch (e) {
            alert('Saving Error:' + e);
        }
    }
    closeModal(event) {
        this.isModalOpen = false;
        this.request = undefined;
    }


    /*************Page Handlers*************************************************************************/



    /*************Additinal Functions*************************************************************************/


    showRowDetails(row) {
        this.request = JSON.parse(JSON.stringify(row));
        this.isModalOpen = true;
    }

    deleteRow(row) {
        const { id } = row;
        const index = this.findRowIndexById(id);
        if (index !== -1) {
            this.data = this.data
                .slice(0, index)
                .concat(this.data.slice(index + 1));
        }
    }

    findRowIndexById(id) {
        let ret = -1;
        this.data.some((row, index) => {
            if (row.id === id) {
                ret = index;
                return true;
            }
            return false;
        });
        return ret;
    }
    /*************Additinal Functions*************************************************************************/




}