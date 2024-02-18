//
//  ProfileView.swift
//  FlexiFit
//
//  Created by Vini Patel on 2/17/24.
//

import SwiftUI
import CoreData

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
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
            
            NavigationLink(destination: LoginView()){
                    LogoutButtonContent()
                
            }
            
            .padding(.bottom, 20)
        }
        .padding()
    }
}

#Preview {
    ProfileView(isLoggedIn: .constant(true))
}
