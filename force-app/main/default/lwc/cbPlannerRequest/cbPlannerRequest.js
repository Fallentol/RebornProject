import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getBudgetRequestList from '@salesforce/apex/CBBudgetRequestCommunity.getCBRequests';
import getAnalyticsSO from '@salesforce/apex/CBBudgetRequestCommunity.getAnalyticsSO';
import saveCBRequests from '@salesforce/apex/CBBudgetRequestCommunity.saveCBRequests';//saveCBRequests
import deleteCBRequest from '@salesforce/apex/CBBudgetRequestCommunity.deleteCBRequest';
import getListOfRelatedFiles from '@salesforce/apex/CBBudgetRequestCommunity.getListOfRelatedFiles'; // 
import { helpGetValidationResult, helpCalculateRequestTotal } from './cbPlannerRequestHelper';
import { _fireMessage, _isInvalid, _cl } from 'c/cbUtils';


/**
 *  <ltng:require scripts="{!$Resource.cb4__exceljs}"/>
 */

const actions = [
    { label: 'Edit', name: 'editRequest' },
    { label: 'Delete', name: 'delete' },
];

const columns = [
    { label: 'Title', fieldName: 'Name' },
    { label: 'Amount', fieldName: 'cb4__Decimal1__c', type: 'currency' },
    { label: 'Date', fieldName: 'cb4__Date1__c', type: 'date' },
    { label: 'Description', fieldName: 'cb4__TextLong1__c' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];

export default class CBBudgetRequest extends LightningElement {

    @track budgetRequests;
    @track error;
    @track warning;
    @api recordId;
    selectOptions;
    @track request;
    attachments;
    columns = columns;
    isModalOpen = false;
    data = [];
    spinOn = false;
    get acceptedFormats() {
        return ['.pdf', '.png', '.txt', '.docx'];
    }

    /**
     * Instead of doInit
     */
    connectedCallback(objectApiName) {
        this.updateBudgetRequestList();
        this.updateSelectOptionList();
    }

    /*************Page Handlers*************************************************************************/
    updateBudgetRequestList() {
        console.log('-> GET THE LIST OF REQUESTS');

        getBudgetRequestList()
            .then(result => {
                console.log('-> REQUESTS UPDATED');
                console.log('-> result:' + JSON.stringify(result));
                this.budgetRequests = result;
                this.data = result;
            })
            .catch(error => {
                this.error = error;
            });
    }
    updateSelectOptionList() {
        console.log('-> GET THE LIST OF SELECT OPTIONS');

        getAnalyticsSO()
            .then(result => {
                _cl('-> SELECT OPTIONS UPDATED', 'pink');
                _cl('-> result:' + JSON.stringify(result), 'pink');
                this.selectOptions = result;
            })
            .catch(error => {
                this.error = error;
            });
    }
    handleTableButtons(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.recordId = row.Id;
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
            const label = event.target.label;
            const key = event.target.key;
            console.log(`Name: ${field} Value: ${value}`);
            console.log(`Name label: ${label}`);
            console.log(`Name key: ${key}`);

            ['title:Name', 'amount:cb4__Decimal1__c', 'enactDate:cb4__Date1__c', 'description:cb4__TextLong1__c', 'fund:cb4__Tag5__c', 'program:cb4__Tag6__c'].forEach((key) => {
                let [inputField, sobjectField] = key.split(':');
                if (field === inputField) this.request[sobjectField] = value;
            });

            _cl(`Result : ${JSON.stringify(this.request)} `, 'orange');
        } catch (e) {
            alert(e);
        }
    }
    handleChildrenChanges(event) {
        try {
            const id = event.target.name;
            const value = event.target.value;
            const label = event.target.label;
            console.log(`Name:${id} Value:${value} Label:${label}`);
            let child = this.request.cb4__Elements1__r.find(elem => elem.Id === id);

            ['Title:Name', 'Amount:cb4__Decimal1__c', 'Account:cb4__Tag1__c', 'Description:cb4__TextLong1__c'].forEach((key) => {
                let [inputField, sobjectField] = key.split(':');
                if (label === inputField) child[sobjectField] = value;
            });

            _cl('child:' + JSON.stringify(child), 'red');
            _cl('request:' + JSON.stringify(this.request), 'red');

        } catch (e) {
            alert(e);
        }
    }
    saveRequest(event) {
        _cl('Try to saveRequest ' + JSON.stringify(this.request), 'orange');
        this.spinOn = true;
        let children = this.request.cb4__Elements1__r;
        children.forEach(elem => { delete elem.Id; });
        delete this.request.cb4__Elements1__r;
        try {
            saveCBRequests({ request: this.request, requestLines: children })
                .then(result => {
                    try {
                        this.warning = result;
                        this.updateBudgetRequestList();
                        this.closeModal();
                        _fireMessage.success(this, 'Saved', 'Success');
                        this.spinOn = false;
                    } catch (e) {
                        alert('ERROR:' + e);
                        this.spinOn = false;
                    }
                })
                .catch(error => {
                    this.spinOn = false;
                    this.error = error;
                });
        } catch (e) {
            alert('Saving Error:' + e);
        }
    }

    /** Create a new Request */
    createNewRequest(event) {
        let newRow = { "Name": "New Request", "cb4__Date1__c": "2020-09-01", "cb4__TextLong1__c": "", "cb4__Decimal1__c": 0 };
        this.showRowDetails(newRow);
    }

    addNewRequestLine(event) {
        this.request.cb4__Elements1__r.push({ "Name": "New Request Line", "cb4__TextLong1__c": "", "cb4__Decimal1__c": 0 });
    }

    updateListOfRelatedFiles(recordId) {
        console.log('-> GET THE LIST OF REQUESTS');
        getListOfRelatedFiles({ recordId })
            .then(result => {
                console.log('-> FILE LIST UPDATED');
                this.attachments = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    closeModal(event) {
        this.isModalOpen = false;
        this.request = undefined;
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        let uploadedFileNames = '';
        for (let i = 0; i < uploadedFiles.length; i++) {
            uploadedFileNames += uploadedFiles[i].name + ', ';
        }
        _fireMessage.success(this, `${uploadedFiles.length} Files uploaded Successfully: ${uploadedFileNames}`, 'Success');

    }


    /*************Page Handlers*************************************************************************/



    /*************Additinal Functions*************************************************************************/


    showRowDetails(row) {
        this.request = JSON.parse(JSON.stringify(row));
        console.log('Request:' + JSON.stringify(row));
        this.isModalOpen = true;
        this.updateListOfRelatedFiles(this.request.Id);
    }

    /**
     * Delete request
     */
    deleteRow(row) {
        //deleteCBRequest
        const { Id } = row;
        if (!confirm('Are you sure?')) return null;
        this.spinOn = true;

        deleteCBRequest({ recordId: Id })
            .then(result => {
                this.warning = result;
                this.updateBudgetRequestList();
                _fireMessage.success(this, 'Deleted', 'Success');
                this.spinOn = false;
            })
            .catch(error => {
                this.error = error;
                this.spinOn = false;
            });
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