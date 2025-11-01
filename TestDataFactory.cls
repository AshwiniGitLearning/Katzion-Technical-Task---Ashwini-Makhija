@isTest
public class TestDataFactory {

    public static List<Lead> createLeads(Integer totalLeads, String LastName, String CompanyName, Boolean insertLeads){
        List<Lead> leadsToInsert = new List<Lead>();
        for(Integer i = 0; i < totalLeads; i++){
            Lead newLd = new Lead();
            newLd.LastName = LastName + String.valueof(i);
            newLd.Company = CompanyName + String.valueof(i);
            leadsToInsert.add(newLd);
        }
        
        if(insertLeads){
            insert leadsToInsert;
        }
        
        return leadsToInsert;
    }
}