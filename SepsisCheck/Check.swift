//
//  Check.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 09/02/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Check {
    
    /// The time at which the check was created.
    var timestamp: Date = Date()
    
    /// The date of birth of the individual.
    var dateOfBirth: Date?
    
    /// The age band of the individual.
    var ageBand: AgeBand?
    
    // MARK: Respiratory properties
    
    /// The saturation of peripheral oxygen, as a dimensionless proportion from 0 to 1.
    ///
    /// Usually displayed as a percentage.
    var saturationOfPeripheralOxygen: Double?
    
    /// The fraction of inspired oxygen, a dimensionless proportion from 0 to 1.
    ///
    /// For example, in air, the average fraction of inspired oxygen is 0.209, or 20.9% (to 3 significant figures).
    var fractionOfInspiredOxygen: Double?
    
    /// Whether the individual is on respiratory support, for example, non-invasive positive pressure.
    var isOnRespiratorySupport: Bool?
    
    /// Whether the individual is on invasive mechanical ventilation.
    var isOnInvasiveMechanicalVentilation: Bool?
    
    // MARK: Cardiovascular properties
    
    /// The number of vasoactive medicines currently administered to the individual.
    ///
    /// Vasoactive medications include any dose of epinephrine, norepinephrine, dopamine, dobutamine, milrinone, and/or vasopressin (for shock) (Schlapbach et al., 2024).
    var vasoactiveMedicationCount: Int?
    
    /// The concentration of lactate in the blood in mmol/L. Lactate reference range is 0.5 to 2.2 mmol/L. Lactate can be arterial or venous (Schlapbach et al., 2024).
    var lactate: Double?
    
    /// The mean arterial pressure, in millimetres of mercury, mmHg.
    ///
    /// Age is not adjusted for prematurity, and the criteria do not apply to birth hospitalizations, children whose postconceptional age is younger than 37 weeks, or those 18 years or older.
    ///
    /// Use measured MAP preferentially (invasive arterial if available or noninvasive oscillometric), and if measured MAP is not available, a calculated MAP (1/3 × systolic + 2/3 × diastolic) may be used as an alternative (Schlapbach et al., 2024).
    var meanArterialPressure: Double?
    
    // MARK: Coagulation properties
    
    /// The platelet count, in × 10³ per microlitre, × 10³/µL.
    ///
    /// Reference range of 150 to 450 × 10³/µL (Schlapbach et al., 2024).
    var platelets: Double?
    
    /// The international normalised ratio.
    ///
    /// The INR reference range is based on the local reference prothrombin time (Schlapbach et al., 2024).
    var internationalNormalisedRatio: Double?
    
    /// The d-dimer concentration, measured in milligrams per litre in fibrinogen equivalent units, mg/L FEU.
    ///
    /// Reference range of less than 0.5 mg/L FEU (Schlapbach et al., 2024).
    var dDimer: Double?
    
    /// The fibrinogen concentration, in milligrams per decilitre, mg/dL.
    ///
    /// Reference range of 180 to 410 mg/dL (Schlapbach et al., 2024).
    var fibrinogen: Double?
    
    // MARK: Neurological properties
    
    /// The Glasgow coma scale score.
    ///
    /// The Glasgow Coma Scale score measures level of consciousness based on verbal, eye, and motor response (range, 3-15, with a higher score indicating better neurological function) (Schlapbach et al., 2024).
    var glasgowComaScale: Int?
    
    /// Whether the individual has reactive pupils.
    var hasReactivePupils: Bool?
    
    /// Whether the individual has fixed pupils bilaterally.
    var hasFixedPupilsBilaterally: Bool?
    
    // MARK: Initialiser
    
    init(
        dateOfBirth: Date? = nil,
        ageBand: AgeBand? = nil,
        saturationOfPeripheralOxygen: Double? = nil,
        fractionOfInspiredOxygen: Double? = nil,
        isOnRespiratorySupport: Bool? = nil,
        isOnInvasiveMechanicalVentilation: Bool? = nil,
        vasoactiveMedicationCount: Int? = nil,
        lactate: Double? = nil,
        meanArterialPressure: Double? = nil,
        platelets: Double? = nil,
        internationalNormalisedRatio: Double? = nil,
        dDimer: Double? = nil,
        fibrinogen: Double? = nil,
        glasgowComaScale: Int? = nil,
        hasReactivePupils: Bool? = nil,
        hasFixedPupilsBilaterally: Bool? = nil
    ) {
        self.dateOfBirth = dateOfBirth
        self.ageBand = ageBand
        
        if let dateOfBirth {
            self.ageBand = AgeBand(dateOfBirth: dateOfBirth)
        }
        
        self.saturationOfPeripheralOxygen = saturationOfPeripheralOxygen
        self.fractionOfInspiredOxygen = fractionOfInspiredOxygen
        self.isOnRespiratorySupport = isOnRespiratorySupport
        self.isOnInvasiveMechanicalVentilation = isOnInvasiveMechanicalVentilation
        self.vasoactiveMedicationCount = vasoactiveMedicationCount
        self.lactate = lactate
        self.meanArterialPressure = meanArterialPressure
        self.platelets = platelets
        self.internationalNormalisedRatio = internationalNormalisedRatio
        self.dDimer = dDimer
        self.fibrinogen = fibrinogen
        self.glasgowComaScale = glasgowComaScale
        self.hasReactivePupils = hasReactivePupils
        self.hasFixedPupilsBilaterally = hasFixedPupilsBilaterally
    }
    
    // MARK: Computed properties
    
    /// The saturation of peripheral oxygen to fraction of inspired oxygen ratio, SpO₂:FIO₂.
    ///
    /// SpO₂:FIO₂ is only calculated if SpO₂ is 97% or less (Schlapbach et al., 2024).
    var saturationToFractionRatio: Double? {
        guard
            let saturationOfPeripheralOxygen,
            let fractionOfInspiredOxygen,
            saturationOfPeripheralOxygen <= 0.97 else {
            return nil
        }
        
        return (saturationOfPeripheralOxygen * 100) / fractionOfInspiredOxygen
    }
    
    /// The age of the individual in months.
    var ageInMonths: Int? {
        guard let dateOfBirth else {
            return nil
        }
        
        return Calendar.current.dateComponents([.month], from: dateOfBirth, to: Date()).month
    }
    
    /// The age of the individual in years.
    var ageInYears: Int? {
        guard let dateOfBirth else {
            return nil
        }
        
        return Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year
    }
    
    /// The respiratory component of the Phenoix Sepsis Score. Returns nil if insufficient parameters are provided.
    ///
    /// Logic according to Table 1 of Schlapbach et al., 2024.
    var respiratoryScore: Int? {
        guard
            let isOnInvasiveMechanicalVentilation,
            let isOnRespiratorySupport,
            let saturationToFractionRatio else {
            return nil
        }
        
        if isOnInvasiveMechanicalVentilation {
            if saturationToFractionRatio < 148 { return 3 }
            if saturationToFractionRatio < 220 { return 2 }
        }
        
        if isOnRespiratorySupport {
            if saturationToFractionRatio < 292 { return 1 }
        }
        
        return 0
    }
    
    /// The vasoactive medicine of the Phenoix Sepsis Score. Returns nil if insufficient parameters are provided.
    ///
    /// Logic according to Table 1 of Schlapbach et al., 2024.
    var vasoactiveMedicineScore: Int? {
        guard
            let vasoactiveMedicationCount,
            vasoactiveMedicationCount >= 0 else {
            return nil
        }
        
        return min(vasoactiveMedicationCount, 2)
    }
    
    /// The lactate component of the Phenoix Sepsis Score. Returns nil if insufficient parameters are provided.
    ///
    /// Logic according to Table 1 of Schlapbach et al., 2024.
    var lactateScore: Int? {
        guard let lactate else {
            return nil
        }
        
        if lactate >= 11 {
            return 2
        } else if lactate >= 5 {
            return 1
        }
        
        return 0
    }
    
    /// The mean arterial pressure component of the Phenoix Sepsis Score. Returns nil if insufficient parameters are provided.
    ///
    /// Logic according to Table 1 of Schlapbach et al., 2024.
    var meanArterialPressureScore: Int? {
        guard let meanArterialPressure else {
            return nil
        }
        
        switch ageBand {
        case .lessThanOneMonth:
            switch meanArterialPressure {
            case 17..<30: return 1
            case ..<17: return 2
            default: return 0
            }
        case .oneToElevenMonths:
            switch meanArterialPressure {
            case 25..<39: return 1
            case ..<25: return 2
            default: return 0
            }
        case .oneToTwoYears:
            switch meanArterialPressure {
            case 31..<43: return 1
            case ..<31: return 2
            default: return 0
            }
        case .twoToFiveYears:
            switch meanArterialPressure {
            case 32..<44: return 1
            case ..<32: return 2
            default: return 0
            }
        case .fiveToTwelveYears:
            switch meanArterialPressure {
            case 36..<48: return 1
            case ..<36: return 2
            default: return 0
            }
        case .twelveToSeventeenYears:
            switch meanArterialPressure {
            case 38..<51: return 1
            case ..<38: return 2
            default: return 0
            }
        case nil:
            return nil
        }
    }
    
    /// The cardiovascular component of the Phenoix Sepsis Score, combining vasoactive medicine, lactate, and mean arterial pressure components. Returns nil if insufficient parameters are provided.
    ///
    /// Logic according to Table 1 of Schlapbach et al., 2024.
    var cardiovascularScore: Int? {
        let components: [Int] = [
            vasoactiveMedicineScore,
            lactateScore,
            meanArterialPressureScore
        ].compactMap({ $0 })
        
        guard !components.isEmpty else {
            return nil
        }
        
        return components.reduce(0, +)
    }
    
    /// The platelet component of the Phenoix Sepsis Score. Returns nil if insufficient parameters are provided.
    ///
    /// Logic according to Table 1 of Schlapbach et al., 2024.
    var plateletScore: Int? {
        guard let platelets else {
            return nil
        }
        
        if platelets < 100 {
            return 1
        }
        
        return 0
    }
    
    /// The international normalised ratio component of the Phenoix Sepsis Score. Returns nil if insufficient parameters are provided.
    ///
    /// Logic according to Table 1 of Schlapbach et al., 2024.
    var internationalNormalisedRatioScore: Int? {
        guard let internationalNormalisedRatio else {
            return nil
        }
        
        if internationalNormalisedRatio > 1.3 {
            return 1
        }
        
        return 0
    }
    
    /// The d-dimer component of the Phenoix Sepsis Score. Returns nil if insufficient parameters are provided.
    ///
    /// Logic according to Table 1 of Schlapbach et al., 2024.
    var dDimerScore: Int? {
        guard let dDimer else {
            return nil
        }
        
        if dDimer > 2 {
            return 1
        }
        
        return 0
    }
    
    /// The fibrinogen component of the Phenoix Sepsis Score. Returns nil if insufficient parameters are provided.
    ///
    /// Logic according to Table 1 of Schlapbach et al., 2024.
    var fibrinogenScore: Int? {
        guard let fibrinogen else {
            return nil
        }
        
        if fibrinogen < 100 {
            return 1
        }
        
        return 0
    }
    
    /// The caogulation component of the Phenoix Sepsis Score, combining platelet, international normalised ratio, d-dimer, and fibrinogen components. Returns nil if insufficient parameters are provided.
    ///
    /// Logic according to Table 1 of Schlapbach et al., 2024.
    var coagulationScore: Int? {
        let components: [Int] = [
            plateletScore,
            internationalNormalisedRatioScore,
            dDimerScore,
            fibrinogenScore
        ].compactMap({ $0 })
        
        guard !components.isEmpty else {
            return nil
        }
        
        return components.reduce(0, +)
    }
    
    /// The neurological component of the Phenoix Sepsis Score. Returns nil if insufficient parameters are provided.
    ///
    /// Logic according to Table 1 of Schlapbach et al., 2024.
    var neurologicalScore: Int? {
        if let hasFixedPupilsBilaterally {
            if hasFixedPupilsBilaterally {
                return 2
            }
        }
        
        guard let glasgowComaScale else {
            return nil
        }
        
        if glasgowComaScale >= 10 {
            return 2
        }
        
        if let hasReactivePupils {
            if hasReactivePupils {
                return 0
            }
        }
        
        return nil
    }
    
    /// The Phenoix Sepsis Score, combining respiratory, cardiovascular, coagulation, and neurological components. Returns nil if insufficient parameters are provided.
    ///
    /// Logic according to Table 1 of Schlapbach et al., 2024.
    var pheonixSepsisScore: Int? {
        let components: [Int] = [
            respiratoryScore,
            cardiovascularScore,
            coagulationScore,
            neurologicalScore
        ].compactMap({ $0 })
        
        guard !components.isEmpty else {
            return nil
        }
        
        return components.reduce(0, +)
    }
    
    /// The diagnosis according to the Pheonix Sepsis Score, assuming there is a suspected infection.
    var diagnosis: Diagnosis {
        guard let pheonixSepsisScore else {
            return .noDiagnosis
        }
        
        if pheonixSepsisScore >= 2 {
            guard let cardiovascularScore else {
                return .sepsis
            }
            
            if cardiovascularScore >= 1 {
                return .septicShock
            } else {
                return .sepsis
            }
        } else {
            return .noSepsis
        }
    }
    
    // MARK: Enumerations
    
    /// The diagnosis according to the Pheonix Sepsis Score, assuming there is a suspected infection.
    enum Diagnosis: String {
        /// Insufficient data to make a diagnosis.
        case noDiagnosis = "No diagnosis"
        
        /// No sepsis diagnosis.
        case noSepsis = "No sepsis"
        
        /// A diagnosis of sepsis.
        case sepsis = "Sepsis"
        
        /// A diagnosis of septic shock.
        case septicShock = "Septic shock"
        
        var colour: Color {
            switch self {
            case .noDiagnosis: return .primary
            case .noSepsis: return .green
            case .sepsis: return .red
            case .septicShock: return .red
            }
        }
    }
    
    /// The age band of the individual, split into classes according to Table 1 of Schlapbach et al., 2024.
    enum AgeBand: String, Codable {
        case lessThanOneMonth = "<1 mo"
        case oneToElevenMonths = "1 to <11 mo"
        case oneToTwoYears = "1 to <2 y"
        case twoToFiveYears = "2 to <5 y"
        case fiveToTwelveYears = "5 to <12 y"
        case twelveToSeventeenYears = "12 to 17 y"
        
        /// Initialises the age band from a date of birth.
        /// - Parameter dateOfBirth: The date of birth of the individual.
        init?(dateOfBirth: Date) {
            let ageInMonths = Calendar.current.dateComponents([.month], from: dateOfBirth, to: Date()).month
            
            let ageInYears = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year
            
            guard
                let ageInYears,
                let ageInMonths else {
                return nil
            }
            
            switch ageInMonths {
            case 0:
                self = .lessThanOneMonth
            case 1..<12:
                self = .oneToElevenMonths
            default:
                switch ageInYears {
                case 1:
                    self = .oneToTwoYears
                case 2..<5:
                    self = .oneToTwoYears
                case 5..<12:
                    self = .oneToTwoYears
                case 12..<18:
                    self = .oneToTwoYears
                default:
                    self = .lessThanOneMonth
                }
            }
        }
    }
}

/**
 Bibliography
 
 Schlapbach, L.J., Watson, R.S., Sorce, L.R., Argent, A.C., Menon, K., Hall, M.W., Akech, S., Albers, D.J., Alpern, E.R., Balamuth, F., Bembea, M., Biban, P., Carrol, E.D., Chiotos, K., Chisti, M.J., DeWitt, P.E., Evans, I., Flauzino de Oliveira, C., Horvat, C.M., Inwald, D., Ishimine, P., Jaramillo-Bustamante, J.C., Levin, M., Lodha, R., Martin, B., Nadel, S., Nakagawa, S., Peters, M.J., Randolph, A.G., Ranjit, S., Rebull, M.N., Russell, S., Scott, H.F., de Souza, D.C., Tissieres, P., Weiss, S.L., Wiens, M.O., Wynn, J.L., Kissoon, N., Zimmerman, J.J., Sanchez-Pinto, L.N., Bennett, T.D., Society of Critical Care Medicine Pediatric Sepsis Definition Task Force, 2024. International Consensus Criteria for Pediatric Sepsis and Septic Shock. JAMA. https://doi.org/10.1001/jama.2024.0179
 */
