/**
* \arg ClassName            : TBN_QuestionandAnswersController
* \arg JIRATicket           : Assignment no 1
* \arg CreatedOn            : 13/04/2015
* \arg LastModifiedOn       : 17/04/2015
* \arg CreatededBy          : Pooja
* \arg ModifiedBy           : Pooja
* \arg Description          : Controller for QuestionsandAnswers page.
*/
public with sharing class TBN_QuestionandAnswersController 
{
	/*Start variables */
	List<Product2> lstProducts = new List<Product2>();//list of Products
	List<Product_Group__c> lstProductgroups = new List<Product_Group__c>();//list of Product groups
	List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();//list of OpportunityLineItems
	Set<Id> setofProductId = new Set<Id>();//Set of Product ids
	Set<Id> setofProductIdinProductgroup = new Set<Id>();//Set of Product ids
	List<Answer__c> selectedAnswers = new List<Answer__c>();//list of answers
	List<Questions__c > selectedQuestion = new List<Questions__c>();//list of question
	
	public List<QuestionAnswerWrapper> display_list 	{	get; set;	}//List of wrapper class
	public Integer intAnswered							{	get; set;	}//Count of answered questions
	public Integer intUnanswered						{	get; set;	}//Count of unanswered questions
	public Questions__c que								{ 	get;set; 	}//question object
  	public Answer__c ans								{ 	get;set; 	}//answer object
 	/*End variables*/

	/* Start Constructor */
	public TBN_QuestionandAnswersController()
	{
	 	Questions__c que	 = new Questions__c();
 	 	Answer__c ans = new Answer__c();
		intAnswered = [Select count() from Answer__c ];
		intUnanswered = [Select count() from Questions__c ] - [Select count() from Answer__c];
	}
	/* End Constructor*/
	
	/* Start of Wrapper Class */
	public class QuestionAnswerWrapper
	{
   		public Questions__c objQuestion 			{	get; set;	}
        public Answer__c objAnswer 					{	get; set;	}
		public Boolean selected 					{	get; set;	}
       
		public QuestionAnswerWrapper(Questions__c que)
		{
			this.objQuestion = que;   
			this.selected = false;
		}
		public QuestionAnswerWrapper(Answer__c ans)
		{
			this.objAnswer = ans;
			this.selected = false;
		}
    }
    /* End of Wrapper Class */
   
    /* Start of method to fetch question details */
    public list<QuestionAnswerWrapper> getQuestion()
	{
		
		lstOLI = [Select PricebookEntry.Product2Id, PricebookEntryId, OpportunityId, Id From OpportunityLineItem];
		
		for(OpportunityLineItem objOLI : lstOLI)
		{
			setofProductId.add(objOLI.PricebookEntry.Product2Id);
		} 
		
		lstProducts = [Select Product_Group__c, Id From Product2 where Product_Group__c!=null];
		 
		for(Product2 objProductPG : lstProducts)
		{
			setofProductIdinProductgroup.add(objProductPG.Id);
		}
		 
		list<Questions__c> listofquestions = [select 	Answer_Type__c,
														Answer__c,
														Question__c ,
														Product_Group__c,
														Id,
														Product__r.Name, 
														Product__c  
												from 	Questions__c 
												Where 	(Product__c In :setofProductId Or Product__c In :setofProductIdinProductgroup)];
			
        display_list= new list<QuestionAnswerWrapper>();
            
        for(Questions__c acn: listofquestions)
        {
        	setofProductId.add(acn.Product__c);
			display_list.add(new QuestionAnswerWrapper(acn));
		}
    	return display_list;
	}
	
 	/* Start of method to fetch answer details */
    public list<QuestionAnswerWrapper> getAnswers()
	{
         list<Answer__c> listofanswers	=	[select Yes__c, 
													Solution__c, 
													Product__r.Name, 
													Opportunity__c, 
													No__c, 
													Id 
											 from 	Answer__c 
											 Where  Product__c In : setofProductId];
		 
         display_list= new list<QuestionAnswerWrapper>();
		 
         for(Answer__c ans : listofanswers )
         {
			display_list.add(new QuestionAnswerWrapper(ans));
         }
         return display_list;
	}
   
    /* Start of method to get selected record details */
 	public PageReference getSelected() 
	{
		selectedAnswers.clear();
		
     	for(QuestionAnswerWrapper objwrapper: display_list) 
     	{
     		if(objwrapper.selected == true)
     		{
 				selectedAnswers.add(objwrapper.objAnswer); 
     		}
     	}
		return null;
	}
    
    /* Start of method to process selected record details */
 	public List<Answer__c> GetselectedAnswers()
 	{
    	if(selectedAnswers.size() > 0)
        	return selectedAnswers;
        else
       		return null;
	} 
	
	/*Method to insert and update answer records*/
	public pagereference saveanswers()
	{
		try{
       		upsert selectedAnswers;
       	}
       	catch(Exception e){
       		System.debug('=======Exp======'+e);
       	}
       	
       	display_list = getAnswers();
       	return null;
	}
}