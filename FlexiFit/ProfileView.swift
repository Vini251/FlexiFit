//
//  ProfileView.swift
//  FlexiFit
//
//  Created by Vini Patel on 2/17/24.
//

import Foundation
import SwiftUI
import CoreData

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isLoggedIn: Bool
    @State var lifestyleScore = 0
    
    // Sample workout preferences
    let fitnessPreferences = ["Weight Loss", "Fat Loss", "Maintaining Weight"]
    let GymBool = ["No", "Yes"]

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
    
//    createUser(userEmail: self.userEmail)
//    updateUserInfo(userEmail: self.userEmail, fieldname: "Preference", value: selectedFitnessPreference)
//    if selectedWorkoutForm == 1 {
//        updateUserInfo(self.userEmail, "Gym",true)
//    } else {
//        updateUserInfo(self.userEmail, "Gym",false)
//    }
    

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
//            createUser(userEmail: self.userEmail)
//            updateUserInfo(userEmail: self.userEmail, fieldname: "Preference", value: selectedFitnessPreference)
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
                .onChange(of: submittedCity){ newValue in
                    updateUserInfo(userEmail: self.userEmail, fieldName: "City",value: newValue){ error in
                        if let error = error {
                            print("Error updating user info: \(error)")
                        } else {
                            print("user info updated")
                        }
                    }
                    
                }

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
            .onChange(of: selectedFitnessPreference) { newValue in
                createUser(userEmail: self.userEmail){ error in
                    if let error = error {
                        print("Error creating user: \(error)")
                    } else {
                        print("user created")
                    }
                }
                updateUserInfo(userEmail: self.userEmail, fieldName: "Preference", value: newValue){ error in
                    if let error = error {
                        print("Error updating user info: \(error)")
                    } else {
                        print("user info updated")
                    }
                }
            }
            
            Text("Gym Preference")
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
            .onChange(of: selectedWorkoutForm) { newValue in
                if selectedWorkoutForm == 1 {
                    updateUserInfo(userEmail: self.userEmail, fieldName: "Gym",value: true){ error in
                        if let error = error {
                            print("Error updating user info: \(error)")
                        } else {
                            print("user info updated")
                        }
                    }
                } else {
                    updateUserInfo(userEmail: self.userEmail, fieldName: "Gym",value: false){ error in
                        if let error = error {
                            print("Error updating user info: \(error)")
                        } else {
                            print("user info updated")
                        }
                    }
                }
            }
            
            

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
            
        }
        .padding()
        .onAppear(){
            fetchLifestyleScore()
        }
        
    }
    
    func fetchLifestyleScore(){
        let statsRef = db.collection("User").document(userEmail).collection("Stats").document(getCurrentDate())

        createStats(userEmail: userEmail, date: getCurrentDate()) { error in
            if let error = error {
                print("Error creating Stats: \(error)")
            } else {
                print("Stats created")
            }
        }

        statsRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error)")
            } else if let document = document, document.exists {
                if let score = document.data()?["Score"] as? Double {
                    DispatchQueue.main.async {
                        self.lifestyleScore = Int(score)
                    }
                    print("Lifestyle score: \(lifestyleScore)")
                } else {
                    print("Score field does not exist in the document")
                }
            } else {
                print("Document does not exist")
            }
        }
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
