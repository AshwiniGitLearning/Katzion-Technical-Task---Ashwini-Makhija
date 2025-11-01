@isTest
public class LeadsLWC_Controller_Test {
    
    @testSetUp
    public static void createTestData(){
        TestDataFactory.createLeads(20, 'Smith', 'Katzion', true);
    }
    
    @isTest
    public static void getLeads_Test(){
        Test.startTest();
        List<Lead> ldList = LeadsLWC_Controller.getLeads();
        System.assertEquals(20, ldList.size(), 'Total 20 leads must be retrieved.');
        Test.stopTest();
    }
    
    @isTest
    public static void syncLeads_Test(){
        Test.setMock(HttpCalloutMock.class, new HttpMockResponseGenerator());
        Test.startTest();
        
        List<Lead> leadList = [SELECT Id, LastName, Company FROM Lead];
        String jsonReq = JSON.serialize(leadList);
        LeadsLWC_Controller.apiResultWrapper wrapIns = LeadsLWC_Controller.syncLeads(jsonReq);
        
        System.assertEquals('Success', wrapIns.resStatus, 'Lead Sync Status Success');
        System.assertEquals('Leads Synced Successfully', wrapIns.resMessage, 'Leads Synced Successfully');
        
        Test.stopTest();
    }
}