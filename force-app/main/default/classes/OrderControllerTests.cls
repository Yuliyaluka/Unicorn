@isTest
public class OrderControllerTests {

    // Test data setup method
    @testSetup
    static void setup() {
        // Create test data using the TestDataFactory
        TestDataFactory.createTestData();
    }

    // Test for getAccountsWithOrders method
    @isTest
    static void testGetAccountsWithOrders() {
        Test.startTest();
        try {
            List<Account> accountsWithOrders = OrderController.getAccountsWithOrders();
            System.assertNotEquals(0, accountsWithOrders.size(), 'Expected at least one account with orders');
            System.assert(true, 'The getAccountsWithOrders method executed successfully.');
        } catch (Exception e) {
            System.assert(false, 'The getAccountsWithOrders method threw an exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    // Test for getPaymentDueDateMonths method
    @isTest
    static void testGetPaymentDueDateMonths() {
        // Fetch a sample account with orders
        Account testAccount = [SELECT Id FROM Account WHERE Id IN (SELECT Account__c FROM Order__c) LIMIT 1];

        Test.startTest();
        try {
            List<String> paymentDueDateMonths = OrderController.getPaymentDueDateMonths(testAccount.Id);
            System.assertNotEquals(0, paymentDueDateMonths.size(), 'Expected at least one payment due date month');
            System.assert(true, 'The getPaymentDueDateMonths method executed successfully.');
        } catch (Exception e) {
            System.assert(false, 'The getPaymentDueDateMonths method threw an exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    // Test for getOrdersByAccountAndMonth method
    @isTest
    static void testGetOrdersByAccountAndMonth() {
        // Fetch a sample account with orders
        Account testAccount = [SELECT Id FROM Account WHERE Id IN (SELECT Account__c FROM Order__c) LIMIT 1];
        
        // Fetch a sample month
        Integer sampleMonth = 1; // Replace with an actual month number used in your test data
        
        Test.startTest();
        try {
            List<Order__c> orders = OrderController.getOrdersByAccountAndMonth(testAccount.Id, sampleMonth);
            System.assertNotEquals(0, orders.size(), 'Expected at least one order for the given account and month');
            System.assert(true, 'The getOrdersByAccountAndMonth method executed successfully.');
        } catch (Exception e) {
            System.assert(false, 'The getOrdersByAccountAndMonth method threw an exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
}
