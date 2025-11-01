public class LeadController {
    
    public static void createLeads(Integer totalLeads, String leadFN, String leadLN, String leadCN, String leadSrc, String leadInd, String leadRating){
        
        checkRequiredInputs(totalLeads, leadFN, leadLN, leadCN);
        List<Lead> newLdList = new List<Lead>();
        
        for(Integer i = 0; i < totalLeads; i++){
            Lead newLd = new Lead();
            newLd.FirstName = (i == 0) ? leadFN : leadFN + String.valueof(i);
            newLd.LastName = (i == 0) ? leadLN : leadLN + String.valueof(i);
            newLd.Company = (i == 0) ? leadCN : leadCN + String.valueof(i);
            newLd.LeadSource = String.isBlank(leadSrc) ? 'Other' : leadSrc;
            newLd.Industry = String.isBlank(leadInd) ? 'Other' : leadInd;
            newLd.Rating = String.isBlank(leadRating) ? 'Cold' : leadRating;
            newLdList.add(newLd);
        }
        insert newLdList;
        
    }
    
    public static void checkRequiredInputs(Integer totalLeads, String leadFN, String leadLN, String leadCN){
        
        if(totalLeads <= 0 || totalLeads == null){
            throw new requiredInputMissingException('Required input missing/incorrect - Please mention total leads (greater than 0)');
        }
        if(String.isBlank(leadFN)){
            throw new requiredInputMissingException('Required input missing - Please mention First Name');
        }
        if(String.isBlank(leadLN)){
            throw new requiredInputMissingException('Required input missing - Please mention Last Name');
        }
        if(String.isBlank(leadCN)){
            throw new requiredInputMissingException('Required input missing - Please mention Company Name');
        }
    }
    
}