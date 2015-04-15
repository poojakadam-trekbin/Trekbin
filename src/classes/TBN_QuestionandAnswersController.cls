/**
* \arg ClassName            : TBN_QuestionandAnswersController
* \arg JIRATicket           : Assignment no 1
* \arg CreatedOn            : 13/04/2015
* \arg LastModifiedOn       : 15/04/2015
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
	
	public List<Answer__c> lstAnswer 			{	get; set;	}//List of Answer
	public List<Questions__c > lstQuestion  	{	get; set;	}//List of Question
	public Integer intAnswered					{	get; set;	}//Count of answered questions
	public Integer intUnanswered				{	get; set;	}//Count of unanswered questions
	
	public String strAnswerType					{ get; set;	}
	
	/*End variables*/

	/*Start Constructor */
	public TBN_QuestionandAnswersController()
	{
		lstAnswer = new List<Answer__c>();
		lstQuestion = new List<Questions__c>();
		fetchAnswers();
	}
	/*End Constructor*/
	
	/*Method to fetch Question and Answers details*/
	public void fetchAnswers()
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
						From 	Questions__c 
						];
		system.debug('-----lstQuestion---'+lstQuestion);
		
		for(Questions__c objQues : lstQuestion)
		{
			strAnswerType = objQues.Answer_Type__c;
		}
		
		lstAnswer = [Select 	Yes__c, 
								Solution__c, 
								Product__r.Name, 
								Opportunity__c, 
								No__c, 
								Id
					 From 		Answer__c ];
					
		for(Answer__c objAns : lstAnswer)
		{
			system.debug('-----ENTIRE--------'+objAns);
			system.debug('------PRODUCT -------'+objAns.Product__r.Name);
		}
	}
	/*End of method fetchAnswers*/
	
	public void saveanswers()
	{
		update lstAnswer;
	}
}