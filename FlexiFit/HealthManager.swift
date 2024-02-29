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
    
    
    func fetchStepData(completion: @escaping (Double) -> Void) async throws{
        
        let steps = HKQuantityType(.stepCount)
        guard let healthStore = self.healthStore else { return }
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate){ _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else{
                print("error fetching steps")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            completion(stepCount)
            
        }
        healthStore.execute(query)
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
        let calories = HKQuantityType(.activeEnergyBurned)
        guard let healthStore = self.healthStore else { return }
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate){ _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else{
                print("error fetching calories")
                return
            }
            
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            completion(caloriesBurned)
            
        }
        healthStore.execute(query)
    }

    
    // Function to fetch sleep time
    func fetchSleepTime(completion: @escaping (TimeInterval) -> Void) async throws {
        var sleep: TimeInterval = 0
        guard let healthStore = self.healthStore else { return }
        let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            guard let samples = samples as? [HKCategorySample], error == nil else {
                print("Error fetching sleep time data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let sleepTime = samples.reduce(0.0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
            sleep = sleepTime
            completion(sleep)
        }
        
        healthStore.execute(query)
        
    }




}
