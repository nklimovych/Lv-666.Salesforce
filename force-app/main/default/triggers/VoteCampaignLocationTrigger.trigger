trigger VoteCampaignLocationTrigger on VoteCampaignLocation__c (after insert, after update) {
    if (Trigger.isUpdate) {
        Boolean addressHasChanged = False;
        for(Id locationId : Trigger.newMap.keySet()) {
            if(Trigger.newMap.get(locationId).City__c != Null 
            && Trigger.newMap.get(locationId).Country__c != Null) {
                if(Trigger.oldMap.get(locationId).Street__c != Trigger.newMap.get(locationId).Street__c || 
                Trigger.oldMap.get(locationId).City__c != Trigger.newMap.get(locationId).City__c || 
                Trigger.oldMap.get(locationId).Country__c != Trigger.newMap.get(locationId).Country__c) {
                    addressHasChanged = True;
                }
            }
        }
        if (addressHasChanged == True) {
            new CustomMDTTriggerHandler().run();
        }
    }
    if (Trigger.isInsert) {
        Boolean fieldsFilled = False;
        for(VoteCampaignLocation__c loc : Trigger.new) {
            if(loc.Street__c != Null && loc.City__c != Null && loc.Country__c != Null) {
                fieldsFilled = True;
            }
        }
        if(fieldsFilled == True) {
            new CustomMDTTriggerHandler().run();
        }   
    }
}