//
//  HealthKitConfig.swift
//  BeeSwift
//
//  Created by Andy Brett on 3/25/17.
//  Copyright © 2017 APB. All rights reserved.
//

import Foundation
import HealthKit

struct HealthKitMetric {
    let humanText : String
    let databaseString : String?
    let hkIdentifier : HKQuantityTypeIdentifier?
    let hkCategoryTypeIdentifier : HKCategoryTypeIdentifier?
}

class HealthKitConfig : NSObject {
    static let shared = HealthKitConfig()
    
    var metrics : [HealthKitMetric] {
        var mets = [
            HealthKitMetric.init(humanText: "Steps", databaseString: "steps", hkIdentifier: HKQuantityTypeIdentifier.stepCount, hkCategoryTypeIdentifier: nil),
            HealthKitMetric.init(humanText: "Active energy", databaseString: "activeEnergy", hkIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned, hkCategoryTypeIdentifier: nil),
            HealthKitMetric.init(humanText: "Exercise time", databaseString: "exerciseTime", hkIdentifier: HKQuantityTypeIdentifier.appleExerciseTime, hkCategoryTypeIdentifier: nil),
            HealthKitMetric.init(humanText: "Weight", databaseString: "weight", hkIdentifier: HKQuantityTypeIdentifier.bodyMass, hkCategoryTypeIdentifier: nil),
            HealthKitMetric.init(humanText: "Cycling distance", databaseString: "cyclingDistance", hkIdentifier: HKQuantityTypeIdentifier.distanceCycling, hkCategoryTypeIdentifier: nil),
            HealthKitMetric.init(humanText: "Walking/running distance", databaseString: "walkRunDistance", hkIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning, hkCategoryTypeIdentifier: nil),
            HealthKitMetric.init(humanText: "Nike Fuel", databaseString: "nikeFuel", hkIdentifier: HKQuantityTypeIdentifier.nikeFuel, hkCategoryTypeIdentifier: nil),
            HealthKitMetric.init(humanText: "Water", databaseString: "water", hkIdentifier: HKQuantityTypeIdentifier.dietaryWater, hkCategoryTypeIdentifier: nil),
            HealthKitMetric.init(humanText: "Time in bed", databaseString: "timeInBed", hkIdentifier: nil, hkCategoryTypeIdentifier: HKCategoryTypeIdentifier.sleepAnalysis),
            HealthKitMetric.init(humanText: "Time asleep", databaseString: "timeAsleep", hkIdentifier: nil, hkCategoryTypeIdentifier: HKCategoryTypeIdentifier.sleepAnalysis),
            HealthKitMetric.init(humanText: "Stand hours", databaseString: "standHour", hkIdentifier: nil, hkCategoryTypeIdentifier: HKCategoryTypeIdentifier.appleStandHour),
            HealthKitMetric.init(humanText: "Resting energy", databaseString: "basalEnergy", hkIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned, hkCategoryTypeIdentifier: nil),
            HealthKitMetric.init(humanText: "Dietary energy", databaseString: "dietaryEnergy", hkIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed, hkCategoryTypeIdentifier: nil),
            HealthKitMetric.init(humanText: "Dietary protein", databaseString: "dietaryProtein", hkIdentifier: HKQuantityTypeIdentifier.dietaryProtein, hkCategoryTypeIdentifier: nil)
        ]
        if #available(iOS 10.0, *) {
            mets.append(HealthKitMetric.init(humanText: "Swimming strokes", databaseString: "swimStrokes", hkIdentifier: HKQuantityTypeIdentifier.swimmingStrokeCount, hkCategoryTypeIdentifier: nil))
            mets.append(HealthKitMetric.init(humanText: "Swimming distance", databaseString: "swimDistance", hkIdentifier: HKQuantityTypeIdentifier.distanceSwimming, hkCategoryTypeIdentifier: nil))
            mets.append(HealthKitMetric.init(humanText: "Mindful minutes", databaseString: "mindfulMinutes", hkIdentifier: nil, hkCategoryTypeIdentifier: HKCategoryTypeIdentifier.mindfulSession))
        }
        return mets
    }
}
