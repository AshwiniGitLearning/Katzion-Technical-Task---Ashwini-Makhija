public with sharing class SyncSalesforceLeadsAPI {
    
    public static HttpResponse createLeads(String requestBody) {
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('callout:ORG_B_Credentials/services/apexrest/LeadManagement/');
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setBody(requestBody);
        req.setMethod('POST'); 
        
        Http h = new Http();
        HttpResponse response = h.send(req);
        
        System.debug('response code: ' + response.getStatusCode());
        System.debug('response body: ' + response.getBody());
        
        return response;
    }
    
}