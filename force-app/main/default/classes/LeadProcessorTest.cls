/**
 * Created by Alex JR on 7/18/2021.
 */
@isTest
public with sharing class LeadProcessorTest {

    @testSetup
    static void setupData() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
                new List<SObjectType>{
                        Lead.SObjectType
                }
        );
        for (Integer i = 0; i < 200; i++) uow.registerNew(new Lead(City = 'Hel' + i + 'lo', LastName = 'Oleg' + i, Company = 'Triol'));
        uow.commitWork();
    }

    @isTest
    static void testJob() {
        Test.startTest();
        LeadProcessor job = new LeadProcessor();
        Database.executeBatch(job);
        Test.stopTest();

        System.assertEquals(200, [select count() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }


}