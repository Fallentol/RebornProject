/**
 * Created by Alex JR on 7/11/2021.
 */
@isTest
public class AccountManagerTest {

    @isTest static void testGetAccountById() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = 'https://cloud2demo-dev-ed.lightning.force.com/services/apexrest/Accounts/' + recordId + '/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = AccountManager.getAccount();
        System.debug(thisAccount);
        System.debug(thisAccount.Contacts);
        // Verify results
        System.assert(thisAccount != null);
        System.assertEquals('Test record', thisAccount.Name);
    }


    static Id createTestRecord() {
        Account accountTest = new Account(
                Name = 'Test record');
        insert accountTest;
        Contact con = new Contact(FirstName = 'Hui', LastName = 'Morzoviy', AccountId = accountTest.Id);
        Contact con2 = new Contact(FirstName = 'Hui2', LastName = 'Morzoviy2', AccountId = accountTest.Id);
        insert con;
        insert con2;
        return accountTest.Id;
    }
}