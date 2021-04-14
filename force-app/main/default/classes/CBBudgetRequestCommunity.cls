public with sharing class CBBudgetRequestCommunity {

    @AuraEnabled(cacheable = false)
    public static List<Object> getCBRequests() {
        List<BudgetRequest__c> r = new List<BudgetRequest__c>();
        try {
            r = [
                    SELECT Id, Name, Title__c, InactDate__c, Description__c, Amount__c
                    FROM BudgetRequest__c
            ];
            return r;
        } catch (Exception e) {
            r.add(new BudgetRequest__c(Title__c = e.getMEssage()));
            return r;
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<Object> getListOfRelatedFiles(String recordId) {
        List<ContentDocumentLink> r = new List<ContentDocumentLink>();
        try {
            r = [
                    SELECT Id,
                            ContentDocumentId,
                            ContentDocument.Title
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = 'a0H3t00000MMu5FEAT'
            ];
            return r;
        } catch (Exception e) {
            return null;
        }
    }

    @AuraEnabled
    public static String saveCBRequests(BudgetRequest__c request) {
        System.debug(request);
        upsert request;
        return 'Saved';
    }

    @AuraEnabled
    public static String deleteCBRequest(String recordId) {
        delete [SELECT Id FROM BudgetRequest__c WHERE Id = :recordId];
        return 'Deleted';
    }
}