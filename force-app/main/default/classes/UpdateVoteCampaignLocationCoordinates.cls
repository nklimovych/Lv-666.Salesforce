/*
* Class contains method that configure apex queueable job to update an appropriate VoteCampaignLocation__c object record
* with the new coordinates (latitude and longitude)
*/
public without sharing class UpdateVoteCampaignLocationCoordinates implements Queueable {
    private Id voteCampaignLocationId;
    private Double latitude;
    private Double longitude;
    /*
    * @description class constructor that collect id of appropriate VoteCampaignLocation__c object record and coordinates, 
    * and assign it to the related variables
    * @param id of appropriate VoteCampaignLocation__c object record
    * @param latitude coordinates
    * @param longitude coordinates
    */
    public UpdateVoteCampaignLocationCoordinates(Id voteCampLocationId, 
                                                Double newLatitude, Double newLongitude) {
        this.voteCampaignLocationId = voteCampLocationId;
        this.latitude = newLatitude;
        this.longitude = newLongitude;
    }
    /*
    * @description method that configure apex queueable job to update an appropriate VoteCampaignLocation__c object record
    * with the new coordinates (latitude and longitude)
    * @param implements QueueableContext interface
    */
    public void execute (QueueableContext context) {
        try {
            VoteCampaignLocation__c voteCampLocRec = [
                                                      SELECT VoteCampaignLocationCoordinates__Latitude__s, VoteCampaignLocationCoordinates__Longitude__s
                                                      FROM VoteCampaignLocation__c 
                                                      WHERE Id = :voteCampaignLocationId
            ];
            voteCampLocRec.VoteCampaignLocationCoordinates__Latitude__s = latitude;
            voteCampLocRec.VoteCampaignLocationCoordinates__Longitude__s = longitude;
            update voteCampLocRec;
        } catch (DmlException e) {
            System.debug('An error has occurred while updating VoteCampaignLocation record coordinates field: ' + e.getMessage());
        }
    }
}
