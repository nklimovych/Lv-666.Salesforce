public with sharing class GeoLocationIntegrationTriggerHandler extends CustomMDTTriggerHandler {
    
    public static Boolean isActive = true;


    public override void afterInsert(){
        if(isActive){
        System.enqueueJob(new GeoLocationIntegration(Trigger.New));
        } else{ return; }
    }

    public override void afterUpdate(){
        if(isActive){
        System.enqueueJob(new GeoLocationIntegration(Trigger.New));
        } else{ return; }

    }
}
