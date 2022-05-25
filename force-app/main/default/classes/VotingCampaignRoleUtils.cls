/**
 * Class for 
 */
public with sharing class VotingCampaignRoleUtils implements Queueable{
    // List of deleted UserCampaignRole records
    List<User_Campain_Role__c> deletedUserCampains = new List<User_Campain_Role__c>();
    
    
    public VotingCampaignRoleUtils(List<User_Campain_Role__c> deletedUserCampains) {
        this.deletedUserCampains = deletedUserCampains;
    }

    /**
     * Method for asynchronous removal of relevant users from the public groups to which they belong 
     */
    public void execute(QueueableContext context) {
        if(this.deletedUserCampains.isEmpty()){
   
            return;
        }
       
        Id campaignForGettingAssignedGroupsId = this.deletedUserCampains.get(0).Voting_Campaign__c;
        System.debug(campaignForGettingAssignedGroupsId);
        Voting_Campaign__c campaignForGettingAssignedGroups = [SELECT NumberOfCampaign__c FROM Voting_Campaign__c WHERE ID =:campaignForGettingAssignedGroupsId LIMIT 1];
      
        /**
         * Getting IDs of 4 assigned public groups
         */
        List<Group> assignedGroupsToCampaign = [SELECT Name
                                                FROM GROUP
                                                WHERE 
                                                Name Like:'CMP-' + campaignForGettingAssignedGroups.NumberOfCampaign__c+'%'
                                                ];
       
        Map<String, Object> assignedGroupsToCampaignMap = new Map<String,Object>();
        
        for(Group currGroup:assignedGroupsToCampaign) {
            assignedGroupsToCampaignMap.put(
                currGroup.Name,
                currGroup.Id
            );
        }
        
        /**
         * Getting IDs of record types to know user role on campaign
         */
        List<RecordType> recordTypeIds = [SELECT ID, Name 
                                  FROM RecordType 
                                  WHERE (
                                  Name =:'Moderator'
                                  or Name=:'Analyst'
                                  or Name =:'Voter'
                                  or Name =:'Cofigurator'            
                                  )];
        
        Map<String, Object> recordTypesMap = new Map<String, Object>();
        
        for(RecordType currRecordType: recordTypeIds) {
            recordTypesMap.put(
                currRecordType.Name, 
                currRecordType.Id
            );
            
        }
        
        Set<Id> setGroupId = new Set<Id>();
        Set<Id> setUserOrGroupId = new Set<Id>();
        
        /**
         * Comparing available roles with actual user role
         */
        for(User_Campain_Role__c currUserRole: this.deletedUserCampains) {
            if(currUserRole.RecordTypeId == recordTypesMap.get('Moderator')) {
                setGroupId.add((Id)assignedGroupsToCampaignMap.get('CMP-' + campaignForGettingAssignedGroups.NumberOfCampaign__c +'-Moderators'));
                setUserOrGroupId.add(currUserRole.User__c);
            }
            else if(currUserRole.RecordTypeId == recordTypesMap.get('Analyst')) {
                setGroupId.add((Id)assignedGroupsToCampaignMap.get('CMP-' + campaignForGettingAssignedGroups.NumberOfCampaign__c +'-Analysts'));
                setUserOrGroupId.add(currUserRole.User__c);
            }
            else if(currUserRole.RecordTypeId == recordTypesMap.get('Voter')) {
                System.debug((Id)assignedGroupsToCampaignMap.get('CMP-' + campaignForGettingAssignedGroups.NumberOfCampaign__c +'-Voters'));
                setGroupId.add((Id)assignedGroupsToCampaignMap.get('CMP-' + campaignForGettingAssignedGroups.NumberOfCampaign__c +'-Voters'));
                setUserOrGroupId.add(currUserRole.User__c);
            }
            else if(currUserRole.RecordTypeId == recordTypesMap.get('Configurator')) { 
                setGroupId.add((Id)assignedGroupsToCampaignMap.get('CMP-' + campaignForGettingAssignedGroups.NumberOfCampaign__c +'-Configurators'));
                setUserOrGroupId.add(currUserRole.User__c);
            }
        }
        
        if( setGroupId.size() > 0 && setUserOrGroupId.size() > 0 ){
            List<GroupMember> GM_list  = [ Select Id from GroupMember where UserOrGroupID in :setUserOrGroupId and GroupId  in :setGroupId ];
            if(GM_list.size() > 0 )
            {
                delete GM_list;
            }
		
        }
    }

    /**
     * Future method which insert users in an appropriate public group
     * @param createdUserCampaignIds - this is ids of created UserCampaignRole__c records
     */
    @future
    public static void insertUsersToPublicGroup(Set<Id> createdUserCampaignIds){
        System.debug(createdUserCampaignIds);
        List<User_Campain_Role__c> createdUserCampaigns = [SELECT User__c, 	Voting_Campaign__c, RecordTypeId FROM User_Campain_Role__c WHERE ID IN:createdUserCampaignIds];
        System.debug(createdUserCampaigns);
        Id votingCampaign = createdUserCampaigns.get(0).Voting_Campaign__c;
        System.debug(votingCampaign);
        Voting_Campaign__c votingCampaignObj = [SELECT Id, NumberOfCampaign__c FROM Voting_Campaign__c WHERE Id =: votingCampaign LIMIT 1];
        
        List<Group> assignedGroupsToCampaign = [SELECT Name
                                                FROM GROUP
                                                WHERE 
                                                Name Like:'CMP-' + votingCampaignObj.NumberOfCampaign__c+'%'
                                                ];
        System.debug(assignedGroupsToCampaign);
        Map<String, Object> assignedGroupsToCampaignMap = new Map<String,Object>();
        
        for(Group currGroup:assignedGroupsToCampaign) {
            assignedGroupsToCampaignMap.put(
                currGroup.Name,
                currGroup.Id
            );
        }
        
        
        /**
         * Getting IDs of record types to know user role on campaign
         */
        List<RecordType> recordTypeIds = [SELECT ID, Name 
                                  FROM RecordType 
                                  WHERE (
                                  Name =:'Moderator'
                                  or Name=:'Analyst'
                                  or Name =:'Voter'
                                  or Name =:'Cofigurator'            
                                  )];
        
        Map<String, Object> recordTypesMap = new Map<String, Object>();
        
        for(RecordType currRecordType: recordTypeIds) {
            recordTypesMap.put(
                currRecordType.Name, 
                currRecordType.Id
            );
            
        }
        
        List<GroupMember> groupMembersToInsert = new List<GroupMember>();

        for(User_Campain_Role__c currUserRole: createdUserCampaigns) {
            if(currUserRole.RecordTypeId == recordTypesMap.get('Moderator')) {
                groupMembersToInsert.add(
                    new GroupMember(
                        GroupId = (Id)assignedGroupsToCampaignMap.get('CMP-' + votingCampaignObj.NumberOfCampaign__c +'-Moderators'),
                        UserOrGroupId = currUserRole.User__c
                    )
                );
            }
            else if(currUserRole.RecordTypeId == recordTypesMap.get('Configurator')) {
                groupMembersToInsert.add(
                    new GroupMember(
                        GroupId = (Id)assignedGroupsToCampaignMap.get('CMP-' + votingCampaignObj.NumberOfCampaign__c +'-Configurators'),
                        UserOrGroupId = currUserRole.User__c
                    )
                );
            }
            else if(currUserRole.RecordTypeId == recordTypesMap.get('Voter')) {
                groupMembersToInsert.add(
                    
                    new GroupMember(
                        GroupId = (Id)assignedGroupsToCampaignMap.get('CMP-' + votingCampaignObj.NumberOfCampaign__c +'-Voters'),
                        UserOrGroupId = currUserRole.User__c
                    )
                );
            }
            else if(currUserRole.RecordTypeId == recordTypesMap.get('Analyst')) { 
                groupMembersToInsert.add(
                    new GroupMember(
                        GroupId = (Id)assignedGroupsToCampaignMap.get('CMP-' + votingCampaignObj.NumberOfCampaign__c +'-Analysts'),
                        UserOrGroupId = currUserRole.User__c
                    )
                );
            }
        }
        insert groupMembersToInsert;
    }
    
}
