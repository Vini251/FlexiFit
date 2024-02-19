//
//  HealthManager.swift
//  FlexiFit
//
//  Created by Vini Patel on 2/17/24.
//

import Foundation
import HealthKit
import Observation

enum HealthError: Error {
    case healthDataNotAvailable
}

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}

@Observable
class HealthManager{
    var steps: [Step] = []
    var healthStore: HKHealthStore?
    var lastError: Error?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            lastError = HealthError.healthDataNotAvailable
        }
    }
    
    func requestAuthorization() async {
        guard let heightType = HKQuantityType.quantityType(forIdentifier: .height),
              let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass),
              let activeEnergyBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned),
              let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else {
            return
        }
        
        guard let healthStore = self.healthStore else { return }
        
        do {
            // Request authorization to read the specified data types
            let typesToRead: Set<HKObjectType> = [heightType, weightType, activeEnergyBurnedType, stepCountType, sleepType]
            let typesToShare: Set<HKSampleType> = [] // No data to share in this example
            
            try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
        } catch {
            lastError = error
        }
    }
    
    
    func fetchStepData() async throws{
        guard let healthStore = self.healthStore else { return }
        
        //let calender = Calender(indentifier: .gregorian)
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let endDate = Date()
        
        let stepType = HKQuantityType(.stepCount)
        let everyDay = DateComponents(day:1)
        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let stepThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate: thisWeek)
        
        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: stepThisWeek, options: .cumulativeSum, anchorDate: endDate, intervalComponents: everyDay)
        
        let stepsCount = try await sumOfStepsQuery.result(for: healthStore)
        
        guard let startDate = startDate else { return }
        
        stepsCount.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            if step.count > 0 {
                self.steps.append(step)
            }
        }
        
    }
    
    func fetchHeightData() async throws {
        guard let healthStore = self.healthStore else { return }

        let heightType = HKQuantityType.quantityType(forIdentifier: .height)!
        let query = HKStatisticsQuery(quantityType: heightType,
                                      quantitySamplePredicate: nil,
                                      options: .discreteAverage) { query, result, error in
            guard let result = result, let averageHeight = result.averageQuantity() else {
                if let error = error {
                    print("Error fetching height data: \(error.localizedDescription)")
                }
                return
            }
            let heightInMeters = averageHeight.doubleValue(for: HKUnit.meter())
            print("Average height: \(heightInMeters) meters")
        }
        
        healthStore.execute(query)
    }

    func fetchWeightData() async throws {
        guard let healthStore = self.healthStore else { return }

        let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let query = HKStatisticsQuery(quantityType: weightType,
                                      quantitySamplePredicate: nil,
                                      options: .discreteAverage) { query, result, error in
            guard let result = result, let averageWeight = result.averageQuantity() else {
                if let error = error {
                    print("Error fetching weight data: \(error.localizedDescription)")
                }
                return
            }
            let weightInKilograms = averageWeight.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            print("Average weight: \(weightInKilograms) kilograms")
        }
        
        healthStore.execute(query)
    }

    // Function to fetch active calories
    func fetchActiveCalories() async throws {
        guard let healthStore = self.healthStore else { return }
        let activeEnergyBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: activeEnergyBurnedType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, statistics, error in
            guard let statistics = statistics, error == nil else {
                print("Error fetching active energy burned data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let activeCalories = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            print("Active calories burned: \(activeCalories)")
        }
        
        healthStore.execute(query)
    }
    
    // Function to fetch sleep time
    func fetchSleepTime() async throws {
        guard let healthStore = self.healthStore else { return }
        let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            guard let samples = samples as? [HKCategorySample], error == nil else {
                print("Error fetching sleep time data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let sleepTime = samples.reduce(0.0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
            print("Sleep time: \(sleepTime) seconds")
        }
        
        healthStore.execute(query)
    }




}
