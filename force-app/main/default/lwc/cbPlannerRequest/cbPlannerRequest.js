import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getBudgetRequestList from '@salesforce/apex/CBBudgetRequestCommunity.getCBRequests';
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
    @api recordId;
    request;
    attachments;
    columns = columns;
    isModalOpen = false;
    data = [];
    get acceptedFormats() {
        return ['.pdf', '.png', '.txt', '.docx'];
    }

    /**
     * Instead of doInit
     */
    connectedCallback(objectApiName) {
        this.updateBudgetRequestList();
    }

    runST() {
        try {
            let t = _fireMessage;
            alert(_isInvalid(t));
            _fireMessage.error(this, 'Some Lib');
            _cl('Hello LWC', 'gold');
        } catch (e) {
            alert("ERROR: " + e);
        }

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
        console.log('Try to saveRequest ' + JSON.stringify(this.request));
        try {
            saveCBRequests({ request: this.request })
                .then(result => {
                    try {
                        this.warning = result;
                        this.updateBudgetRequestList();
                        this.closeModal();

                        _fireMessage.success(this, 'Saved', 'Success');
                    } catch (e) {
                        alert('ERROR:' + e);
                    }
                })
                .catch(error => {
                    this.error = error;
                });
        } catch (e) {
            alert('Saving Error:' + e);
        }
    }

    /** Create a new Request */
    createNewRequest(event) {
        let newRow = { "Title__c": "New Request", "InactDate__c": "2020-09-01", "Description__c": "", "Amount__c": 0 };
        this.showRowDetails(newRow);
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

        deleteCBRequest({ recordId: Id })
            .then(result => {
                this.warning = result;
                this.updateBudgetRequestList();
                _fireMessage.success(this, 'Deleted', 'Success');
            })
            .catch(error => {
                this.error = error;
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