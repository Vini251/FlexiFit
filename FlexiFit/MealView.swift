//
//  MealView.swift
//  FlexiFit
//
//  Created by Vini Patel on 2/17/24.
//

import Foundation
import SwiftUI
import CoreData

struct MealView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var breakfastFood: String = ""
    @State private var breakfastCalories: String = ""
    @State private var lunchFood: String = ""
    @State private var lunchCalories: String = ""
    @State private var snacksFood: String = ""
    @State private var snacksCalories: String = ""
    @State private var dinnerFood: String = ""
    @State private var dinnerCalories: String = ""
    
    let userEmail: String
        
    init(userEmail: String) {
        self.userEmail = userEmail
    }
    
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
            createStats(userEmail: userEmail,date: getCurrentDate()) { error in
                if let error = error {
                  print("Error creating Stats: \(error)")
                } else {
                  print("Stats created")
              }
            }
            updateStatsForDate(userEmail: userEmail,date: getCurrentDate(), fieldName: "CaloriesConsumed",value: totalCalories) { error in
                if let error = error {
                    print("Error updating CaloriesConsumed: \(error)")
                } else {
                    print("CaloriesConsumed updated successfully")
                }
            }
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

struct MealViewPreview: PreviewProvider {
    static var previews: some View {
        let userEmail = "vinip@uci.edu"
        MealView(userEmail: userEmail)
    }
}

