/**
 * Created by Alex JR on 7/3/2021.
 */

public with sharing class Accounts extends fflib_SObjectDomain {
    public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }

    public override void onApplyDefaults() {
        for (Account account : (List<Account>) Records) {
            if (account.Description == null) {
                account.Description = 'Domain classes rock!';
            }
        }
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        String str = 'Domain classes rock!';
        for (Account acc : (List<Account>) Records) {
            acc.AnnualRevenue = str.getLevenshteinDistance(acc.Description);
        }
    }
}