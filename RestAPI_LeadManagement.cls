@RestResource(urlMapping='/LeadManagement/*')
global with sharing class RestAPI_LeadManagement {
    
    @HttpPost
    global static List<Lead> createLeads(){
        RestRequest req = RestContext.request;
		String requestBody = req.requestBody.toString();
		List<Lead> leadsToInsert = (List<Lead>) JSON.deserialize(requestBody, List<Lead>.class);
        insert leadsToInsert;
        return leadsToInsert;
    }
   
}