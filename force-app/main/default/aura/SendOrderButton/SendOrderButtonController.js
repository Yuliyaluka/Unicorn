({
    sendEmail : function(component, event, helper) {
        var orderId = component.get("v.recordId");
        var action = component.get("c.sendOrderEmail");
        console.log(orderId);
        action.setParams({ orderId : orderId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Email sent successfully");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    }
})