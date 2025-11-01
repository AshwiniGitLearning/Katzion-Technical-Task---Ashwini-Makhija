@isTest
public class LeadController_Test{
    
    @isTest
    public static void noTotalLeads_Test(){
        Test.startTest();
        try{
            LeadController.createLeads(null, 'Robert', 'Smith', 'Katzion', 'Web', null, null);
        }
        catch(Exception ex){
            System.assertEquals('Required input missing/incorrect - Please mention total leads (greater than 0)',ex.getMessage(),'Total leads is required');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void noFirstName_Test(){
        Test.startTest();
        try{
            LeadController.createLeads(30, ' ', 'Smith', 'Katzion', 'Web', null, null);
        }
        catch(Exception ex){
            System.assertEquals('Required input missing - Please mention First Name',ex.getMessage(),'First Name is required');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void noLastName_Test(){
        Test.startTest();
        try{
            LeadController.createLeads(30, 'Robert', null, 'Katzion', 'Web', null, null);
        }
        catch(Exception ex){
            System.assertEquals('Required input missing - Please mention Last Name',ex.getMessage(),'Last Name is required');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void noCompanyName_Test(){
        Test.startTest();
        try{
            LeadController.createLeads(30, 'Robert', 'Smith', '', 'Web', null, null);
        }
        catch(Exception ex){
            System.assertEquals('Required input missing - Please mention Company Name',ex.getMessage(),'Company Name is required');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void createLeadsWithDefaults_Test(){
        Test.startTest();
        LeadController.createLeads(30, 'Robert', 'Smith', 'Katzion', null, null, null);
        List<Lead> ld_List = [SELECT Id, LeadSource, Industry, Rating FROM Lead];
        System.assertEquals(30, ld_List.size(),'30 leads must be created');
        System.assertEquals('Other' , ld_List[0].LeadSource, 'By default LeadSource must be set as Other');
        System.assertEquals('Other' , ld_List[0].Industry, 'By default Industry must be set as Other');
        System.assertEquals('Cold' , ld_List[0].Rating, 'By default Rating must be set as Other');
        Test.stopTest();
    }
    
    @isTest
    public static void createLeadsWithInputs_Test(){
        Test.startTest();
        LeadController.createLeads(50, 'Robert', 'Smith', 'Katzion', 'Web', 'Agriculture', 'Warm');
        List<Lead> ld_List = [SELECT Id, LeadSource, Industry, Rating FROM Lead];
        System.assertEquals(50, ld_List.size(),'30 leads must be created');
        System.assertEquals('Web' , ld_List[0].LeadSource, 'LeadSource must be set as Web');
        System.assertEquals('Agriculture' , ld_List[0].Industry, 'Industry must be set as Agriculture');
        System.assertEquals('Warm' , ld_List[0].Rating, 'Rating must be set as Warm');
        Test.stopTest();
    }

}