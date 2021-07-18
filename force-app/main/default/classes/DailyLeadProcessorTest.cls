/**
 * Created by Alex JR on 7/18/2021.
 */
@isTest
public with sharing class DailyLeadProcessorTest {

    @TestSetup
    static void prepareData() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
                new List<SObjectType>{
                        Lead.SObjectType, Contact.SObjectType
                }
        );
        for (Integer i = 0; i < 200; i++) {
            uow.registerNew(new Lead(City = 'Hel' + i + 'lo', LastName = 'Oleg' + i, Company = 'Triol'));
        }
        uow.commitWork();
    }

    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    @isTest
    static void testPrimaryContact() {
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
                CRON_EXP,
                new DailyLeadProcessor());
        Test.stopTest();

        System.assert(200 == [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }

}