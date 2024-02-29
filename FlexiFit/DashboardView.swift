//
//  DashboardView.swift
//  FlexiFit
//
//  Created by Vini Patel on 2/17/24.
//

import SwiftUI
import CoreData
import HealthKitUI

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var activitySummary = HKActivitySummary()
    @State var percentage1: Double = 0
    @State var percentage2: Double = 0
    @State var percentage3: Double = 0
    @State private var healthStore = HealthManager()
    
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
            
            RecommendationsView()
                .padding(.horizontal)
            
            Spacer()
        }
    }
    
    func fetchDataAndUpdatePercentage() {
        Task {
            do {
                try await healthStore.fetchActiveCalories { activeCalories in
                    DispatchQueue.main.async {
                        self.percentage1 = activeCalories/500 * 100
                    }
                }
                try await healthStore.fetchStepData { steps in
                    DispatchQueue.main.async {
                        // Calculate average step count from 'steps' array and update 'percentage2'
                        self.percentage2 = steps/8000 * 100
                    }
                }
                try await healthStore.fetchSleepTime { sleepTime in
                    DispatchQueue.main.async {
                        // Convert sleep time to percentage and update 'percentage3'
                        self.percentage3 = (sleepTime/(8*3600)) * 100
                    }
                }
            } catch {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }

}




struct RecommendationsView: View {
    var body: some View {
        // Your code to display recommendation section
        // This can include workout recommendations, location, and duration
        // For demonstration, you can use placeholder text
        VStack(alignment: .leading, spacing: 20) {
            Text("Recommended Workout")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("Location: Weight Lifting")
                .font(.subheadline)
            
            Text("Duration: 50 minutes")
                .font(.subheadline)
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

#Preview{
    DashboardView()
}
