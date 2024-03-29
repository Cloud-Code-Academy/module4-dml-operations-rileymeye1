/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Riley Meyer
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account acc = new Account(Name = 'Test Account');
        // Check CRUD prior to DML operation
        if (Account.SObjectType.getDescribe().isCreateable() &&
            Schema.SObjectType.Account.fields.Name.isCreateable()){
                // Insert the new account into the database if the User has access
                insert acc;
            } else {
                // return null if the User does not have access and do not insert the account
                return null;
            }
        // Return the Id of the newly created Account if the User has access to create the account
        return acc.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account newAccount = new Account(Name = name, Industry = industry);
        // Check CRUD prior to DML operation
        if (Account.SObjectType.getDescribe().isCreateable() &&
            Schema.SObjectType.Account.fields.Name.isCreateable() &&
            Schema.SObjectType.Account.fields.Industry.isCreateable()){
                // If the user has Create access to the Account object then insert the account into the database
                insert newAccount;
            }
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact = new Contact(FirstName = 'Riley', LastName = 'Meyer', AccountId = accountId);
        // Check CRUD prior to DML
        if (Contact.SObjectType.getDescribe().isCreateable() &&
            Schema.SObjectType.Contact.fields.FirstName.isCreateable() &&
            Schema.SObjectType.Contact.fields.LastName.isCreateable() &&
            Schema.SObjectType.Contact.fields.AccountId.isCreateable()) {
                // If the User has Create access on the Contact then insert the Contact to the database
                insert newContact;
            } else {
                // If the User does not have access to create Contacts then return null
                return null;
            }
        // Return the Id of the newly created Contact if the User has access to create Contacts
        return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact contactToUpdate = [SELECT Id FROM Contact WHERE Id = :contactId];
        // Check CRUD prior to DML action
        if (Contact.SObjectType.getDescribe().isUpdateable() &&
            Schema.SObjectType.Contact.fields.LastName.isUpdateable()){
                // Update the Contact's LastName with the provided newLastName
                contactToUpdate.LastName = newLastName;
                // Update the contact in the database
                update contactToUpdate;
            }
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity oppToUpdate = [SELECT Id FROM Opportunity WHERE Id = :oppId WITH SECURITY_ENFORCED];
        // Check CRUD prior to DML action
        if (Opportunity.SObjectType.getDescribe().isUpdateable() &&
            Schema.SObjectType.Opportunity.fields.StageName.isUpdateable()){
                // Update the Opp's Stage with the provided newStage
                oppToUpdate.StageName = newStage;
                // Update the Opp in the database
                update oppToUpdate;
            }
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account accToUpdate = [SELECT Id FROM Account WHERE Id = :accountId];
        // Check User CRUD prior to DML operation
        if (Account.SObjectType.getDescribe().isUpdateable() &&
            Schema.SObjectType.Account.fields.Name.isUpdateable() &&
            Schema.SObjectType.Account.fields.Industry.isUpdateable()){
                // Upate the Account's Name and Industry with the provided values
                accToUpdate.Name = newName;
                accToUpdate.Industry = newIndustry;
                // Update the Account in the database
                update accToUpdate;
            }
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        for (Opportunity opp : opportunities) {
            opp.StageName = 'Qualification';
            opp.CloseDate = Date.today().addMonths(3);
            opp.Amount = 50000;
        }
        if (Opportunity.SObjectType.getDescribe().isCreateable() &&
            Opportunity.SObjectType.getDescribe().isUpdateable() &&
            Schema.SObjectType.Opportunity.fields.StageName.isUpdateable() &&
            Schema.SObjectType.Opportunity.fields.CloseDate.isUpdateable() &&
            Schema.SObjectType.Opportunity.fields.Amount.isUpdateable()) {
            // Upsert the opportunities List so that records are either updated or created
                upsert opportunities;
            }
    }

