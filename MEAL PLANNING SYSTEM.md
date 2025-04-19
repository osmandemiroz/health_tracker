

# Step 1: Requirement Analysis
With the growth in the number of The Meal Planning Systems available. In today's conditions, there are many applications for people to gain weight and provide the need for a healthy life in the easiest way.These systems would also require a database to help store and keep track of data.

`	`Therefore, we will focus on building a detailed Smart Recipe and Meal Planning System to create a comprehensive database system to manage daily diet and cooking routines, and perhaps a system that can also be used by professionals such as dietitians. In this system, what we are most concerned about is to transmit the data to the user in the most reliable and fastest way from the very detailed database.
## Requirements
`	`Saving the meal planning system to a user-specific system, such as saving the specific meal details of the users to the system, recommending a meal according to their allergic conditions. It would allow users with varying levels of details to search, offer meal suggestion.
## Functionalities
1. Users must be able to register with the system with unique ID, name, address, phone number, allergies.
1. System must maintain a database of recipes with nutritional information.
1. Users must be able to search for recipes based on various criteria (ingredients, calories, etc.)
1. Users must be able to view detailed nutritional information for each recipe
1. Users must be able to save favorite recipes for future reference
1. Users must be able to create daily meal plans
1. Users must be able to add recipes to specific meal times (breakfast, lunch, dinner, snacks)
1. System must calculate and display total daily nutritional intake
1. Users must be able to view meal history and track trends
1. System must track daily calorie intake
## Interesting Queries
1. Which breakfast have no sugar?
1. What is the breakfast for someone who is allergic to mustard?
1. Which breakfast is the highest in magnesium?
1. What are the meals that take the shortest time to make for a daily nutrient deficit of 2000 calories?
1. What is the lowest fat meal for dinner?




# Step 2: Entity- Relationship (E/R) Diagrams
## Entity Sets
1. USER (from 1st point)
1. GOAL (from 2nd point)
1. RECIPE (from 3rd point)
## <a name="ole_link1"></a>Attributes & Primary Keys
## **1.** USER
- **UID** (Primary Key)
- Account Creation Date
- Access Level
- Name
- Email
- Dietary Preferences
## **2.** GOAL
- **GID** (Primary Key)
- Goal Type (e.g., Weight Loss, Muscle Gain)
- Start Date
- End Date
- Target Calories
- Target Protein
- Target Carbs
- Target Fat
## **3.** RECIPE
- **RID** (Primary Key)
- Name
- Image
- Yields
- Ingredients
- Prep Time
- Cook Time
- Calories/Serving
- Instruction List
- Description
- Category
- Ingredients
- Servings
- Nutritional Values 
  - Calories
  - Carbohydrates
  - Sugars
  - Fat
  - Saturated Fat
  - Protein
  - Cholesterol
  - Magnesium
  - Potassium
  - Vitamins (A, C, etc.)
  - Niacin
  - Folate
  - Dietary Fiber
  - Calcium
  - Iron














## Relationships
## 1\. SETS 
- **Type**: 1:N (One-to-Many)
- **Between**: USER and GOAL
- **Participation Details**: 
  - USER side: Partial Participation 
    - A user may or may not have goals
    - Not mandatory to set goals
  - GOAL side: Total Participation 
    - Every goal must be associated with a specific user
    - Cannot exist without a user reference
## 2\. CREATES/SAVES 
- **Type**: M:N (Many-to-Many)
- **Between**: USER and RECIPE
- **Relationship Attributes**: 
  - Creation Date
  - Save Date
  - IsFavorite (Boolean flag)
- **Participation Details**: 
  - USER side: Partial Participation 
    - Users can exist without creating or saving recipes
  - RECIPE side: Partial Participation 
    - Recipes can exist without being created or saved by users
    - Allows system-generated recipes
## 3\. ALIGNS\_WITH 
- **Type**: M:N (Many-to-Many)
- **Between**: GOAL and RECIPE
- **Purpose**: 
  - Match recipes with specific fitness or nutrition goals
  - Recommend recipes based on user objectives
- **Relationship Attributes**: 
  - Compatibility Score (Numeric rating, e.g., 1-5)
- **Example Scenarios**: 
  - Low-carb recipes for weight loss goals
  - High-protein recipes for muscle gain goals
## 4\. TRACKS\_PROGRESS 
- **Type**: 1:1 (One-to-One)
- **Between**: USER and GOAL
- **Relationship Attributes**: 
  - Current Weight
  - Progress Percentage
  - Last Updated Date
- **Purpose**: 
  - Monitor and track individual goal achievements
  - Record user's progress towards specific fitness objectives
## 5\. MANAGES 
- **Type**: M:N (Many-to-Many)
- **Between**: USER (Admin) and USER (Regular User)
- **Participation Details**: 
  - ADMIN side: Partial Participation 
    - Not all administrators manage users
    - Flexible admin management structure
  - USER side: Total Participation 
    - Every user must have an associated administrator
    - Ensures system governance and user accountability
##
##






## E/R Diagram

![A diagram of a diagram

AI-generated content may be incorrect.](Aspose.Words.33dbd085-74bf-430c-9dc6-2e7a442ac231.002.png)

