//
//  FlexiFitApp.swift
//  FlexiFit
//
//  Created by Vini Patel on 1/31/24.
//

import SwiftUI

@main
struct FlexiFitApp: App {
    @State private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
