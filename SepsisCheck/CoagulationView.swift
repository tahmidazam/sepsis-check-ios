//
//  CoagulationView.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 11/02/2024.
//

import SwiftUI

struct CoagulationView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var check: Check
    
    @State var platelets: Double = 200
    @State var plateletsKnown: Bool = true
    
    @State var internationalNormalisedRatio: Double = 1
    @State var internationalNormalisedRatioKnown: Bool = true
    
    @State var dDimer: Double = 0.4
    @State var dDimerKnown: Bool = true
    
    @State var fibrinogen: Double = 1
    @State var fibrinogenKnown: Bool = true
    
    
    @State var vasoactiveMedicationCount: Int = 0
    @State var vasoactiveMedicationCountKnown: Bool = true
    
    @State var lactate: Double = 0.8
    @State var lactateKnown: Bool = true
    
    @State var meanArterialPressure: Double = 70
    @State var meanArterialPressureKnown: Bool = true
    
    enum Field {
        case platelets
        case internationalNormalisedRatio
        case dDimer
        case fibrinogen
    }
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0.0) {
                VStack(alignment: .leading, spacing: 0.0) {
                    VStack(alignment: .leading) {
                        Text("Platelets")
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                        Group {
                            if plateletsKnown {
                                TextField("", value: $platelets, format: .number.precision(.fractionLength(0)))
                                    .focused($focusedField, equals: .platelets)
                                    .keyboardType(.numberPad)
                            } else {
                                TextField("", text: .constant("--"))
                                    .disabled(true)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .font(.largeTitle)
                        
                        Text(" × 10³/µL")
                            .font(.title2)
                            .foregroundStyle(plateletsKnown ? .primary : .secondary)
                    }
                    .multilineTextAlignment(.trailing)
                    .fontWidth(.expanded)
                    .disabled(!plateletsKnown)
                    
                    VStack(alignment: .leading) {
                        Slider(
                            value: $platelets,
                            in: 50...1000
                        )
                        .disabled(!plateletsKnown)
                        
                        Button(plateletsKnown ? "I don't have a count" : "Add a count") {
                            plateletsKnown.toggle()
                        }
                        .font(.subheadline)
                    }
                }
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 0.0) {
                    VStack(alignment: .leading) {
                        Text("INR")
                        
                        Text("International normalised ratio")
                            .font(.subheadline.smallCaps())
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                        Group {
                            if internationalNormalisedRatioKnown {
                                TextField("", value: $internationalNormalisedRatio, format: .number.precision(.fractionLength(1)))
                                    .focused($focusedField, equals: .internationalNormalisedRatio)
                                    .keyboardType(.numberPad)
                            } else {
                                TextField("", text: .constant("--"))
                                    .disabled(true)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .font(.largeTitle)
                    }
                    .multilineTextAlignment(.trailing)
                    .fontWidth(.expanded)
                    .disabled(!internationalNormalisedRatioKnown)
                    
                    VStack(alignment: .leading) {
                        Slider(
                            value: $internationalNormalisedRatio,
                            in: 0.1...4
                        )
                        .disabled(!internationalNormalisedRatioKnown)
                        
                        Button(internationalNormalisedRatioKnown ? "I don't have INR values" : "Add an INR value") {
                            internationalNormalisedRatioKnown.toggle()
                        }
                        .font(.subheadline)
                    }
                }
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 0.0) {
                    VStack(alignment: .leading) {
                        Text("D-dimer")
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                        Group {
                            if dDimerKnown {
                                TextField("", value: $dDimer, format: .number.precision(.fractionLength(1)))
                                    .focused($focusedField, equals: .dDimer)
                                    .keyboardType(.numberPad)
                            } else {
                                TextField("", text: .constant("--"))
                                    .disabled(true)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .font(.largeTitle)
                        
                        Text("mg/L FEU")
                            .font(.title2)
                            .foregroundStyle(plateletsKnown ? .primary : .secondary)
                    }
                    .multilineTextAlignment(.trailing)
                    .fontWidth(.expanded)
                    .disabled(!dDimerKnown)
                    
                    VStack(alignment: .leading) {
                        Slider(
                            value: $dDimer,
                            in: 0.1...4
                        )
                        .disabled(!dDimerKnown)
                        
                        Text("FEU, fibrinogen equivalent units [(Schlapbach et al., 2024)](https://jamanetwork.com/journals/jama/fullarticle/2814297).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.vertical)
                        
                        Button(dDimerKnown ? "I don't have d-dimer values" : "Add a d-dimer value") {
                            dDimerKnown.toggle()
                        }
                        .font(.subheadline)
                    }
                }
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 0.0) {
                    VStack(alignment: .leading) {
                        Text("Fibrinogen")
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                        Group {
                            if fibrinogenKnown {
                                TextField("", value: $fibrinogen, format: .number.precision(.fractionLength(1)))
                                    .focused($focusedField, equals: .fibrinogen)
                                    .keyboardType(.numberPad)
                            } else {
                                TextField("", text: .constant("--"))
                                    .disabled(true)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .font(.largeTitle)
                        
                        Text("mg/dL")
                            .font(.title2)
                            .foregroundStyle(fibrinogenKnown ? .primary : .secondary)
                    }
                    .multilineTextAlignment(.trailing)
                    .fontWidth(.expanded)
                    .disabled(!fibrinogenKnown)
                    
                    VStack(alignment: .leading) {
                        Slider(
                            value: $fibrinogen,
                            in: 0.1...10
                        )
                        .disabled(!fibrinogenKnown)
                        
                        Button(fibrinogenKnown ? "I don't have fibrinogen values" : "Add a fibrinogen value") {
                            fibrinogenKnown.toggle()
                        }
                        .font(.subheadline)
                    }
                }
            }
            .padding()
            .navigationTitle("Coagulation")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                if plateletsKnown {
                    check.platelets = platelets
                }
                
                if internationalNormalisedRatioKnown {
                    check.internationalNormalisedRatio = internationalNormalisedRatio
                }
                
                if dDimerKnown {
                    check.dDimer = dDimer
                }
                
                if fibrinogenKnown {
                    check.fibrinogen = fibrinogen
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink {
                        CardiovascularView(check: $check)
                    } label: {
                        Label(
                            "Next",
                            systemImage: "heart"
                        )
                        .labelStyle(.titleOnly)
                    }
                    
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        
                        Button("Done") {
                            focusedField = nil
                            
                            if platelets < 50 {
                                platelets = 50
                            }
                            
                            if platelets > 1000 {
                                platelets = 1000
                            }
                            
                            if internationalNormalisedRatio < 0.1 {
                                internationalNormalisedRatio = 0.1
                            }
                            
                            if internationalNormalisedRatio > 4 {
                                internationalNormalisedRatio = 4
                            }
                            
                            if dDimer < 0.1 {
                                dDimer = 0.1
                            }
                            
                            if dDimer > 4 {
                                dDimer = 4
                            }
                            
                            if fibrinogen < 0.1 {
                                fibrinogen = 0.1
                            }
                            
                            if fibrinogen > 10 {
                                fibrinogen = 10
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CoagulationView(check: .constant(Check()))
    }
}