/**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Variable to hold the account
        Account oppAccount;
        // Query the Account
        List<Account> accountsFound = [SELECT Id, Name FROM Account WHERE Name = :accountName];
        //Check if the Account exists in the accountsFound List if found set the oppAccount to that Account if not found create the Account
        if (accountsFound.size() > 0) {
            oppAccount = accountsFound[0];
        } else {
            Account newAccount = new Account(Name = accountName);
            insert newAccount;
            oppAccount = newAccount;
        }

        // Query to see if any of the Opportunities already exist
        List<Opportunity> opportunities = [SELECT Id, Name FROM Opportunity WHERE Name IN :oppNames AND AccountId = :oppAccount.Id];
        // This loop will create missing Opportunities and associate them with the Account
        for (String oppName : oppNames) {
            Boolean found = false;
            for (Opportunity opp : opportunities) {
                if (opp.Name.compareTo(oppName) == 0) {
                    found = true;
                    break;
                }
            }
            
            if (found == false) {
                // Create the Opportunity
                Opportunity newOpp = new Opportunity(
                    Name = oppName,
                    AccountId = oppAccount.Id,
                    StageName = 'Prospecting',
                    CloseDate = Date.today().addMonths(3)
                );
            
            	// Add the Opportunity to the list
                opportunities.add(newOpp);
            }
        }
        // Upsert the list of opportunities
        upsert opportunities;
    }



    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];
        if (accounts.size() > 0) {
            // if the Account exists, update the description
            accounts[0].Description = 'Updated Account';
        } else {
            // otherwise, create a new Account and set the description
            Account newAccount = new Account(Name = accountName, Description='New Account');
            accounts.add(newAccount);
        }
		// Upsert the Account
        upsert accounts;
		return accounts[0];
	}

    /**
     * Question 10
	 * Upserts accounts and links contacts to them based on the contact's last name and account name.
	 * Create or use existing account with contact last name. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
	 * Contacts are then linked to these accounts based on a full last name match.
     * Example Contact Last Name = Doe Link to Account Name = Doe 
     * Example Contact Last Name = Jane Link to Account Name = Jane
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// List to hold each contacts last name to be used as the Account Name
        List<String> accountNames = new List<String>();

        // Loop through each Contact
        for (Contact con : contactsToUpsert) {
            // Extract the Account Name from Contact's LastName
            String accountName = con.LastName;
            // Add the Account Name to the accountNames list
            accountNames.add(accountName);
        }
        
		// Get the account based on the name or create one if it doesn't exist
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name IN :accountNames];
        
        for (Integer i = 0, len = accountNames.size(); i < len; i++) {
            Boolean found = false;
            for (Account acc : accounts) {
                if (acc.Name == accountNames[i]) {
                    found = true;
                    break;
                }
            }
        
            if (found == false) {
                Account newAcc = new Account(Name = accountNames[i]);
                accounts.add(newAcc);
            }
        }

        // Upsert the Accounts
        upsert accounts;

        for (Contact con : contactsToUpsert) {
            for (Account acc : accounts) {
                if (acc.Name == con.LastName) {
                    con.AccountId = acc.Id;
                    break;
                }
            }
        }
        // Upsert the Contacts
        upsert contactsToUpsert;
    }


    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // List to hold my Leads
        List<Lead> leads = new List<Lead>();

        // Loop through each Lead name
        for (String leadName : leadNames) {
            // Insert a new lead
            Lead newLead = new Lead(LastName = leadName, Company = 'Orion');
            leads.add(newLead);
        }

        if (Lead.SObjectType.getDescribe().isCreateable() &&
            Schema.SObjectType.Lead.fields.LastName.isCreateable() &&
            Schema.SObjectType.Lead.fields.Company.isCreateable()) {
                // Insert the Leads
                insert leads;
            }
        
        if (Lead.SObjectType.getDescribe().isDeletable()) {
            // Delete the Leads
            delete leads;
        }
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Insert the cases

        // Delete the cases
    }
}