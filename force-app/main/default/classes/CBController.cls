public with sharing class CBController {

    public static String testStaticValue;

    public CBController() {

    }

    @AuraEnabled(cacheable = true)
    public static List<Account> getAccounts(String name) {
        System.debug('accountName = ' + name);
        String q = 'SELECT Id, Name FROM Account ';
        if (name != null && name != '')
            q += ' WHERE Name LIKE \'%' + name + '%\'';
        return Database.query(q);
    }

    public static void cg() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}