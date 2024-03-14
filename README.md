# FlexiFit

**Contribution:**
1. Frontend (UI and Client side): Vini Patel
2. Backend (Recommendation Algorithm and Server side): Issac Texeira
3. Firebase: Jason Ly
4. Open Weather API: Sean Park



**Goals:**
Our iOS system will recommend workouts based upon the user’s meal history, physical statistics, and lifestyle goals. Data will be taken from the Health App using the HealthKit API. OpenWeather’s API will be used as a contextual data source to inform workout recommendations. Data retrieved from the user will be stored in a database. The user will be asked to provide their personal information when they first launch the application, including their height, weight, and food preference. The user’s meals will be tracked with regular prompts about what they ate, what they drank, and their level of satisfaction.

**Data Sources:**
1. iOS devices come with the Health App, which tracks statistics such as the user’s sleep statistics. Our application will access this information through the HealthKit API.
2. Regular information about the user’s diet will be collected via questionnaire.
3. The user’s physical statistics, such as age and height, will be collected when the application is first launched.
4. OpenWeather’s API will be used to add context to our recommendations.

**App Layout:**
* Login: A login page will distinguish between users, allowing each user’s data to be kept separately.
* Dashboard: A display will provide the user with workout recommendations.
* Meal Record: The user’s food and water intake will be recorded and displayed here.
* Profile: The user’s lifestyle score and profile will be displayed here.

**Architecture:**
* Platform: iOS
* Frontend: SwiftUI
* Backend: Python
* Database: Firebase
* Data Integration: HealthKit and OpenWeather APIs
* Design: Figma
* Version Control: Git, hosted on GitHub

**Milestones:**
* Learn SwiftUI and then develop UI for different sections of the application.
* Set up the Firebase database.
* Integrate the HealthKit API to track users’ daily activity and sleep schedule.
* Connect the frontend with backend components.
* Develop workout recommendation algorithms based on meals, activity and sleep. This step needs to implement a ML/AI algorithm.

**Login Screen**
<img width="315" alt="login" src="https://github.com/Vini251/FlexiFit/assets/80379653/48603af5-3f46-46d6-a152-39f8ea3d1862">

**Dashboard:**
<img width="315" alt="dashboard" src="https://github.com/Vini251/FlexiFit/assets/80379653/e4de407a-b776-426b-bbcc-ff4e98f85790">

**Meal:**
<img width="315" alt="image" src="https://github.com/Vini251/FlexiFit/assets/80379653/cff6878a-3c50-474a-b71e-963b212dbe13">

**Profile:**
<img width="315" alt="profile" src="https://github.com/Vini251/FlexiFit/assets/80379653/939b335d-e51e-4843-902a-08794e17117b">








