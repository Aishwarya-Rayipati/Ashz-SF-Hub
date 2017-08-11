trigger ContactCountUpdate on Contact (after insert, after update, after delete, after undelete) {
    
    Set<ID> AcctIds = new Set<ID>();
    List<Account> AccUpdate = new List<Account>();
    
    if(Trigger.isInsert){
        for(Contact Con_I : Trigger.new){
            AcctIds.add(Con_I.AccountId);
        }
    }   
    if(Trigger.isupdate){ 
        for(Contact Con_U : Trigger.old){
            AcctIds.add(con_U.AccountId);
        }
    }
    if(Trigger.isDelete){
        for(Contact Con_D : Trigger.old){
            AcctIds.add(Con_D.AccountId);
        }
    }
    
    for(Account Acc : [SELECT ContactCount__c,(SELECT id FROM Contacts) FROM Account WHERE id =: AcctIds]){
        Account Acnt = new Account();
        Acnt.id = Acc.id;
        Acnt.ContactCount__c = Acc.Contacts.size();
        AccUpdate.add(Acnt);
    }
    try{
        update AccUpdate;
    }
    Catch(Exception e){
        System.debug('Exception :'+e.getMessage());
    }
}