public with sharing class CBBudgetRequestCommunity{ 
	@AuraEnabled(cacheable = true)
	public static List<BudgetRequest__c> getCBRequests(){
		List<BudgetRequest__c> r = new List<BudgetRequest__c>();
		try{
			r = [SELECT Id, Name, Title__c, InactDate__c, Description__c, Amount__c
			     FROM BudgetRequest__c];
			return r;
		} catch (Exception e){
			r.add(new BudgetRequest__c(Title__c = e.getMEssage()));
			return r;
		}
	}

	@AuraEnabled
	public static String saveCBRequests(BudgetRequest__c request){
		System.debug(request);
		upsert request;
		return 'Saved';
	}
}