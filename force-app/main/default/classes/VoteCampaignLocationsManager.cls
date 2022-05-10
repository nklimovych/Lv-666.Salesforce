/*
* Class contains method that invoke apex queueble job to update an appropriate VoteCampaignLocation__c object record
* with the new coordinates (latitude and longitude)
*/
public without sharing class VoteCampaignLocationsManager {
    /*
    * @description method that invoke apex queueble job to update an appropriate VoteCampaignLocation__c object record
    * with the new coordinates (latitude and longitude)
    * @param contains list of VoteCampaignLocation__c object records whose coordinates need to be updated
    * Commented rows contains code for apex queueble job debugging
    */
    public static void updateCoordinates(List<VoteCampaignLocation__c> newLocations) {
        GetCoordinatesFromAddresses getCoordinatesJob = new GetCoordinatesFromAddresses(newLocations);
        ID getCoordinatesJobId = System.enqueueJob(getCoordinatesJob);
        //AsyncApexJob getCoordinatesJob_Log = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :getCoordinatesJobId];
        //System.debug('Get coordinates job log: ' + getCoordinatesJob_Log);
    }
}
