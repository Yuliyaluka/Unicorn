import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/OrderController.getAccounts';
import getMonths from '@salesforce/apex/OrderController.getMonths';
import getOrders from '@salesforce/apex/OrderController.getOrders';
import { NavigationMixin } from 'lightning/navigation';

export default class OrderFilter extends NavigationMixin(LightningElement) {
    @track selectedAccount = '';
    @track selectedMonth = '';
    @track accountOptions = [];
    @track monthOptions = [];
    @track orders = [];
    @track columns = [
        { 
            label: 'Order Name', 
            fieldName: 'Name', 
            type: 'button', 
            typeAttributes: { 
                label: { fieldName: 'Name' }, 
                name: 'view_details', 
                variant: 'base' 
            }
        },
        { 
            label: 'Total Amount', 
            fieldName: 'Total_Amount__c', 
            type: 'currency', 
            sortable: true 
        },
        { 
            label: 'Payment Due Date', 
            fieldName: 'Payment_Due_Date__c', 
            type: 'date', 
            sortable: true 
        }
    ];

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accountOptions = data.map(account => {
                return { label: account.Name, value: account.Id };
            });
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getMonths, { accountId: '$selectedAccount' })
    wiredMonths({ error, data }) {
        if (data) {
            this.monthOptions = data.map(month => {
                return { label: month, value: month };
            });
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getOrders, { accountId: '$selectedAccount', month: '$selectedMonth' })
    wiredOrders({ error, data }) {
        if (data) {
            this.orders = data;
        } else if (error) {
            console.error(error);
        }
    }

    handleAccountChange(event) {
        this.selectedAccount = event.detail.value;
        this.selectedMonth = ''; // Reset the selected month when account changes
    }

    handleMonthChange(event) {
        this.selectedMonth = event.detail.value;
    }

    handleRowAction(event) {
        const row = event.detail.row;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                objectApiName: 'Order__c',
                actionName: 'view'
            }
        });
    }
}