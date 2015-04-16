/**
* \arg ClassName            : TBN_QuestionandAnswersController
* \arg JIRATicket           : Assignment no 1
* \arg CreatedOn            : 13/04/2015
* \arg LastModifiedOn       : 16/04/2015
* \arg CreatededBy          : Pooja
* \arg ModifiedBy           : Pooja
* \arg Description          : Controller for QuestionsandAnswers page.
*/
public with sharing class TBN_QuestionandAnswersController 
{
	/*Start variables */
	
	List<Product2> lstProducts = new List<Product2>();
	List<Product_Group__c> lstProductgroups = new List<Product_Group__c>();
	List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();//list of OpportunityLineItems
	Set<Id> setofProductId = new Set<Id>();//Set of Product ids
	
	public List<QuestionAnswerWrapper> display_list 	{	get; set;	}//List of wrapper class
	public List<Answer__c> lstAnswer 					{	get; set;	}//List of Answer
	public List<Questions__c > lstQuestion  			{	get; set;	}//List of Question
	public Integer intAnswered							{	get; set;	}//Count of answered questions
	public Integer intUnanswered						{	get; set;	}//Count of unanswered questions
	
	/*End variables*/

	/*Start Constructor */
	public TBN_QuestionandAnswersController()
	{
		lstAnswer = new List<Answer__c>();
		lstQuestion = new List<Questions__c>();
		display_list = getRecordsToDisplay();
		intAnswered = [Select count() from Answer__c ];
		intUnanswered = [Select count() from Questions__c ] - [Select count() from Answer__c];
	}
	/*End Constructor*/
	
	//Start of wrapper class
	public class QuestionAnswerWrapper 
	{
        public Questions__c objQuestion	{	get; set;	} 
     	public Answer__c objAnswer	 	{	get; set;	} 
     	
     	//Constructor of wrapper class
        public QuestionAnswerWrapper(Questions__c q, Answer__c a) 
        {
            this.objQuestion = q; 
            this.objAnswer = a;
        }
    }
	
	public List<QuestionAnswerWrapper> getRecordsToDisplay() 
 	{
 		display_list = new List<QuestionAnswerWrapper>(); 
	    
	    for (Questions__c q : [Select 	Answer_Type__c,
										Question__c ,
										Product_Group__c,
										Id,
										Product__r.Name, 
										Product__c 
								From 	Questions__c]) 
		{ 
			//query for the details of the records we want to display
			display_list.add(new QuestionAnswerWrapper(q, null)); 
	    }
	    
	    for(Answer__c a : [Select 	Yes__c, 
									Solution__c, 
									Product__r.Name, 
									Opportunity__c, 
									No__c, 
									Id
					 		From 	Answer__c ])
	 	{
	 		display_list.add(new QuestionAnswerWrapper(null, a));
	 	}
	 	
 	  	return display_list; //return the list of full records 
	}
	
	/*Method to insert and update answer records*/
	public void saveanswers()
	{
		List<Answer__c> lstAnswerToUpsert = new List<Answer__c>();
		
		for(QuestionAnswerWrapper objWrap : display_list)
       	{
       		lstAnswerToUpsert.add(objWrap.objAnswer);
     	} 
       	
       	try
       	{
       		upsert lstAnswerToUpsert;
       	}
       	
       	Catch(Exception e)
       	{
       		System.debug('=======Exp======'+e);
       	}
 		
 		display_list.clear();
 		display_list = getRecordsToDisplay();
 	}
	
	/*Method to fetch Question and Answers details*/
	public pagereference fetchAnswers()
	{
		lstOLI = [Select PricebookEntry.Product2Id, PricebookEntryId, OpportunityId, Id From OpportunityLineItem];
		
		for(OpportunityLineItem objOLI : lstOLI)
		{
			setofProductId.add(objOLI.PricebookEntry.Product2Id);
		}
		
		lstProducts = [Select 	Name,
								Id 
						From 	Product2 
						Where 	Id In : setofProductId ];
					
		lstQuestion = [Select 	Answer_Type__c,
								Question__c ,
								Product_Group__c,
								Id,
								Product__r.Name, 
								Product__c 
						From 	Questions__c];
		
		
		lstAnswer = [Select 	Yes__c, 
								Solution__c, 
								Product__r.Name, 
								Opportunity__c, 
								No__c, 
								Id
					 From 		Answer__c ];
		return null;
	}
	/*End of method fetchAnswers*/
}