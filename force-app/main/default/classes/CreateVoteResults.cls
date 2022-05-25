public without sharing class CreateVoteResults implements Queueable{
    private List<Vote__c> voteResultsList;

    public CreateVoteResults(List<Vote__c> results) {
        this.voteResultsList = results;
    }

    public void execute(QueueableContext context) {
        insert voteResultsList;
    }   
}
