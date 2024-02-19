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
                .onTapGesture {
                    self.percentage1 = 20
                }
                
                RingView(lineWidth: 40, backgroundColor: Color.green.opacity(0.2), foregroundColor: Color.green, percentage: percentage2)
                
                .frame(width: 230, height: 230)
                .onTapGesture {
                    self.percentage2 = 50
                }
                
                RingView(lineWidth: 40, backgroundColor: Color.pink.opacity(0.2), foregroundColor: Color.pink, percentage: percentage3)
                
                .frame(width: 310, height: 310)
                .onTapGesture {
                    self.percentage3 = 80
                }
            }
            
            RecommendationsView()
                .padding(.horizontal)
            
            Spacer()
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
