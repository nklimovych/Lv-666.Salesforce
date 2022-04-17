public with sharing class UserUtils {
    
    @future
    public static void insertUser(Set<Id> groupIds){
        List<GroupMember> usersToBeInserted = new List<GroupMember>();
        for(Id pGroup: groupIds){
                GroupMember configuratorUser = new GroupMember(
                    GroupId = pGroup,
                    UserOrGroupId = UserInfo.getUserId()
                );
                usersToBeInserted.add(configuratorUser);
        }
        
        try{
        insert usersToBeInserted;
        }catch(DmlException e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
    }
}
