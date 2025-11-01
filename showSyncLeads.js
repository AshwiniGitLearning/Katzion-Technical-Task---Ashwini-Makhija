import { LightningElement, track , wire} from 'lwc';
import get_All_Leads from '@salesforce/apex/LeadsLWC_Controller.getLeads';
import sync_Leads from '@salesforce/apex/LeadsLWC_Controller.syncLeads';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

let leads_Table_Columns = [
    {label : 'First Name', fieldName : 'FirstName'},
    {label : 'Last Name', fieldName : 'LastName'},
    {label : 'Company', fieldName : 'Company'},
    {label : 'Lead Source', fieldName : 'LeadSource'},
    {label : 'Industry', fieldName : 'Industry'},
    {label : 'Rating', fieldName : 'Rating'}
];

let LeadPerPageOptions = [
    {label : '10', value : '10'},
    {label : '20', value : '20'},
    {label : '30', value : '30'},
    {label : '40', value : '40'},
    {label : '50', value : '50'}
];

let leadsToSyncOptions = [
    {label : 'Available on this page only', value : 'Available on this page only'},
    {label : 'All leads that match the filters', value : 'All leads that match the filters'},
    {label : 'All leads in the org', value : 'All leads in the org'}
];

export default class ShowSyncLeads extends LightningElement {

    @track showSpinner = true;
    @track showLeadsTable = false;
    @track noLeadsFound = false;
    @track all_Leads = [];
    @track filtered_Leads = [];
    @track paginated_Leads = [];
    @track tableColumns = leads_Table_Columns;
    @track LeadPerPageOptions = LeadPerPageOptions;
    @track LeadsPerPage = 10;
    @track leadsPerPageUI = '10';
    @track currentPage = 1;
    @track totalPages = 0;
    @track namefilter = '';
    @track sourcefilter = '';
    @track noLeadsFoundMessage = 'No Leads found';
    @track leadsToSyncOptions = leadsToSyncOptions;
    @track leadsToSync = 'Available on this page only';
    @track openLeadsToSyncModal = false;
    
    @wire(get_All_Leads)
    wiredLeads({data, error}){
        if(data) {
            this.all_Leads = data;
            this.filtered_Leads = data;
            this.showLeadsTable = this.filtered_Leads.length > 0 ? true : false;
            this.noLeadsFound = this.filtered_Leads.length < 1 ? true : false;
            this.totalPages = Math.ceil(this.filtered_Leads.length / this.LeadsPerPage);
            this.handlePagination();
        }
    }

    handlePagination(){
        let startIndex = (this.currentPage - 1) * this.LeadsPerPage;
        let endIndex = startIndex + this.LeadsPerPage;
        this.paginated_Leads = this.filtered_Leads.slice(startIndex, endIndex);
        this.showSpinner = false;
    }


    handlePrevious(){
        if(this.currentPage > 1){
            this.showSpinner = true;
            this.currentPage = this.currentPage - 1;
            this.handlePagination();
        }
    }

    handleNext(){
        if(this.currentPage < this.totalPages){
            this.showSpinner = true;
            this.currentPage = this.currentPage + 1;
            this.handlePagination();
        }
    }

    get disablePrevious() {
        return this.currentPage === 1;
    }

    get disableNext() {
        return this.currentPage === this.totalPages;
    }

    filterLeadsByName(event){
        this.namefilter = event.detail.value;
        this.filterLeads();
    }

    filterLeadsBySource(event){
        this.sourcefilter = event.detail.value;
        this.filterLeads();
    }

    filterLeads(){
        if((this.namefilter === null || this.namefilter.trim().length === 0) && (this.sourcefilter === null || this.sourcefilter.trim().length === 0)){
            this.showSpinner = true;
            this.filtered_Leads = this.all_Leads;
            this.showLeadsTable = this.filtered_Leads.length > 0 ? true : false;
            this.noLeadsFound = this.filtered_Leads.length < 1 ? true : false;
            this.noLeadsFoundMessage = this.filtered_Leads.length < 1 ? 'No leads found with specified filters' : 'No Leads found';
            this.totalPages = Math.ceil(this.filtered_Leads.length / this.LeadsPerPage);
            this.handlePagination();
        }
        else{
            this.filterLeadsByParameters();
        }
    }

