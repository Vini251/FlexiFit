import SwiftUI


struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }
                .tag(0)
            
            MealView()
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("Meals")
                }
                .tag(1)
            
            ProfileView(isLoggedIn: .constant(true))
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(.blue) // Change the color of selected tab
    }
}

struct DashboardView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            Text("Today's Activity Level")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 50)
                .padding(.horizontal)
            
            ActivitySummaryRing()
                .frame(width: 200, height: 200) // Adjust size as needed
                .padding(.horizontal)
            
            RecommendationsView()
                .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct ActivitySummaryRing: View {
    var body: some View {
        ZStack {
            // Circle in the middle
            RoundedRectangle(cornerRadius: 100)
                .frame(width: 200, height: 200)
                .foregroundColor(.blue)
            
            // Add other elements as needed, such as text or icons
        }
    }
}

struct RecommendationsView: View {
    var body: some View {
        // Your code to display recommendation section
        // This can include workout recommendations, location, and duration
        // For demonstration, you can use placeholder text
        VStack(alignment: .leading, spacing: 20) {
            Text("Recommended Workout")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("Location: Weight Lifting")
                .font(.subheadline)
            
            Text("Duration: 50 minutes")
                .font(.subheadline)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}


struct MealView: View {
    @State private var breakfastFood: String = ""
    @State private var breakfastCalories: String = ""
    @State private var lunchFood: String = ""
    @State private var lunchCalories: String = ""
    @State private var snacksFood: String = ""
    @State private var snacksCalories: String = ""
    @State private var dinnerFood: String = ""
    @State private var dinnerCalories: String = ""
    
    // Additional states for total calorie count and added meals
    @State private var totalCalories: Int = 0
    @State private var addedMeals: [Meal] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            // Breakfast
            Text("Breakfast")
                .font(.title)
            HStack {
                TextField("Food", text: $breakfastFood)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                TextField("Calories", text: $breakfastCalories)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                addButton(food: $breakfastFood, calories: $breakfastCalories)
            }
            
            // Lunch
            Text("Lunch")
                .font(.title)
            HStack {
                TextField("Food", text: $lunchFood)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                TextField("Calories", text: $lunchCalories)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                addButton(food: $lunchFood, calories: $lunchCalories)
            }
            
            // Snacks
            Text("Snacks")
                .font(.title)
            HStack {
                TextField("Food", text: $snacksFood)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                TextField("Calories", text: $snacksCalories)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                addButton(food: $snacksFood, calories: $snacksCalories)
            }
            
            // Dinner
            Text("Dinner")
                .font(.title)
            HStack {
                TextField("Food", text: $dinnerFood)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                TextField("Calories", text: $dinnerCalories)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                addButton(food: $dinnerFood, calories: $dinnerCalories)
            }
            
            // Added meals display
            VStack(alignment: .leading, spacing: 10) {
                Text("Added Meals:")
                    .font(.headline)
                ForEach(addedMeals, id: \.self) { meal in
                    Text("\(meal.food): \(meal.calories) calories")
                }
                Text("Total Calories: \(totalCalories)")
                    .font(.headline)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
    
    // Add Button to add meals and calories
    private func addButton(food: Binding<String>, calories: Binding<String>) -> some View {
        Button(action: {
            // Validate and convert calories to Int
            if let calorieInt = Int(calories.wrappedValue), calorieInt > 0 {
                // Add meal and calories to the list
                addedMeals.append(Meal(food: food.wrappedValue, calories: calorieInt))
                // Update total calorie count
                totalCalories += calorieInt
                // Clear text fields
                food.wrappedValue = ""
                calories.wrappedValue = ""
            }
        }) {
            Text("Add")
        }
        .padding(.horizontal)
    }
}

// Struct to represent a Meal
struct Meal: Identifiable, Hashable {
    let id = UUID()
    let food: String
    let calories: Int
}





struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    // Sample user data
    let userName = "John Doe"
    let userEmail = "john.doe@example.com"
    let lifestyleScore = 85 // Example lifestyle score
    
    // Sample workout preferences
    let fitnessPreferences = ["Weight Loss", "Fat Loss", "Maintaining Weight"]
    let workoutForms = ["Weight Lifting", "Cardio", "Run", "Walk", "Zumba"]

    @State private var selectedFitnessPreference = 0
    @State private var selectedWorkoutForm = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Profile")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.horizontal)

            // Display user name
            Text("Name: \(userName)")
                .font(.headline)
                .padding(.horizontal)

            // Display user email
            Text("Email: \(userEmail)")
                .font(.headline)
                .padding(.horizontal)

            // Display user lifestyle score
            Text("Lifestyle Score: \(lifestyleScore)")
                .font(.headline)
                .padding(.horizontal)

            Spacer()
            
            Text("Fitness Goal")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.horizontal)
            
            // Scrollable menu for fitness preferences
            Picker(selection: $selectedFitnessPreference, label: Text("Fitness Preference")) {
                ForEach(0..<fitnessPreferences.count, id: \.self) { index in
                    Text(fitnessPreferences[index]).tag(index)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding(.horizontal)
            
            Text("Workout Preference")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.horizontal)
            
            // Scrollable menu for workout forms
            Picker(selection: $selectedWorkoutForm, label: Text("Workout Form")) {
                ForEach(0..<workoutForms.count, id: \.self) { index in
                    Text(workoutForms[index]).tag(index)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding(.horizontal)

            Spacer()

            // Logout button
            Button(action: {
                // Perform logout action here
                // Example: Implement logout functionality
                isLoggedIn = false
                
            }) {
                Text("Log Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red) // Customize button color
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
