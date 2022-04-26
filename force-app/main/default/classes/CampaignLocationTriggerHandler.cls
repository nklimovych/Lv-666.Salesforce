public with sharing class CampaignLocationTriggerHandler extends CustomMDTTriggerHandler {
    
    public override void afterInsert(){
        //System.enqueueJob(new GeoLocationsUtil(Trigger.New));
    }

    public override void afterUpdate(){
        System.debug('afterUpdate is executing');
        
        System.enqueueJob(new CalloutToExternalServise(Trigger.New));
    }

}
