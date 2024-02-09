//
//  CheckDetail.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 09/02/2024.
//

import SwiftUI

struct CheckDetail: View {
    var check: Check
    
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
                    
                    Text(check.saturationOfPeripheralOxygen?.formatted(.percent) ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("FiO₂")
                    
                    Spacer()
                    
                    Text(check.fractionOfInspiredOxygen?.formatted(.number) ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("SpO₂:FiO₂")
                    
                    Spacer()
                    
                    Text(check.saturationToFractionRatio?.formatted(.number) ?? "-")
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
                    
                    Text(check.vasoactiveMedicationCount?.formatted(.number) ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Lactate")
                    
                    Spacer()
                    
                    Text(check.lactate?.formatted(.number).appending(" mmol/L") ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("MAP")
                    
                    Spacer()
                    
                    Text(check.meanArterialPressure?.formatted(.number).appending(" mmHg") ?? "-")
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
                    
                    Text(check.platelets?.formatted(.number).appending(" × 10³/µL") ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("INR")
                    
                    Spacer()
                    
                    Text(check.internationalNormalisedRatio?.formatted(.number) ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("D-dimer")
                    
                    Spacer()
                    
                    Text(check.dDimer?.formatted(.number).appending(" mg/L FEU") ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Fibrinogen")
                    
                    Spacer()
                    
                    Text(check.fibrinogen?.formatted(.number).appending(" mg/dL") ?? "-")
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
                    
                    Text(check.glasgowComaScale?.formatted(.number) ?? "-")
                        .foregroundStyle(.secondary)
                }
                
                if let hasReactivePupils = check.hasReactivePupils {
                    Text(hasReactivePupils ? "Pupils reactive" : "Pupils unreactive")
                } else {
                    Text("No data on pupil reaction")
                        .foregroundStyle(.secondary)
                }
                
                if let hasFixedPupilsBilaterally = check.hasFixedPupilsBilaterally {
                    Text(hasFixedPupilsBilaterally ? "Pupils fixed bilaterally" : "Pupils not fixed bilaterally")
                } else {
                    Text("No data on pupil fixation")
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
    CheckDetail(check: Check(ageBand: Check.AgeBand.oneToElevenMonths, saturationOfPeripheralOxygen: 0.87, fractionOfInspiredOxygen: 0.98, isOnRespiratorySupport: false, isOnInvasiveMechanicalVentilation: true))
}
