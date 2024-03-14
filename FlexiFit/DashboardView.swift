//
//  DashboardView.swift
//  FlexiFit
//
//  Created by Vini Patel on 2/17/24.
//

import SwiftUI
import CoreData
import HealthKitUI
import Foundation

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var activitySummary = HKActivitySummary()
    @State var percentage1: Double = 0
    @State var percentage2: Double = 0
    @State var percentage3: Double = 0
    @State private var healthStore: HealthManager
    @State var workoutRec: String = ""
    
    let userEmail: String
        
    init(userEmail: String) {
        self.userEmail = userEmail
        self._healthStore = State(initialValue: HealthManager(userEmail: userEmail))
        getRepsonse()
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            Text("Today's Activity Level")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 50)
                .padding(.horizontal)
        
            ZStack {
                RingView(lineWidth: 40, backgroundColor: Color.blue.opacity(0.2), foregroundColor: Color.blue, percentage: percentage1)
                
                .frame(width: 150, height: 150)
                //Active Calories
                
                RingView(lineWidth: 40, backgroundColor: Color.green.opacity(0.2), foregroundColor: Color.green, percentage: percentage2)
                
                .frame(width: 230, height: 230)
                //Step Count
                
                RingView(lineWidth: 40, backgroundColor: Color.pink.opacity(0.2), foregroundColor: Color.pink, percentage: percentage3)
                
                .frame(width: 310, height: 310)
                //Sleep time
            }
            VStack {
                HStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                    Text("Blue: Active Calories")
                }
                
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 20, height: 20)
                    Text("Green: Step Count")
                }
                
                HStack {
                    Circle()
                        .fill(Color.pink)
                        .frame(width: 20, height: 20)
                    Text("Pink: Sleep Time")
                }
            }
            .onAppear {
                fetchDataAndUpdatePercentage()
                
            }
            
            VStack{
                RecommendationsView(response: workoutRec)
                    .padding(.horizontal)
            }
             
            Spacer()
        }
    }
    
    func getRepsonse() {
        print("\(userEmail)")
        guard let url = URL(string: "http://localhost:8000/\(userEmail)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        print("\(request)")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //print("\(data)")
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                // Handle success response
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                    DispatchQueue.main.async {
                        self.workoutRec = responseString
                    }
                    // You can use the responseString here or parse it further if needed
                } else {
                    print("Invalid response data")
                }
            } else {
                print("Request failed: \(response?.description ?? "Unknown error")")
            }
        }.resume()
    }
    
    func fetchDataAndUpdatePercentage() {
        Task {
            do {
                createStats(userEmail: userEmail,date: getCurrentDate()) { error in
                    if let error = error {
                      print("Error creating Stats: \(error)")
                    } else {
                      print("Stats created")
                  }
                }
                try await healthStore.fetchActiveCalories { activeCalories in
                    updateStatsForDate(userEmail: self.userEmail,date: getCurrentDate(), fieldName: "ActiveCalories",value: activeCalories) { error in
                        if let error = error {
                            print("Error updating ActiveCalories: \(error)")
                        } else {
                            print("ActiveCalories updated successfully")
                        }
                    }
                    DispatchQueue.main.async {
                        self.percentage1 = activeCalories/500 * 100
                    }
                }
                try await healthStore.fetchStepData { steps in
                    updateStatsForDate(userEmail: userEmail,date: getCurrentDate(), fieldName: "Steps",value: steps) { error in
                        if let error = error {
                            print("Error updating Steps: \(error)")
                        } else {
                            print("Steps updated successfully")
                        }
                    }
                    DispatchQueue.main.async {
                        // Calculate average step count from 'steps' array and update 'percentage2'
                        self.percentage2 = steps/8000 * 100
                    }
                }
                try await healthStore.fetchSleepTime { sleepTime in
                    updateStatsForDate(userEmail: userEmail,date: getCurrentDate(), fieldName: "SleepTime",value: sleepTime) { error in
                        if let error = error {
                            print("Error updating SleepTime: \(error)")
                        } else {
                            print("SleepTime updated successfully")
                        }
                    }
                    DispatchQueue.main.async {
                        // Convert sleep time to percentage and update 'percentage3'
                        self.percentage3 = (sleepTime/(8*3600)) * 100
                    }
                }
                try await healthStore.fetchHeightData(){ height in
                    updateStatsForDate(userEmail: userEmail,date: getCurrentDate(),fieldName: "Height",value: height) { error in
                        if let error = error {
                            print("Error updating Height: \(error)")
                        } else {
                            print("Height updated successfully")
                        }
                    }
                    if let error = height {
                        print("fetching height: \(error)")
                    } else {
                        print("Error for height")
                    }
                }
                try await healthStore.fetchWeightData(){ weight in
                    updateStatsForDate(userEmail: userEmail,date: getCurrentDate(), fieldName: "Weight",value: weight) { error in
                        if let error = error {
                            print("Error updating Weight: \(error)")
                        } else {
                            print("Weight updated successfully")
                        }
                    }
                    if let error = weight {
                        print("fetching weight: \(error)")
                    } else {
                        print("Error for weight")
                    }
                }
                try await healthStore.fetchExerciseTime(){ exerciseTime in
                    updateStatsForDate(userEmail: userEmail, date: getCurrentDate(), fieldName: "CardioMinutes", value: exerciseTime){ error in
                        if let error = error {
                            print("Error updating exercise min: \(error)")
                        } else {
                            print("Exercise min updated successfully")
                        }
                    }
                }
                try await healthStore.fetchDateOfBirth(){ dob in
                    if let dateComponents = dob {
                        if let date = Calendar.current.date(from: dateComponents) {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MM_dd_yyyy"
                            let formattedDOB = dateFormatter.string(from: date)
                            updateUserInfo(userEmail: userEmail, fieldName: "DOB", value: formattedDOB) { error in
                                if let error = error {
                                    print("Error updating DOB: \(error)")
                                } else {
                                    print("DOB updated successfully")
                                }
                            }
                        } else {
                            print("Failed to create Date object from DateComponents")
                        }
                    } else {
                        print("Unable to fetch date of birth")
                    }
                }
                updateStatsForDate(userEmail: userEmail,date: getCurrentDate(), fieldName: "Score",value: ((self.percentage1 + self.percentage3 + self.percentage2)/3)) { error in
                    if let error = error {
                        print("Error updating Score: \(error)")
                    } else {
                        print("Steps updated successfully")
                    }
                }
                
                
            } catch {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }

}




struct RecommendationsView: View {
    let response: String
    init(response: String){
        self.response = response
    }
    var body: some View {
        // Your code to display recommendation section
        // This can include workout recommendations, location, and duration
        // For demonstration, you can use placeholder text
        
        VStack(alignment: .leading, spacing: 20) {
            Text("Recommended Workout")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("\(response)")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
}

struct RingView: View{
    
    let lineWidth: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    let percentage: Double
    
    var body: some View{
        GeometryReader { geometery in
            ZStack {
                RingShape()
                    .stroke(style: StrokeStyle(lineWidth: lineWidth))
                    .fill(backgroundColor)
                RingShape(percent: percentage)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .fill(foregroundColor)
            }
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: 1)
            .padding(lineWidth/2)
        }
        
    }
}


struct RingShape: Shape {
    
    var percent: Double
    let startAngle: Double
    
    typealias AnimatableData = Double
    var animatableData: Double{
        get{
            return percent
        }
        set{
            percent = newValue
        }
    }
    
    init(percent: Double = 100, startAngle: Double = -90){
        self.percent = percent
        self.startAngle = startAngle
    }
        
    static func percentToAngle(percent: Double, startAngle: Double) -> Double{
        return (percent / 100 * 360) + startAngle
    }
        
        
    func path(in rect: CGRect) -> Path {
        
        let width = rect.width
        let height = rect.height
        let radius = min (height, width) / 2
        let center = CGPoint(x: width / 2, y: height / 2)
        
        let endAngle = Self.percentToAngle(percent: percent, startAngle: startAngle)
        return Path { path in
            path.addArc (
                center: center,
                radius: radius,
                startAngle: Angle(degrees: startAngle),
                endAngle: Angle(degrees: endAngle),
                clockwise: false
            )
        }
    }
}

struct DashboardViewPreview: PreviewProvider {
    static var previews: some View {
        let userEmail = "vinip@uci.edu"
        DashboardView(userEmail: userEmail)
    }
}

