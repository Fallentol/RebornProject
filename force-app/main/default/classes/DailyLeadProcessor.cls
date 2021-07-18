/**
 * Created by Alex JR on 7/18/2021.
 */

global class DailyLeadProcessor implements Schedulable {
    global void execute(SchedulableContext ctx) {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
                new List<SObjectType>{
                        Account.SObjectType, Contact.SObjectType
                }
        );
        List<Lead> emptyLeads = [SELECT Id FROM Lead WHERE LeadSource = null];
        for (Lead l : emptyLeads) {
            l.LeadSource = 'Dreamforce';
        }
        update emptyLeads;
    }
}