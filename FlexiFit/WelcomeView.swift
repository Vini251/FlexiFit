//
//  WelcomeView.swift
//  FlexiFit
//
//  Created by Vini Patel on 2/18/24.
//

import SwiftUI
import HealthKit

struct WelcomeView: View {
    var body: some View {
        NavigationView(){
            NavigationLink(destination: LoginView()){
                LoginButtonContent()
            }
        }
        
    }
    
}

struct LoginButtonContent : View {
    var body: some View {
        return Text("LOG IN")
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 220, height: 40)
            .background(Color.blue)
            .cornerRadius(5.0)
    }
}

struct LogoutButtonContent : View {
    var body: some View {
        return Text("LOG OUT")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red) // Customize button color
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

#Preview{
    WelcomeView()
}
