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
    
    
    func fetchStepData(completion: @escaping ([Step]) -> Void) async throws{
        
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
        var step: [Step] = []
        stepsCount.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let steps = Step(count: Int(count ?? 0), date: statistics.startDate)
            if steps.count > 0 {
                step.append(steps)
            }
        }
        completion(steps)
    }
    
    func fetchHeightData(completion: @escaping (Double?) -> Void) async throws {
        var averageHeight: Double?
        guard let healthStore = self.healthStore else { return }

        let heightType = HKQuantityType.quantityType(forIdentifier: .height)!
        let query = HKStatisticsQuery(quantityType: heightType,
                                      quantitySamplePredicate: nil,
                                      options: .discreteAverage) { query, result, error in
            guard let result = result, let averageQuantity = result.averageQuantity() else {
                if let error = error {
                    print("Error fetching height data: \(error.localizedDescription)")
                }
                completion(nil)
                return
            }
            let heightInMeters = averageQuantity.doubleValue(for: HKUnit.meter())
            
            averageHeight = heightInMeters // Assign average height
            completion(averageHeight) // Call completion with average height
        }
        
        healthStore.execute(query)
        
    }

    func fetchWeightData(completion: @escaping (Double?) -> Void) async throws {
        var averageWeight: Double?
        guard let healthStore = self.healthStore else { return }

        let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let query = HKStatisticsQuery(quantityType: weightType,
                                      quantitySamplePredicate: nil,
                                      options: .discreteAverage) { query, result, error in
            guard let result = result, let averageQuantity = result.averageQuantity() else {
                if let error = error {
                    print("Error fetching weight data: \(error.localizedDescription)")
                }
                completion(nil)
                return
            }
            let weightInKilograms = averageQuantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            
            averageWeight = weightInKilograms
            completion(averageWeight)
        }
        
        healthStore.execute(query)
        
    }

    // Function to fetch active calories
    func fetchActiveCalories(completion: @escaping (Double) -> Void) async throws {
        var activeCalorie: Double = 0
        guard let healthStore = self.healthStore else { return }
        let activeEnergyBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let calendar = Calendar.current
        var startDateComponents = DateComponents()
        startDateComponents.year = 2024
        startDateComponents.month = 1
        startDateComponents.day = 1
        let startDate = calendar.date(from: startDateComponents)
        
        var endDateComponents = DateComponents()
        endDateComponents.year = 2024
        endDateComponents.month = 2 // February 1st
        endDateComponents.day = 1
        let endDate = calendar.date(from: endDateComponents)
        
        guard let startDate = startDate, let endDate = endDate else { return }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: activeEnergyBurnedType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, statistics, error in
            guard let statistics = statistics, error == nil else {
                print("Error fetching active energy burned data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let activeCalories = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            print("Active calories burned in January: \(activeCalories)")
            activeCalorie = activeCalories
            completion(activeCalorie)
        }
        
        healthStore.execute(query)
    }

    
    // Function to fetch sleep time
    func fetchSleepTime(completion: @escaping (TimeInterval) -> Void) async throws {
        var sleep: TimeInterval = 0
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
            //print("Sleep time: \(sleepTime) seconds")
            sleep = sleepTime
            completion(sleep)
        }
        
        healthStore.execute(query)
        
    }




}
