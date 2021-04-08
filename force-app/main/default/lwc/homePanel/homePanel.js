import { LightningElement, api, wire, track } from "lwc";

import getAccounts from '@salesforce/apex/CBController.getAccounts';

export default class HomePanel extends LightningElement {

  @track accounts = [];
  @track accountName = '';
  showSpinner = true;

  @wire(getAccounts, { name: '$accountName' }) getWiredAccounts({ error, data }) {
    try {
      if (data) {
        this.accounts = data;
      }
      this.showSpinner = false;
    } catch (e) {
      alert(e);
    }
  };

  findAccount(event) {
    let accN = event.target.value;
    this.accountName = accN;
    this.showSpinner = true;
    console.log(this.accountName);  
  }

  @track request = { name: "New Request", amount: 55 };
  displayBottom = false;

  handleChange(event) {
    this.request.amount = event.target.value;
    this.displayBottom = this.request.amount > 1000;
    console.log("Changed Amount is : " + this.request.amount);
  }

  firstName = "";
  lastName = "";
  thirdName = "";

  handleChange2(event) {
    const field = event.target.name;
    if (field === "firstName") {
      this.firstName = event.target.value;
    } else if (field === "lastName") {
      this.lastName = event.target.value;
    }
  }

  get uppercasedFullName() {
    return `${this.firstName} ${this.lastName}`.toUpperCase();
  }

  get contacts() {
    let arr = [];
    try {
      for (let index = 0; index < 500; index++) {
        arr.push({
          name: "Test",
          id: index,
          value: 254 + index * 1.1,
          description: "Some description",
          fund: 'Fund ' + index * 2,
          grant: '23G',
          FY: 2021,
          func: 'A' + index + 'BX' + (25 + index),
          a1: index,
          a2: index + 1,
          a3: index + 2,
          a4: index + 3,
          a5: index + 4,
          a6: index + 5,
          a7: index + 6,
          a8: index + 7,
          a9: index + 8,
          a10: index + 9,
          a11: index + 10,
          a12: index + 11,
        });
      }
    } catch (e) {
      alert(e);
    }
    console.log("ARR : " + JSON.stringify(arr));
    return arr;
  }

  doSomeUseful(event) {
    alert('ALERT');
  }
}
