//
//  FlexiFitApp.swift
//  FlexiFit
//
//  Created by Vini Patel on 1/31/24.
//

import Foundation
import SwiftUI
import Firebase
import HealthKit
import CoreData

@main
struct FlexiFApp: App {
    //@State private var isLoggedIn = false
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
        
    }
}
