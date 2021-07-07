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

* User opens camera to scan barcode or ingredients list
* User logs in to access previous scans, chats and preference settings
* User sees generated report of product highlights, key ingredients, and safety evaluation of product 
* In the report, user can select from similar product recommendations with similar and safer products or similar and cheaper products 
* User can rate and review the product after purchasing 
* User can select ingredients to avoid (ie artificial sweeteners and high fructose corn syrup)
* Profile pages for each user
* User can access their scan history 
* User can display their favorite products on their profile page 
* Discover page where user can join communities (ie new moms community, keto diet community, low carbs community) and search for products 
* Communities will feature the top rated products selected by that community 
* Settings (Accesibility, Notification, General, etc.)

**Optional Nice-to-have Stories**

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
