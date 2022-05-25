public with sharing class VoteResultsController {
    @AuraEnabled(cacheable=true)
    public static List<Vote__c> saveVoteResults(Map<String, Object> answerData) {
        List<Vote__c> voteResultsList = new List<Vote__c>();
        
        List<String> answersList = new List<String>();
        
        for(String answer : answerData.keyset()) {
            Map<Object, Object> mapedAnswer = (Map<Object, Object>)answerData.get(answer);
            
            id answerId = (Id)mapedAnswer.get('answerId');
            id campaignId = (Id)mapedAnswer.get('campaignId');
            id votingId = (Id)mapedAnswer.get('votingId');
            
            Vote__c voteResult = new Vote__c (
                Voting_Answer__c = answerId,
                Voting_Campaign__c = campaignId,
                Voting_Question__c = votingId
            );

            voteResultsList.add(
                voteResult
            );
        }
        System.enqueueJob(new CreateVoteResults(voteResultsList));
        return voteResultsList;
    } 
}
