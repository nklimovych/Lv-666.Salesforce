import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
const VOTE_LOCATION_NAME_FIELD = 'VoteCampaignLocation__c.Name';
const VOTE_LOCATION_LATITUDE_FIELD = 'VoteCampaignLocation__c.VoteCampaignLocationCoordinates__Latitude__s';
const VOTE_LOCATION_LONGITUDE_FIELD = 'VoteCampaignLocation__c.VoteCampaignLocationCoordinates__Longitude__s';
const voteFields = [
	VOTE_LOCATION_NAME_FIELD,
	VOTE_LOCATION_LATITUDE_FIELD,
	VOTE_LOCATION_LONGITUDE_FIELD
];
export default class VoteLocation extends LightningElement {
  @api recordId;
  name;
  mapMarkers = [];
  @wire(getRecord, { recordId: '$recordId', fields: voteFields })
  loadVoteLoc({ error, data }) {
    if (error) {
    } else if (data) {
      this.name =  getFieldValue(data, VOTE_LOCATION_NAME_FIELD);
      const Latitude = getFieldValue(data, VOTE_LOCATION_LATITUDE_FIELD);
      const Longitude = getFieldValue(data, VOTE_LOCATION_LONGITUDE_FIELD);
      this.mapMarkers = [{
        location: { Latitude, Longitude },
        title: this.name + ' Location',
        description: `Vote Campaign Coordinates: ${Latitude}, ${Longitude}`
      }];
    }
  }
  get cardTitle() {
    return (this.name) ? `"${this.name}" Location` : 'Vote Campaign Location';
  }
}