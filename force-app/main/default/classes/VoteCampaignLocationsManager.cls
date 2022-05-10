public without sharing class VoteCampaignLocationsManager {
    public VoteCampaignLocationsManager() {
    }

    public static void updateCoordinates(List<VoteCampaignLocation__c> newLocations) {
        GetCoordinatesFromAddresses getCoordinatesJob = new GetCoordinatesFromAddresses(newLocations);
        ID getCoordinatesJobId = System.enqueueJob(getCoordinatesJob);
        //AsyncApexJob getCoordinatesJob_Log = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :getCoordinatesJobId];
        //System.debug('Get coordinates job log: ' + getCoordinatesJob_Log);
    }
}
