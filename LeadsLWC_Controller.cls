public with sharing class LeadsLWC_Controller {
    
    @AuraEnabled(Cacheable=true)
    public static List<Lead> getLeads(){
        return [SELECT Id, FirstName, LastName, Company, LeadSource, Industry, Rating FROM Lead];
    }

    @AuraEnabled
    public static apiResultWrapper syncLeads(String jsonRequest){
        
        apiResultWrapper wrapIns = new apiResultWrapper();
        List<Lead> leadsList = (List<Lead>) JSON.deserialize(jsonRequest, List<Lead>.class);
        List<Lead> leadsToInsert = new List<Lead>();
        
        for(Lead ldRec : leadsList){
            Lead tempRec = new Lead();
            tempRec.FirstName = ldRec.FirstName;
            tempRec.LastName = ldRec.LastName;
            tempRec.Company = ldRec.Company;
            tempRec.LeadSource = ldRec.LeadSource;
            tempRec.Industry = ldRec.Industry;
            tempRec.Rating = ldRec.Rating;
            leadsToInsert.add(tempRec);
        }
        
        String reqStr = JSON.serialize(leadsToInsert);
        HttpResponse res = SyncSalesforceLeadsAPI.createLeads(reqStr);
        wrapIns.resStatus = res.getStatusCode() == 200 ? 'Success' : 'Error';
        wrapIns.resMessage = res.getStatusCode() == 200 ? 'Leads Synced Successfully' : res.getBody();
        return wrapIns;
    }
    
    public class apiResultWrapper{
        @AuraEnabled
        public String resStatus{get; set;}
        @AuraEnabled
        public String resMessage{get;set;}
    }
}