    filterLeadsByParameters(){
        this.showSpinner = true;
        if(this.namefilter !== null && this.namefilter.trim().length > 0 && this.sourcefilter !== null && this.sourcefilter.trim().length > 0){
            this.filtered_Leads = this.all_Leads.filter(ld =>
                    ((ld.FirstName.toLowerCase().includes(this.namefilter.toLowerCase()) ||
                    ld.LastName.toLowerCase().includes(this.namefilter.toLowerCase())) && ld.LeadSource.toLowerCase().includes(this.sourcefilter.toLowerCase()))
                );
        }

        else if(this.namefilter !== null && this.namefilter.trim().length > 0 && (this.sourcefilter === null || this.sourcefilter.trim().length === 0)){
            this.filtered_Leads = this.all_Leads.filter(ld =>
                    (ld.FirstName.toLowerCase().includes(this.namefilter.toLowerCase()) ||
                    ld.LastName.toLowerCase().includes(this.namefilter.toLowerCase()))
                );
        }

        else if(this.sourcefilter !== null && this.sourcefilter.trim().length > 0 && (this.namefilter === null || this.namefilter.trim().length === 0)){
            this.filtered_Leads = this.all_Leads.filter(ld =>
                    ld.LeadSource.toLowerCase().includes(this.sourcefilter.toLowerCase())
                );
        }
        this.showLeadsTable = this.filtered_Leads.length > 0 ? true : false;
        this.noLeadsFound = this.filtered_Leads.length < 1 ? true : false;
        this.noLeadsFoundMessage = this.filtered_Leads.length < 1 ? 'No leads found with specified filters' : 'No Leads found';
        this.totalPages = Math.ceil(this.filtered_Leads.length / this.LeadsPerPage);
        this.handlePagination();
    }

    handleLeadsPerPageChange(event){
        this.showSpinner = true;
        this.leadsPerPageUI = event.detail.value;
        this.LeadsPerPage = parseInt(event.detail.value);
        console.log(this.LeadsPerPage)
        this.totalPages = Math.ceil(this.filtered_Leads.length / this.LeadsPerPage);
        this.handlePagination();
    }

    syncLeads(){
        this.openLeadsToSyncModal = true;
        this.leadsToSync = 'Available on this page only';
    }

    handleleadsToSyncChange(event){
        this.leadsToSync = event.detail.value;
    }

    handleLeadsToSyncCancel(){
        this.openLeadsToSyncModal = false;
    }

    handleSyncLeadsByInput(){
        this.openLeadsToSyncModal = false;
        this.showSpinner = true;
        if(this.leadsToSync === 'Available on this page only'){
            this.syncLeadsAPI(this.paginated_Leads);
        }
        else if(this.leadsToSync === 'All leads that match the filters'){
            if((this.namefilter === null || this.namefilter.trim().length === 0) && (this.sourcefilter === null || this.sourcefilter.trim().length === 0)){
                this.showToast('Error Syncing Leads', 'No lead filters specified', 'error');
                this.showSpinner = false;
            }
            else{
                this.syncLeadsAPI(this.filtered_Leads);
            }
        }
        else if(this.leadsToSync === 'All leads in the org'){
            this.syncLeadsAPI(this.all_Leads);
        }
    }

    syncLeadsAPI(leadList){
        sync_Leads({jsonRequest : JSON.stringify(leadList)})
        .then(result => {
            if(result.resStatus === 'Success'){
                this.showToast('Success', result.resMessage, 'success');
            }
            else{
                this.showToast('Error Syncing Leads', result.resMessage, 'error');
            }
            this.showSpinner = false;
        })
        .catch(error =>{
            this.showToast('Error Syncing Leads', JSON.stringify(error), 'error');
            this.showSpinner = false;
        });
    }

    showToast(title, message, variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

}