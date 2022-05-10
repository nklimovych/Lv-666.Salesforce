public without sharing class UpdateVoteCampaignLocationCoordinates implements Queueable {
    private Id voteCampaignLocationId;
    private Double latitude;
    private Double longitude;
    public UpdateVoteCampaignLocationCoordinates(Id voteCampLocationId, 
                                                Double newLatitude, Double newLongitude) {
        this.voteCampaignLocationId = voteCampLocationId;
        this.latitude = newLatitude;
        this.longitude = newLongitude;
    }

    public void execute (QueueableContext context) {
        try {
            VoteCampaignLocation__c voteCampLocRec = [SELECT VoteCampaignLocationCoordinates__Latitude__s, VoteCampaignLocationCoordinates__Longitude__s
            FROM VoteCampaignLocation__c WHERE Id = :voteCampaignLocationId];
            voteCampLocRec.VoteCampaignLocationCoordinates__Latitude__s = latitude;
            voteCampLocRec.VoteCampaignLocationCoordinates__Longitude__s = longitude;
            update voteCampLocRec;
        } catch (DmlException e) {
            System.debug('An error has occurred while updating VoteCampaignLocation record coordinates field: ' + e.getMessage());
        }
    }
}
