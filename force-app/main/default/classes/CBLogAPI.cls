/**
 * Created by Alex JR on 7/10/2021.
 */

@RestResource(urlMapping='/cb4__CBLog__c/*')
global with sharing class CBLogAPI {

    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String logId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        cb4__CBLog__c log = [SELECT Id FROM cb4__CBLog__c WHERE Id = :logId];
        delete log;
    }

    @HttpGet
    global static cb4__CBLog__c doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String logId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        cb4__CBLog__c result = [SELECT Id, Name, cb4__Type__c, cb4__Action__c FROM cb4__CBLog__c WHERE Id = :logId];
        return result;
    }

    @HttpPost
    global static String doPost(String title, String action, String type) {
        cb4__CBLog__c log = new cb4__CBLog__c();
        log.cb4__Title__c = title;
        log.cb4__Action__c = action;
        log.cb4__Type__c = type;
        insert log;
        return log.Id;
    }
}