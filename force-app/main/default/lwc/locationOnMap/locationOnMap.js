import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
// Set Bear object fields
import NAME_FIELD from '@salesforce/schema/Voting_Location__c.Name';
import LOCATION_LATITUDE_FIELD from '@salesforce/schema/Voting_Location__c.Location_lat__c';
import LOCATION_LONGITUDE_FIELD from '@salesforce/schema/Voting_Location__c.Location_lng__c';
const Location = [
	NAME_FIELD,
	LOCATION_LATITUDE_FIELD,
	LOCATION_LONGITUDE_FIELD
];
export default class geoLocation extends LightningElement {
  @api recordId;
  name;
  mapMarkers = [];
  @wire(getRecord, { recordId: '$recordId', fields: Location })
  loadBear({ error, data }) {
    if (error) {
      // TODO: handle error
    } else if (data) {
      // Get Location data
      this.name =  getFieldValue(data, NAME_FIELD);
      const Latitude = getFieldValue(data, LOCATION_LATITUDE_FIELD);
      const Longitude = getFieldValue(data, LOCATION_LONGITUDE_FIELD);
      // Transform bear data into map markers
      this.mapMarkers = [{
        location: { Latitude: Latitude, Longitude: Longitude },
        title: this.name,
        description: `Coords: ${Latitude}, ${Longitude}`
      }];
    }
  }
  get cardTitle() {
    return (this.name) ? `${this.name}'s location` : 'Bear location';
  }
}