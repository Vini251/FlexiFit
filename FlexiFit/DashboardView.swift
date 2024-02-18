//
//  DashboardView.swift
//  FlexiFit
//
//  Created by Vini Patel on 2/17/24.
//

import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            Text("Today's Activity Level")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 50)
                .padding(.horizontal)
            
            ActivitySummaryRing()
                .frame(width: 200, height: 200) // Adjust size as needed
                .padding(.horizontal)
            
            RecommendationsView()
                .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct ActivitySummaryRing: View {
    var body: some View {
        ZStack {
            // Circle in the middle
            RoundedRectangle(cornerRadius: 100)
                .frame(width: 200, height: 200)
                .foregroundColor(.blue)
            
            // Add other elements as needed, such as text or icons
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

struct DashboardPreview: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
