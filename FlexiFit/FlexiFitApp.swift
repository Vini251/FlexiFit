//
//  FlexiFitApp.swift
//  FlexiFit
//
//  Created by Vini Patel on 1/31/24.
//

import SwiftUI
import FirebaseCore
import HealthKit
import CoreData

@main
struct FlexiFitApp: App {
    @State private var isLoggedIn = false
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    //let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
                    //.environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
                    //.environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
