public with sharing class CBalanceController {


    public static String testMe() {
        return 'Just test';
    }
    /**
     * Method returns a list of CBalance Rules if ruleIds = null 
     * @param ruleIds list of needed Rules
     * @return
     */
    @AuraEnabled
    public static List<cb4__CBalanceRule__c> getCBalanceRulesServer(List<String> ruleIds) {
        String filter = ruleIds == null || ruleIds.size() == 0 ? '' : ' WHERE Id IN ' + cb4.CBUtils.getFormattedINQuery(new Set<String>(ruleIds)) ;
        String q = 'SELECT ' + cb4.CBUtils.getAllSObjectFields('cb4__CBalanceRule__c', null) + filter + ' ORDER BY Name LIMIT 50000 ';
        List<cb4__CBalanceRule__c> r = Database.query(q);
        return r;
    }

    @AuraEnabled
    public static List<sObject> getFolderStructureServer() {
        List<sObject> r = new List<SObject>();
        String fq = 'SELECT ' + cb4.CBUtils.getAllSObjectFields('cb4__CBFolder__c', null) + ' WHERE Type__c = \'CBalance Rule\' ORDER BY Name LIMIT 1000';
        String rq = 'SELECT ' + cb4.CBUtils.getAllSObjectFields('cb4__CBalanceRule__c', null) + 'ORDER BY Name LIMIT 1000';
        r.addAll(Database.query(fq));
        r.addAll(Database.query(rq));
        return r;
    }

    @AuraEnabled
    public static String saveCBalanceRuleServer(cb4__CBalanceRule__c CBalanceRule) {
        String validMessage = validateCBalanceRule(CBalanceRule);
        if (validMessage != null) return 'WARNING! ' + validMessage;
        upsert CBalanceRule;
        return CBalanceRule.Id;
    }

    /**
     *
     * @param deleteCBalanceServer CBalance Rule Id
     *
     * @return
     */
    @AuraEnabled
    public static String deleteCBalanceRuleServer(Id CBalanceId) {
        delete [SELECT Id FROM cb4__CBalanceRule__c WHERE Id = :CBalanceId];
        return 'ok';
    }

    public static List<cb4__CBalanceRule__c> getApplicableCBalanceRules(cb4__CBTag__c t) {
        List<cb4__CBalanceRule__c> result = new List<cb4__CBalanceRule__c>();
        for (cb4__CBalanceRule__c r : getCBalanceRulesServer(null)) {
            if (r.cb4__DimensionType__c != t.cb4__Dimension__c) continue;
            if (r.cb4__TagFilter__c != null && r.cb4__TagFilter__c.contains('=')) {
                List<String> tagFilter = r.cb4__TagFilter__c.split('=');
                String field = tagFilter[0].trim();
                String value = tagFilter[1].trim();
                if ((String) t.get(field) != value) continue;
            }
            result.add(r);
        }
        return result;
    }

    /**
     * @param br CBalance Rule
     *
     * @return query string for getting properly CBTags
     */
    public static String getCBTagsQueryFromCBalanceRule(cb4__CBalanceRule__c br) {
        Set<String> unique = new Set<String>();
        unique.add('OwnerId');
        unique.add(br.cb4__Lvl1Field__c);
        unique.add(br.cb4__Lvl2Field__c);
        unique.add(br.cb4__Lvl3Field__c);
        unique.add(br.cb4__Lvl4Field__c);
        unique.add(br.cb4__Lvl5Field__c);
        unique.add(br.cb4__Lvl6Field__c);
        unique.add(br.cb4__Lvl7Field__c);
        unique.add(br.cb4__DrillDownField__c);
        unique.add(br.cb4__ColumnField__c);
        unique.add(br.cb4__AmountField__c);
        unique.add(br.cb4__Amount1Filter__c == null || br.cb4__Amount1Filter__c == '' ? null : br.cb4__Amount1Filter__c.split('=')[0]);
        unique.add(br.cb4__Amount2Filter__c == null || br.cb4__Amount2Filter__c == '' ? null : br.cb4__Amount2Filter__c.split('=')[0]);
        unique.add(br.cb4__Amount3Filter__c == null || br.cb4__Amount3Filter__c == '' ? null : br.cb4__Amount3Filter__c.split('=')[0]);
        unique.add(br.cb4__Amount4Filter__c == null || br.cb4__Amount4Filter__c == '' ? null : br.cb4__Amount4Filter__c.split('=')[0]);
        unique.add(br.cb4__Amount5Filter__c == null || br.cb4__Amount5Filter__c == '' ? null : br.cb4__Amount5Filter__c.split('=')[0]);
        unique.add(br.cb4__MinusCondition__c == null || br.cb4__MinusCondition__c == '' || br.cb4__MinusCondition__c == '-' ? null : br.cb4__MinusCondition__c.split('=')[0]);

        String Q_SELECT = 'SELECT ';
        for (String s : unique) if (s != null && s != '') Q_SELECT = Q_SELECT == 'SELECT ' ? Q_SELECT + s : Q_SELECT + ', ' + s;
        String Q_FROM = ' FROM cb4__CBTag__c ';
        String Q_WHERE = ' WHERE cb4__Dimension__c = \'' + br.cb4__DimensionType__c + '\' ';
        Q_WHERE += !cb4.CBUtils.isValidId(br.cb4__TagFilter__c) ? '' : ' AND ' + br.cb4__TagFilter__c;
        Q_WHERE += ' AND ' + br.cb4__AmountField__c + ' != null AND ' + br.cb4__AmountField__c + ' != 0 ' ;
        Q_WHERE += ' AND ' + br.cb4__ColumnField__c + ' != null';

        String result = Q_SELECT + Q_FROM + Q_WHERE;
        return result;
    }

    /////// SELECT OPTIONS ///////
    @AuraEnabled
    public static List<cb4.CBSO> getCBalanceRulesSOServer() {
        List<cb4.CBSO> r = new List<cb4.CBSO>();
        for (cb4__CBalanceRule__c rule : getCBalanceRulesServer(null)) r.add(new cb4.CBSO(rule.Id, rule.cb4__Label__c));
        return r;
    }
    /////// SELECT OPTIONS ///////

    /////// PRIVATE METHODS ///////
    private static String validateCBalanceRule(cb4__CBalanceRule__c CBalanceRule) {
        String q = getCBTagsQueryFromCBalanceRule(CBalanceRule);
        try {
            List<Object> t = Database.query(q);
        } catch (Exception e) {
            return e.getMessage();
        }
        return null;
    }
    /////// PRIVATE METHODS ///////


}