public without sharing class VoteCampaignLocationsManager {
    public VoteCampaignLocationsManager() {
    }

    public static void updateCoordinates(List<VoteCampaignLocation__c> newLocations) {
        GetCoordinatesFromAddresses getcoordinatesjob = new GetCoordinatesFromAddresses(newLocations);
        ID getcoordinatesjobid = System.enqueueJob(getcoordinatesjob);
        //AsyncApexJob getcoordinatesjob_log = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :getcoordinatesjobid];
        //System.debug('Get coordinates job log: ' + getcoordinatesjob_log);
    }
}
