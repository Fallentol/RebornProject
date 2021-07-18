/**
 * Created by Alex JR on 6/27/2021.
 */
@isTest
public class UnitOfWorkTest {

    private static final String ACCOUNT_NAME = 'Account test 44 ';
    private static final String CONTACT_NAME = 'Contact test 44  ';
    private static final String NOTE_NAME = 'Note test 44 ';


    @isTest static void challengeComplete() {

        // Create a Unit Of Work
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
                new Schema.SObjectType[]{
                        Account.SObjectType,
                        Contact.SObjectType,
                        Note.SObjectType
                }
        );

        for (Integer index = 0; index < 100; index++) {
            Account account = new Account();
            account.Name = ACCOUNT_NAME + index * 2.7;
            account.Description = 'Some words ' + index * 3.5;
            account.BillingCity = 'Denver ' + index * 2.8;
            uow.registerNew(account);
            for (Integer i = 0; i < 5; i++) {
                Contact accountContact = new Contact();
                accountContact.Title = CONTACT_NAME + index + '***' + i;
                accountContact.LastName = 'Denver ' + index * i;

                //uow.registerNew(accountContact);
                Note nt = new Note();
                nt.Title = NOTE_NAME + index + ' : ' + i + ' garbage';
                nt.Body = index + ' -- ' + i;
                uow.registerNew(nt, Note.ParentId, accountContact);
                uow.registerNew(accountContact, Contact.AccountId, account);
            }
        }


        uow.commitWork();

        System.assertEquals(100, [Select Id from Account].size());
        System.assertEquals(500, [Select Id from Contact].size());
        System.assertEquals(500, [Select Id from Note].size());
    }

}