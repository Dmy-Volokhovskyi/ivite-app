//
//  TemplateCategory.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 20/01/2025.
//


enum TemplateCategory: String, CaseIterable, Comparable {
    case adultBirthday = "Adult Birthday"
    case kidsBirthday = "Kid's birthday"
    case wedding = "Wedding"
    case friendsGathering = "Friends Gathering"
    case love = "Love"
    case babyShower = "Baby Shower"
    case seasonal = "Seasonal"
    case business = "Business"
    case graduation = "Graduation"
    case nightLife = "NightLife"
    case petParty = "Pet party"
    
    // Sorting logic (alphabetical by raw value)
    static func < (lhs: TemplateCategory, rhs: TemplateCategory) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}