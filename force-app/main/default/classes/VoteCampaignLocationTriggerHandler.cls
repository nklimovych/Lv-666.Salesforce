public without sharing class VoteCampaignLocationTriggerHandler extends CustomMDTTriggerHandler {
    public List<VoteCampaignLocation__c> newLocations;
    public VoteCampaignLocationTriggerHandler(List<VoteCampaignLocation__c> newLocs) {
        this.newLocations = newLocs;
    }

    public VoteCampaignLocationTriggerHandler() {
        this((List<VoteCampaignLocation__c>)Trigger.new);
    }

    public override void afterInsert() {
        VoteCampaignLocationsManager.updateCoordinates(newLocations);
    }

    public override void afterUpdate() {
        VoteCampaignLocationsManager.updateCoordinates(newLocations);
    }
}
