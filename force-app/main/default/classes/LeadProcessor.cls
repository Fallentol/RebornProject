/**
 * Created by Alex JR on 7/18/2021.
 */

public with sharing class LeadProcessor implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id FROM Lead');
    }
    public void execute(Database.BatchableContext bc, List<Lead> leads) {
        for (Lead lead : leads) {
            lead.LeadSource = 'Dreamforce'; 
        }
        update leads;
    }
    public void finish(Database.BatchableContext bc) {
    }

}