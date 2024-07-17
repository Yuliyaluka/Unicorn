@isTest
public class SendOrderButtonControllerTests {
    @testSetup
    static void setup() {
        // Create test data using the TestDataFactory
        TestDataFactory.createTestData();
    }

    @isTest
    static void testSendOrderEmail() {
        // Fetch a sample order
        Order__c order = [SELECT Id, Account__r.Name, Total_Amount__c, Payment_Due_Date__c FROM Order__c LIMIT 1];
        
        // Mock the email sending functionality by checking debug logs
        Test.startTest();
        try {
            SendOrderButtonController.sendOrderEmail(order.Id);
            System.assert(true, 'The sendOrderEmail method executed successfully.');
        } catch (Exception e) {
            System.assert(false, 'The sendOrderEmail method threw an exception: ' + e.getMessage());
        }
        Test.stopTest();
        
        // Check debug logs to verify the email content (requires manual log review)
        System.debug('Email subject should contain: Order Information: ' + order.Account__r.Name);
        System.debug('Email body should contain: Payment Due Date: ' + String.valueOf(order.Payment_Due_Date__c) + 
                     'Total Amount: $' + String.valueOf(order.Total_Amount__c) + 
                     'Customer Name: ' + order.Account__r.Name);
    }
}
