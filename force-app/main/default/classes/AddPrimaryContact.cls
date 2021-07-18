/**
 * Created by Alex JR on 7/18/2021.
 */

public with sharing class AddPrimaryContact implements Queueable {

    private String abbr;
    private Contact contactBase;

    public AddPrimaryContact(Contact contact, String abbr) {
        this.contactBase = contact;
        this.abbr = abbr;
    }

    public void execute(QueueableContext context) {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
                new List<SObjectType>{
                        Account.SObjectType, Contact.SObjectType
                }
        );
        for (Account account : [SELECT Id FROM Account WHERE BillingState = :abbr]) {
            Contact cnt = contactBase.clone(false, false, false);
            uow.registerNew(cnt, Contact.AccountId, account);
        }
        uow.commitWork();
    }

}