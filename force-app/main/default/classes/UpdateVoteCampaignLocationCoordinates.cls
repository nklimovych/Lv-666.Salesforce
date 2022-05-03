public without sharing class UpdateVoteCampaignLocationCoordinates implements Queueable {
    private Id voteCampaignLocationId;
    private Double latitude;
    private Double longitude;
    public UpdateVoteCampaignLocationCoordinates(Id voteCampaignLocationId, 
                                                Double latitude, Double longitude) {
        this.voteCampaignLocationId = voteCampaignLocationId;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public void execute (QueueableContext context) {
        try {
            VoteCampaignLocation__c votecamplocrec = [SELECT VoteCampaignLocationCoordinates__Latitude__s, VoteCampaignLocationCoordinates__Longitude__s
            FROM VoteCampaignLocation__c WHERE Id = :voteCampaignLocationId];
            votecamplocrec.VoteCampaignLocationCoordinates__Latitude__s = latitude;
            votecamplocrec.VoteCampaignLocationCoordinates__Longitude__s = longitude;
            update votecamplocrec;
        } catch (DmlException e) {
            System.debug('An error has occurred while updating VoteCampaignLocation record coordinates field: ' + e.getMessage());
        }
    }
}
