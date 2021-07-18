/**
 * Created by Alex JR on 7/18/2021.
 */
@isTest
public with sharing class AccountProcessorTest {

    @testSetup
    static void prepareAccounts() {
        //fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
                new List<SObjectType>{
                        Account.SObjectType, Contact.SObjectType
                }
        );

        Account acc = new Account(Name = 'Hello');
        uow.registerNew(acc);
        Contact contactObj = new Contact(LastName = 'A', FirstName = 'B');
        uow.registerNew(contactObj, Contact.AccountId, acc);
        uow.commitWork();
    }

    @isTest
    static void testAccountProcessor() {
        List<Id> testIds = new List<Id>();
        for (Account a : [SELECT Id FROM Account]) {
            testIds.add(a.Id);
        }
        System.assert(testIds.size() > 0);
        Test.startTest();
        AccountProcessor.countContacts(testIds);
        Test.stopTest();
    }

}