@isTest
public class SyncSalesforceLeadsAPI_Test {
    
    public static List<Lead> leadList;

    @testSetUp
    public static void createTestData(){
        leadList = TestDataFactory.createLeads(20, 'Smith', 'Katzion', false);
    }
    
    @isTest
    public static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new HttpMockResponseGenerator());
        Test.startTest();
        
        String reqStr = JSON.serialize(leadList);
        HttpResponse res = SyncSalesforceLeadsAPI.createLeads(reqStr);
        
        System.assertEquals('application/json', res.getHeader('Content-Type'), 'Asserting Content type');
        System.assertEquals('{"Records Status":"Records Created Successfully"}', res.getBody(), 'Should return mock success message');
        System.assertEquals(200, res.getStatusCode());
        
        Test.stopTest();
    }
}