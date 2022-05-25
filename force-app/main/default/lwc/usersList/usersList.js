import { LightningElement, track, api, wire } from 'lwc';
import getUsers from '@salesforce/apex/LwcControllers.getUsers';

const COLUMNS = [
    {
        label: 'Name', fieldName: "UserURL", type: 'url',
        typeAttributes: {
            label: {
                fieldName: "Name"
            },
            target: '_blank'
        }
    },
    {
        label: 'Username',
        fieldName: 'Username',
        type: 'text'
    }
];

export default class UsersList extends LightningElement {
    @api componentLabel;
    //id of current record
    @api recordId;
    columns = COLUMNS;
    //list of users of current type
    @track users;
    //name of list shown to user
    listName;
    //recordType name
    recordTp;
    connectedCallback() {
        getUsers({ cmpId: this.recordId, lim: 5, userType: this.componentLabel }).then(response => {
            //different table lable for different componentLabel arguement
            this.listName = 'Assigned ' + this.componentLabel;
            this.recordTp = this.componentLabel;
            //adding links to profiles
            this.users = response;
            this.users.forEach(item => {
                item.UserURL = '/' + item.Id;
            },
            );
        }).catch(error => {
            console.log('Error: ' + error);
        });
    }
}