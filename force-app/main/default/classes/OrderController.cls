public with sharing class OrderController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account WHERE Id IN (SELECT Account__c FROM Order__c)];
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getMonths(Id accountId) {
        List<String> months = new List<String>();
        for (AggregateResult ar : [SELECT CALENDAR_MONTH(Payment_Due_Date__c) month 
                                   FROM Order__c 
                                   WHERE Account__c = :accountId 
                                   GROUP BY CALENDAR_MONTH(Payment_Due_Date__c)]) {
            months.add(String.valueOf(ar.get('month')));
        }
        return months;
    }

    @AuraEnabled(cacheable=true)
    public static List<Order__c> getOrders(Id accountId, String month) {
        String query = 'SELECT Id, Name, Total_Amount__c, Payment_Due_Date__c ' +
                       'FROM Order__c ' +
                       'WHERE Account__c = :accountId';
        if (String.isNotBlank(month)) {
            query += ' AND CALENDAR_MONTH(Payment_Due_Date__c) = ' + Integer.valueOf(month);
        }
        return Database.query(query);
    }
}