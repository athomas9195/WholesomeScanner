Original App Design Project 
===

# Wholesome

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
<!-- 1. [Wireframes](#Wireframes)
2. [Schema](#Schema) -->

## Overview
### Description
The ingredient scanner lets the user scan a barcode of any item at the store or scan the ingredients list of any product and instantly get a report of any harmful chemicals or unhealthy additives within the product. Inspired by a real problem I encountered.

### App Evaluation

- **Category:** Health / Social Networking
- **Mobile:** Camera, location, real time. Mobile is essential for the instant results and portabiilty aspects of the app.
- **Story:** Builds a community of people who put their health first and brings safety issues of big corporations to the forefront of discussion. It also recommends healthier alternatives to the product they scanned (promotes health and also generates income). And it will let the user rate the product they scanned so that other users can make better decisions.
- **Market:** Parents who want to ensure the safety of their baby products and people who want to take care of their health and wellbeing.
- **Habit:**  It can become an essential tool for households and individuals who want to ensure a better lifestyle.
- **Scope:** Will need to find an API with a database of health and safety information. Probably will have to refer to the FDA. Hoping to add a community feature where people can share their insights and bring people closer together in the health community. Large potential for use with stores like Whole Foods.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

**Bundles**

*User*
* User logs in to access previous scans and preference settings
* Profile pages for each user
* User can access their scan history 

*User preferences*
* Generate categories and lists for ingredients 
* User can select custom ingredients to avoid (ie artificial sweeteners and high fructose corn syrup)
* User can select categories of ingredients to avoid 

*Scanner*
* User opens camera to scan barcode or ingredients list
* App compares scanned product (through API) against list of ingredients selected by user 

*Report*
* User sees generated report of product highlights, key ingredients, and safety evaluation of product
* User sees "bad" ingredients 
* User sees "good" ingredients  
* In the report, user can select from similar product recommendations with similar and safer products or similar and cheaper products 
* User can rate and review the product after purchasing 

*Settings*
* Settings (Accesibility, Notification, General, etc.)

**Optional Nice-to-have Stories**

* Discover page where user can join communities (ie new moms community, keto diet community, low carbs community) and search for products 
* Communities will feature the top rated products selected by that community 
* User can display their favorite products on their profile page 
* User can compare and contrast two different products
* User can group their favorite products to form a shopping list or a starter-kit  
* User can check and uncheck items in shopping list 
* User can search for a product and see cheaper or safer alternatives
* In the ingredients report, display what the ingredient does or what its main function is (ie Phenoxyethanol - preservative)
* In the search feature on the discovery page, user can display the results by price and by rating 
* User can share their favorite products with friends through in-app sharing 
* Communities will feature forums and trending products 
* User can post on community forums 
* User profile shows a map of user's favorite stores 
* User profile shows a map of food donation locations
* A focus on infant and children's needs
* See reviews of scanned product online 
 
### 2. Screen Archetypes

* Onboarding 
* Camera View (Scan)
* Report Page (Detail)
* Login 
* Register - User signs up or logs into their account
   * The user is prompted to log in to gain access to their profile information 
   * Gives access to scan history, favorites, reviews, communities, and discover page 
*  Discover Page - A place for communities and product search (Stream)
   * Communities page- Displays top and recommended communities 
   * Products page- Displays categories and a search bar 
* Profile Screen (Profile)
   * Allows user to upload a photo and fill in information used for scanning and searching 
   * User can select ingredients they want to avoid
   * User can see and review their favorite products 
   * User can see communities they are in 
* Ingredient Selection Screen (Detail)
   * Allows user to be able to choose ingredients they want to avoid or are allergic to. 
   * Allows user to choose ingredients they really like.
   * These selections will factor into the ingredients report and will be highlighted. 
* Settings Screen (Settings)
   * Lets people change language, and app notification settings.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Scan 
* Discover 
    * Communities 
    * Products 
* Profile

**Flow Navigation** (Screen to Screen)

* Onboarding -> Camera View 
* Camera View (Scan) -> Ingredients report
* Ingredients report -> Log in to save this scan 
* Log-in -> Account creation if no log in is available
* Discover page -> Discover communties -> Community forums 
* Discover page -> Discover products -> Search bar -> product results 
* Profile -> Ingredient Selection Screen -> Text field to be modified
* Settings -> Toggle settings

**Schema**
* *Models*
* Scan  
   | Property      | Type     | Description | 
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | author        | Pointer to User| scan author |
   | image         | File     | image that user takes of the barcode |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
   | user rating   | Number   | the user's rating of the product out of 5 |
   | safety rating | Number   | the product's safety rating |
   | key ingredients | Array  | the product's key ingredients (highlights) |
   | good ingredients| Array  | the product's good ingredients |
   | bad ingredients | Array  | the product's allergens or harmful additives |
   
   
* User   
   | Property      | Type     | Description | 
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | username      | String   | user's name |
   | image         | File     | user's profile image |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
   | scan history  | Array (of Scan Pointers)  | an array of Pointers to the Scan object | 
   | custom bad ingreds  | Array (String) | a custom array of ingredients to avoid | 
   | custom goood ingreds| Array (String) | a custom array of ingredients to highlight | 
   | selected ingredients| Array (String)| an array of provided ingredients user wants to avoid | 


### Networking
#### List of network requests by screen
   - Profile Screen
      - (Read/GET) Query all scans where user is author
         ```obj c
           // construct PFQuery
          PFQuery *scanQuery = [Scan query];
          [postQuery orderByDescending:@"createdAt"];
          [postQuery includeKey:@"author"];
          [postQuery whereKey:@"author" equalTo: [PFUser currentUser]];
          postQuery.limit = postLimit;

          // fetch data asynchronously
          [scanQuery findObjectsInBackgroundWithBlock:^(NSArray<Scan *> * _Nullable scans, NSError * _Nullable error) {
              if (scans) {
                  NSMutableArray* scansMutableArray = [scans mutableCopy];
                  self.scans = scansMutableArray;
                  [self.collectionView reloadData];
              }
              else {
                  NSLog(@"%@", error.localizedDescription);
                  NSLog(@"%@", @"CANNOT GET STUFF");
              }
          }];
         ```
      - (Create/POST) Create a new rating on a scan 
      - (Delete) Delete existing rating 
      - (Create/POST) Create a new ingredient group or custom ingredient 
      - (Delete) Delete existing ingredient 
      - (Update/PUT) Create a new profile pic 
      - (Read/GET) Query logged in user object
      
   - Scan Screen
      - (Create/POST) Create a new scan object 
      - (Read/GET) Query custom good/bad ingredients and user's selected ingredients
      
#### [OPTIONAL:] Existing API Endpoints
##### Chomp API
- Base URL - https://github.com/chompfoods?tab=repositories&q=SDK ??SDK? $0.01 per request?

   HTTP Verb | Endpoint | Description
   ----------|----------|------------
    `GET`    | /characters | 
    `GET`    | /characters/?name=name | 
    `GET`    | /houses   | 
    `GET`    | /houses/?name=name |  

##### USDA Food Data Central API 
- Base URL - https://fdc.nal.usda.gov/api-guide.html 

   HTTP Verb | Endpoint | Description
   ----------|----------|------------
    `GET`    | /cities | 
    `GET`    | /cities/byId/:id | 
    `GET`    | /continents | 
    `GET`    | /continents/byId/:id | 
    `GET`    | /regions | 
    `GET`    | /regions/byId/:id | 
    `GET`    | /characters/paths/:name | 



**Wireframes**
![alt text](https://github.com/athomas9195/WholesomeScanner/blob/main/Wireframes%20Image.png)

![alt text](https://github.com/athomas9195/WholesomeScanner/blob/main/figma%20mockup.png)

**Timeline**
![alt text](https://github.com/athomas9195/WholesomeScanner/blob/main/Screen%20Shot%202021-07-12%20at%205.41.17%20PM.png)
![alt text](https://github.com/athomas9195/WholesomeScanner/blob/main/Project%20Plan%202.png)

<!-- ## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp] -->
