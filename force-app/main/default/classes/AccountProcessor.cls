/**
 * Created by Alex JR on 7/18/2021.
 */

global with sharing class AccountProcessor {

    @future
    global static void countContacts(List<Id> accIds) {
        List<Account> accounts = new List<Account>();
        for (Account a : [
                SELECT Id, (SELECT Id FROM Contacts)
                FROM Account
                WHERE Id IN:new Set<Id>(accIds)

                LIMIT 10000
        ]) {
            a.Number_Of_Contacts__c = a.Contacts.size();
            accounts.add(a);
        }
        update accounts;
    }

}