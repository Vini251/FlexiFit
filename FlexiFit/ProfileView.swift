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
    //let userName = "John Doe"
    //let userEmail = "john.doe@example.com"
    let lifestyleScore = 85 // Example lifestyle score
    
    // Sample workout preferences
    let fitnessPreferences = ["Weight Loss", "Fat Loss", "Maintaining Weight"]
    let GymBool = ["Yes", "No"]

    @State private var selectedFitnessPreference = 0
    @State private var selectedWorkoutForm = 0
    @State private var city = ""
    @State private var state = ""
    @State private var submittedCity = ""
    @State private var submittedState = ""
    
    let userEmail: String
    init(isLoggedIn: Binding<Bool>, userEmail: String) {
        self._isLoggedIn = isLoggedIn
        self.userEmail = userEmail
    }
    

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Profile")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.horizontal)

            // Display user name
//            Text("Name: \(userName)")
//                .font(.headline)
//                .padding(.horizontal)

            // Display user email
            Text("Email: \(userEmail)")
                .font(.headline)
                .padding(.horizontal)

            // Display user lifestyle score
            Text("Lifestyle Score: \(lifestyleScore)")
                .font(.headline)
                .padding(.horizontal)
            
            // Display submitted city and state
            Text("Location: \(submittedCity), \(submittedState)")
                .font(.headline)
                .padding(.horizontal)

            //Spacer()
            
            Text("Fitness Goal")
                .font(.subheadline)
                .fontWeight(.bold)
                //.padding(.top, 20)
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
                //.padding(.top, 20)
                .padding(.horizontal)
            
            // Scrollable menu for workout forms
            Picker(selection: $selectedWorkoutForm, label: Text("Gym or No Gym")) {
                ForEach(0..<GymBool.count, id: \.self) { index in
                    Text(GymBool[index]).tag(index)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding(.horizontal)

            //Spacer()
            
            HStack {
                TextField("City", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    //.padding()
                
                TextField("State", text: $state)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    //.padding()
            }
            .padding(.horizontal)
            
            VStack {
                Button(action: {
                    // Update submitted city and state
                    submittedCity = city
                    submittedState = state
                }) {
                    Text("Submit")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 120)
                
            }
            //.padding(.top, 20)
            .padding(.horizontal)
            
            
            NavigationLink(destination: LoginView()){
                    LogoutButtonContent()
                
            }
            
            //.padding(.bottom, 20)
        }
        .padding()
    }
}

//#Preview {
//    let userEmail = "vinip@uci.edu"
//    ProfileView(isLoggedIn: .constant(true), userEmail: userEmail)
//}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userEmail = "vinip@uci.edu"
        ProfileView(isLoggedIn: .constant(true), userEmail: userEmail)
    }
}
