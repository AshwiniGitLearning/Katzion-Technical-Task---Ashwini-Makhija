@isTest
public class RestAPI_LeadManagement_Test {
	
    @isTest
    public static void createLeads_Test(){
        
        List<Lead> leadsToInsert = TestDataFactory.createLeads(20, 'Smith', 'Katzion', false);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/LeadManagement/'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(leadsToInsert));
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        List<Lead> leadList = RestAPI_LeadManagement.createLeads();
        System.assertEquals(20, leadList.size(), 'One Lead must be created');
        System.assertEquals('Katzion0', leadList[0].Company, 'Company name must be Katzion');
		Test.stopTest();
        
    }
    
}