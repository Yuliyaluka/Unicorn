public inherited sharing class TestDataFactory {

    public static void createTestData() {
        List<Account> accounts = createTestAccounts(5);

        List<Order__c> orders = new List<Order__c>();
        Integer ordersPerAccount = 40 / accounts.size(); // Calculate how many orders per account

        for (Account acc : accounts) {
            List<Order__c> accountOrders = createOrdersForAccount(acc, ordersPerAccount);
            orders.addAll(accountOrders);
        }

        // Insert all orders
        insert orders;
    }

    private static List<Account> createTestAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < numAccounts; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;
        return accounts;
    }

    private static List<Order__c> createOrdersForAccount(Account acc, Integer numOrders) {
        List<Order__c> orders = new List<Order__c>();
        Date baseDueDate = Date.today().addDays(1); // Start with tomorrow's date

        for (Integer i = 0; i < numOrders; i++) {
            orders.add(new Order__c(
                Name = 'Order ' + (i + 1) + ' for ' + acc.Name,
                Total_Amount__c = 100 + i, // Example amount
                Payment_Due_Date__c = baseDueDate.addDays(i * 2), // Vary due date
                Account__c = acc.Id
            ));
        }
        return orders;
    }
}