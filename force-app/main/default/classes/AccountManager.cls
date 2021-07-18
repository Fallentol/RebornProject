/**
 * Created by Alex JR on 7/11/2021.
 * /Accounts/<Account_ID>/contacts
 */

@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {

    @HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/') - 18).replace('/contacts', '');
        System.debug('ACCOUNT ID = ' + accountId);
        Account result = [
                SELECT Id, Name, (SELECT Id, Name, LastName, FirstName FROM Contacts)
                FROM Account
                WHERE Id = :accountId
        ];
        return result;
    }

}