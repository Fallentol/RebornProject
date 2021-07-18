/**
 * Created by Alex JR on 7/18/2021.
 */
@isTest
public with sharing class AddPrimaryContactTest {

    @TestSetup
    static void prepareData() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
                new List<SObjectType>{
                        Account.SObjectType, Contact.SObjectType
                }
        );
        for (Integer i = 0; i < 100; i++) {
            Account acc = new Account(Name = 'Test' + i, BillingState = i < 50 ? 'NY' : 'CA');
            uow.registerNew(acc);
        }
        uow.commitWork();
    }

    @isTest
    static void testPrimaryContact() {
        Test.startTest();
        Contact ctn = new Contact(FirstName = 'Top', LastName = 'Gear');
        insert ctn;
        System.enqueueJob(new AddPrimaryContact(ctn, 'CA'));
        Test.stopTest();

        System.assert(50 == [SELECT count() FROM Contact WHERE Account.BillingState = 'CA']);
    }

}