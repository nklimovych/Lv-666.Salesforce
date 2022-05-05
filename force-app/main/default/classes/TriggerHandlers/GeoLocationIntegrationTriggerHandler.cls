/**
 * @description Class which controll triggers on Voting_Location__c object
 */
public with sharing class GeoLocationIntegrationTriggerHandler extends CustomMDTTriggerHandler {
    /**
     * Key for callout to external service
     */
    final String key = [SELECT opencagedataKey__c FROM API_key_for_opencagedata__mdt Limit 1].opencagedataKey__c;
    
    /**
     * Method which fires when new rocord(s) are inserted
     */
    public override void afterInsert(){
        System.enqueueJob(
            new GeoLocationIntegration(
                key, Trigger.New
            )
        );
    }

    /**
     * @description Method which fires when any field of record is updated
     */
    public override void afterUpdate(){
        List<Voting_Location__c> locationsToUpdate = filterRecords(Trigger.New);
        if(locationsToUpdate.size() > 0){
        System.enqueueJob(
            new GeoLocationIntegration(
                    key, locationsToUpdate
                )
            );
        } 
        else{ return; }
    }

    /**
     * @description Method checks whether the fields of the record have changed after the update
     * @param newRecords - after update records
     * @return locationsToUpdate - records where fields changed after the update
     */
    private List<Voting_Location__c> filterRecords(List<Voting_Location__c> newRecords){
        List<Voting_Location__c> locationsToUpdate = new List<Voting_Location__c>();
        List<Voting_Location__c> updatedList = newRecords;
        for(Voting_Location__c newRecord: updatedList){
            Voting_Location__c oldRecord = (Voting_Location__c) Trigger.oldMap.get(newRecord.Id);
            if(newRecord.Mailing_City__c != oldRecord.Mailing_City__c ||
                newRecord.Mailing_Country__c != oldRecord.Mailing_Country__c ||
                newRecord.Mailing_Street__c != oldRecord.Mailing_Street__c){
                locationsToUpdate.add(newRecord);
            }
        }
        
        return locationsToUpdate;
    }
}


    