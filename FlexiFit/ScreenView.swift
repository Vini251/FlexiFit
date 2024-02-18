import SwiftUI
import HealthKit
import Firebase
import CoreData


struct ContentView: View {
    @State private var selectedTab = 0
    @Environment(\.managedObjectContext) private var viewContext
    //@EnvironmentObject var manager: HealthManager
    @State private var healthStore = HealthManager()
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            DashboardView()
                .environment(\.managedObjectContext, viewContext)
                //.environmentObject(manager)
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }
                .tag(0)
            
            MealView()
                .environment(\.managedObjectContext, viewContext)
                //.environmentObject(manager)
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("Meals")
                }
                .tag(1)
            
            ProfileView(isLoggedIn: .constant(true))
                .environment(\.managedObjectContext, viewContext)
                //.environmentObject(manager)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(2)
        }
        .task{
            await healthStore.requestAuthorization()
        }
        .accentColor(.blue) // Change the color of selected tab
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
