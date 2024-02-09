//
//  FlexiFitApp.swift
//  FlexiFit
//
//  Created by Vini Patel on 1/31/24.
//

import SwiftUI
import FirebaseCore


@main
struct FlexiFitApp: App {
    @State private var isLoggedIn = false
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


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
