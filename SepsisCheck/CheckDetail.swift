//
//  CheckDetail.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 09/02/2024.
//

import SwiftUI

struct CheckDetail: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appModel: AppModel
    @Binding var check: Check
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Timestamp")
                    
                    Spacer()
                    
                    Text(check.timestamp.formatted(.dateTime))
                }
                
                HStack {
                    Text("Age")
                    
                    Spacer()
                    
                    Group {
                        if let ageBand = check.ageBand {
                            Text(ageBand.rawValue)
                        } else {
                            Text("No age data")
                                
                        }
                    }
                    .foregroundStyle(.secondary)
                }
            }
            
            Section {
                HStack {
                    Text("SpO₂")
                    
                    Spacer()
                    
                    Text(check.saturationOfPeripheralOxygen?.formatted(.percent.precision(.fractionLength(0))) ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("FiO₂")
                    
                    Spacer()
                    
                    Text(check.fractionOfInspiredOxygen?.formatted(.number.precision(.fractionLength(2))) ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("SpO₂:FiO₂")
                    
                    Spacer()
                    
                    Text(check.saturationToFractionRatio?.formatted(.number.precision(.fractionLength(2))) ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                if let isOnRespiratorySupport = check.isOnRespiratorySupport {
                    Text(isOnRespiratorySupport ? "On respiratory support" : "Not on respiratory support")
                    
                    if let isOnInvasiveMechanicalVentilation = check.isOnInvasiveMechanicalVentilation {
                        Text(isOnInvasiveMechanicalVentilation ? "On invasive mechanical ventilation" : "Not on invasive mechanical ventilation")
                    }
                } else {
                    Text("No data on respiratory support")
                        .foregroundStyle(.secondary)
                }
            } header: {
                HStack {
                    Text("Respiratory")
                    
                    Spacer()
                    
                    Text(check.respiratoryScore?.formatted() ?? "-")
                }
            }
            
            Section {
                HStack {
                    Text("Number of vasoactive medications")
                    
                    Spacer()
                    
                    Text(check.vasoactiveMedicationCount?.formatted(.number.precision(.fractionLength(0))).appending(" (\(check.vasoactiveMedicineScore?.formatted() ?? "-"))") ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Lactate")
                    
                    Spacer()
                    
                    Text(check.lactate?.formatted(.number.precision(.fractionLength(1))).appending(" mmol/L").appending(" (\(check.lactateScore?.formatted() ?? "-"))") ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("MAP")
                    
                    Spacer()
                    
                    Text(check.meanArterialPressure?.formatted(.number.precision(.fractionLength(0))).appending(" mmHg").appending(" (\(check.meanArterialPressureScore?.formatted() ?? "-"))") ?? "-")
                        .foregroundStyle(.secondary)
                }
            } header: {
                HStack {
                    Text("Cardiovascular")
                    
                    Spacer()
                    
                    Text(check.cardiovascularScore?.formatted() ?? "-")
                }
            }
            
            Section {
                HStack {
                    Text("Platelets")
                    
                    Spacer()
                    
                    Text(check.platelets?.formatted(.number.precision(.fractionLength(0))).appending(" × 10³/µL").appending(" (\(check.plateletScore?.formatted() ?? "-"))") ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("INR")
                    
                    Spacer()
                    
                    Text(check.internationalNormalisedRatio?.formatted(.number.precision(.fractionLength(1))).appending(" (\(check.internationalNormalisedRatioScore?.formatted() ?? "-"))") ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("D-dimer")
                    
                    Spacer()
                    
                    Text(check.dDimer?.formatted(.number.precision(.fractionLength(1))).appending(" mg/L FEU").appending(" (\(check.dDimerScore?.formatted() ?? "-"))") ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Fibrinogen")
                    
                    Spacer()
                    
                    Text(check.fibrinogen?.formatted(.number.precision(.fractionLength(1))).appending(" mg/dL").appending(" (\(check.fibrinogenScore?.formatted() ?? "-"))") ?? "-")
                        .foregroundStyle(.secondary)
                }
            } header: {
                HStack {
                    Text("Coagulation")
                    
                    Spacer()
                    
                    Text(check.coagulationScore?.formatted() ?? "-")
                }
            }
            
            Section {
                HStack {
                    Text("Glasgow coma scale")
                    
                    Spacer()
                    
                    Text(check.glasgowComaScale?.formatted(.number.precision(.fractionLength(0))) ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                if let pupilState = check.pupilState {
                    Text(pupilState == .reactive ? "Pupils reactive" : "Pupils fixed bilaterally")
                } else {
                    Text("No data on pupil reaction")
                        .foregroundStyle(.secondary)
                }
            } header: {
                HStack {
                    Text("Neurological")
                    
                    Spacer()
                    
                    Text(check.neurologicalScore?.formatted() ?? "-")
                }
            }
        }
        .navigationTitle(check.diagnosis.rawValue)
    }
}

#Preview {
    CheckDetail(
        check: .constant(
            Check(
                ageBand: Check.AgeBand.oneToElevenMonths,
                saturationOfPeripheralOxygen: 0.87,
                fractionOfInspiredOxygen: 0.98,
                isOnRespiratorySupport: false,
                isOnInvasiveMechanicalVentilation: true
            )
        )
    )
}
