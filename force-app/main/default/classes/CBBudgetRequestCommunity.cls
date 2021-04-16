public with sharing class CBBudgetRequestCommunity {

    public static final String BUDGET_REQUEST_DIM_ID = cb4.CBUtils.dimensionNameIdMap.get('Budget Request');
    public static final String BUDGET_REQUEST_LINE_DIM_ID = cb4.CBUtils.dimensionNameIdMap.get('Budget Request Line');

    @AuraEnabled(cacheable = false)
    public static List<Object> getCBRequests() {
        List<cb4__CBTag__c> r = new List<cb4__CBTag__c>();
        r = [
                SELECT Id,Name,cb4__Decimal1__c,cb4__Tag1Name__c,cb4__Tag2Name__c,cb4__Tag3Name__c,cb4__Tag4Name__c,cb4__Tag5Name__c,cb4__Status__c,cb4__Date1__c,
                        cb4__Tag1__c,cb4__Tag2__c,cb4__Tag3__c,cb4__Tag4__c,cb4__Tag5__c,cb4__Tag6__c,
                        cb4__TagLabel__c,Owner.Name,cb4__CBTSatellite__r.cb4__CBTAutoNumber__c,cb4__TextLong1__c,
                (SELECT Id,Name,cb4__Tag1__c,cb4__Decimal1__c,cb4__TextLong1__c FROM cb4__Elements1__r WHERE cb4__Dimension__c = :BUDGET_REQUEST_LINE_DIM_ID)
                FROM cb4__CBTag__c
                WHERE cb4__Dimension__c = :BUDGET_REQUEST_DIM_ID
        ];
        return r;
    }

    @AuraEnabled
    public static String saveCBRequests(cb4__CBTag__c request, List<cb4__CBTag__c> requestLines) {
        try {
            System.debug(request);
            request.cb4__Dimension__c = BUDGET_REQUEST_DIM_ID;
            upsert request;
            // Request lines
            delete [SELECT Id FROM cb4__CBTag__c WHERE cb4__Dimension__c = :BUDGET_REQUEST_LINE_DIM_ID AND cb4__Tag1__c = :request.Id];
            if (requestLines != null) {
                for (cb4__CBTag__c rl : requestLines) {
                    rl.cb4__Tag1__c = request.Id;
                    rl.cb4__Dimension__c = BUDGET_REQUEST_LINE_DIM_ID;
                }
                upsert requestLines;
            }
            System.debug('SAVED request = ' + request);
        } catch (Exception e) {
            return e.getMessage();
        }
        return 'Saved';
    }

    @AuraEnabled
    public static String deleteCBRequest(String recordId) {
        delete [SELECT Id FROM cb4__CBTag__c WHERE Id = :recordId];
        return 'Deleted';
    }

    /////////// SELECT OPTIONS ////////
    @AuraEnabled(cacheable = true)
    public static Map<String, Object> getAnalyticsSO() {
        Map<String, Object> r = new Map<String, Object>();

        List<SO> accounts = new List<SO>();
        for (cb4__CBTag__c f : [SELECT Id, Name, cb4__Text1__c FROM cb4__CBTag__c WHERE cb4__DimensionName__c = 'Account' ORDER BY Name LIMIT 1000]) accounts.add(new SO(f.Id, f.Name));
        r.put('accounts', accounts);

        List<SO> funds = new List<SO>();
        for (cb4__CBTag__c f : [SELECT Id, Name, cb4__Text1__c FROM cb4__CBTag__c WHERE cb4__DimensionName__c = 'Fund' ORDER BY Name LIMIT 1000]) funds.add(new SO(f.Id, f.Name));
        r.put('funds', funds);

        List<SO> program = new List<SO>();
        for (cb4__CBTag__c f : [SELECT Id, Name, cb4__Text1__c FROM cb4__CBTag__c WHERE cb4__DimensionName__c = 'Program' ORDER BY Name LIMIT 1000]) program.add(new SO(f.Id, f.Name));
        r.put('programs', program);

        List<SO> vendor = new List<SO>();
        for (cb4__CBTag__c f : [SELECT Id, Name, cb4__Text1__c FROM cb4__CBTag__c WHERE cb4__DimensionName__c = 'Vendors' ORDER BY Name LIMIT 1000]) vendor.add(new SO(f.Id, f.Name));
        r.put('vendors', vendor);

        return r;
    }
    /////////// SELECT OPTIONS ////////

    /////////// ATTACHMENTS //////////////
    @AuraEnabled(cacheable = true)
    public static List<Object> getListOfRelatedFiles(String recordId) {
        List<ContentDocumentLink> r = new List<ContentDocumentLink>();
        try {
            r = [
                    SELECT Id,
                            ContentDocumentId,
                            ContentDocument.Title
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :recordId
            ];
            return r;
        } catch (Exception e) {
            return null;
        }
    }

    @AuraEnabled(cacheable = false)
    public static List<Object> getCBRequestsOLD() {
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
    /////////// ATTACHMENTS //////////////


    /////////// WRAPPER ////////////////////
    public class SO {

        public SO(String value, String label) {
            this.value = value; // Id
            this.label = label; // Name
        }
        @AuraEnabled public String value { get; set; }
        @AuraEnabled public String label { get; set; }

    }
    /////////// WRAPPER ////////////////////


}