public without sharing class VoteCampaignLocationTriggerHandler extends CustomMDTTriggerHandler {
    public List<VoteCampaignLocation__c> newLocations;
    public Map<Id,VoteCampaignLocation__c> newLocationsMap;
    public Map<Id,VoteCampaignLocation__c> oldLocationsMap;
    public VoteCampaignLocationTriggerHandler(List<VoteCampaignLocation__c> newLocs, 
                                              Map<Id,VoteCampaignLocation__c> newLocMap, 
                                              Map<Id,VoteCampaignLocation__c> oldLocMap) {
        this.newLocations = newLocs;
        this.newLocationsMap = newLocMap;
        this.oldLocationsMap = oldLocMap;
    }

    public VoteCampaignLocationTriggerHandler() {
        this((List<VoteCampaignLocation__c>)Trigger.new, 
            (Map<Id,VoteCampaignLocation__c>)Trigger.newMap, 
            (Map<Id,VoteCampaignLocation__c>)Trigger.oldMap);
    }

    public override void afterInsert() {
        Boolean fieldsFilled = False;
        for(VoteCampaignLocation__c loc : newLocations) {
            if(loc.Street__c != Null && loc.City__c != Null && loc.Country__c != Null) {
                fieldsFilled = True;
            }
        }
        if(fieldsFilled == True) {
            VoteCampaignLocationsManager.updateCoordinates(newLocations);
        }   

    }

    public override void afterUpdate() {
        Boolean addressHasChanged = False;
        for(Id locationId : newLocationsMap.keySet()) {
            if(newLocationsMap.get(locationId).City__c != Null 
            && newLocationsMap.get(locationId).Country__c != Null) {
                if(oldLocationsMap.get(locationId).Street__c != newLocationsMap.get(locationId).Street__c || 
                oldLocationsMap.get(locationId).City__c != newLocationsMap.get(locationId).City__c || 
                oldLocationsMap.get(locationId).Country__c != newLocationsMap.get(locationId).Country__c) {
                    addressHasChanged = True;
                }
            }
        }
        if (addressHasChanged == True) {
            VoteCampaignLocationsManager.updateCoordinates(newLocations);
        }
        
    }
}
