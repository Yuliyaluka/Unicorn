// SendOrderButtonController.cls
public with sharing class SendOrderButtonController {
    
    @AuraEnabled
    public static void sendOrderEmail(String orderId) {
        System.debug('sendOrderEmail called with orderId: ' + orderId);
        try {
            Order__c order = [SELECT Id, Total_Amount__c, Payment_Due_Date__c, Account__r.Name 
                              FROM Order__c WHERE Id = :orderId LIMIT 1];
            System.debug('Order retrieved: ' + order);
            
            if (order != null) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { UserInfo.getUserEmail() });
                email.setSubject('Order Information: ' + order.Account__r.Name);
                String emailBody = 'Payment Due Date: ' + String.valueOf(order.Payment_Due_Date__c) + '<br/>' +
                                   'Total Amount: $' + String.valueOf(order.Total_Amount__c) + '<br/><br/>' +
                                   'Customer Name: ' + order.Account__r.Name;
                email.setHtmlBody(emailBody);
                Messaging.SendEmailResult[] rslt = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                System.debug(rslt);
                System.debug('Email sent successfully');
            } else {
                throw new AuraHandledException('Order not found with ID: ' + orderId);
            }
        } catch (Exception e) {
            System.debug('Error sending email: ' + e.getMessage());
            throw new AuraHandledException('Error sending email: ' + e.getMessage());
        }
    }
}