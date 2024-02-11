//
//  CardiovascularView.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 10/02/2024.
//

import SwiftUI

struct CardiovascularView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var check: Check
    
    @State var vasoactiveMedicationCount: Int = 0
    @State var vasoactiveMedicationCountKnown: Bool = true
    
    @State var lactate: Double = 0.8
    @State var lactateKnown: Bool = true
    
    @State var meanArterialPressure: Double = 70
    @State var meanArterialPressureKnown: Bool = true
    
    enum Field {
        case vasoactiveMedicationCount
        case lactate
        case meanArterialPressure
    }
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0.0) {
                VStack(alignment: .leading, spacing: 0.0) {
                    VStack(alignment: .leading) {
                        Text("Vasoactive medication count")
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                        Group {
                            if vasoactiveMedicationCountKnown {
                                TextField("", value: $vasoactiveMedicationCount, format: .number.precision(.fractionLength(0)))
                                    .focused($focusedField, equals: .vasoactiveMedicationCount)
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
                    .disabled(!vasoactiveMedicationCountKnown)
                    
                    VStack(alignment: .leading) {
                        Stepper("", value: $vasoactiveMedicationCount, in: 0...10)
                            .disabled(!vasoactiveMedicationCountKnown)
                            .controlSize(.large)
                            .labelsHidden()
                        
                        Text("Vasoactive medications include any dose of epinephrine, norepinephrine, dopamine, dobutamine, milrinone, and/or vasopressin (for shock) [(Schlapbach et al., 2024)](https://jamanetwork.com/journals/jama/fullarticle/2814297).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.vertical)
                        
                        Button(vasoactiveMedicationCountKnown ? "I don't have a count" : "Add a count") {
                            vasoactiveMedicationCountKnown.toggle()
                        }
                        .font(.subheadline)
                    }
                }
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 0.0) {
                    VStack(alignment: .leading) {
                        Text("Lactate")
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                        Group {
                            if lactateKnown {
                                TextField("", value: $lactate, format: .number.precision(.fractionLength(1)))
                                    .focused($focusedField, equals: .lactate)
                                    .keyboardType(.numberPad)
                            } else {
                                TextField("", text: .constant("--"))
                                    .disabled(true)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .font(.largeTitle)
                        
                        Text("mmol/L")
                            .font(.title2)
                            .foregroundStyle(lactateKnown ? .primary : .secondary)
                    }
                    .multilineTextAlignment(.trailing)
                    .fontWidth(.expanded)
                    .disabled(!lactateKnown)
                    
                    VStack(alignment: .leading) {
                        Slider(
                            value: $lactate,
                            in: 0.5...20
                        )
                        .disabled(!lactateKnown)
                        
                        Text("Lactate can be arterial or venous [(Schlapbach et al., 2024)](https://jamanetwork.com/journals/jama/fullarticle/2814297).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.vertical)
                        
                        Button(lactateKnown ? "I don't have lactate values" : "Add lactate value") {
                            lactateKnown.toggle()
                        }
                        .font(.subheadline)
                    }
                }
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 0.0) {
                    VStack(alignment: .leading) {
                        Text("MAP")
                        Text("Mean arterial pressure")
                            .font(.subheadline.smallCaps())
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                        Group {
                            if meanArterialPressureKnown {
                                TextField("", value: $meanArterialPressure, format: .number.precision(.fractionLength(0)))
                                    .focused($focusedField, equals: .meanArterialPressure)
                                    .keyboardType(.numberPad)
                            } else {
                                TextField("", text: .constant("--"))
                                    .disabled(true)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .font(.largeTitle)
                        
                        Text("mmHg")
                            .font(.title2)
                            .foregroundStyle(meanArterialPressureKnown ? .primary : .secondary)
                    }
                    .multilineTextAlignment(.trailing)
                    .fontWidth(.expanded)
                    .disabled(!meanArterialPressureKnown)
                    
                    VStack(alignment: .leading) {
                        Slider(
                            value: $meanArterialPressure,
                            in: 20...250
                        )
                        .disabled(!meanArterialPressureKnown)
                        
                        Text("Use measured MAP preferentially (invasive arterial if available or noninvasive oscillometric), and if measured MAP is not available, a calculated MAP (1/3 × systolic + 2/3 × diastolic) may be used as an alternative. [(Schlapbach et al., 2024)](https://jamanetwork.com/journals/jama/fullarticle/2814297).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.vertical)
                        
                        Button(meanArterialPressureKnown ? "I don't have MAP values" : "Add MAP value") {
                            meanArterialPressureKnown.toggle()
                        }
                        .font(.subheadline)
                    }
                }
            }
            .padding()
            .navigationTitle("Cardiovascular")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                if vasoactiveMedicationCountKnown {
                    check.vasoactiveMedicationCount = vasoactiveMedicationCount
                }
                
                if lactateKnown {
                    check.lactate = lactate
                }
                
                if meanArterialPressureKnown {
                    check.meanArterialPressure = meanArterialPressure
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink {
                        CoagulationView(check: $check)
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
                            
                            if lactate < 0 {
                                lactate = 0
                            }
                            
                            if lactate > 20 {
                                lactate = 20
                            }
                            
                            if vasoactiveMedicationCount < 0 {
                                vasoactiveMedicationCount = 0
                            }
                            
                            if vasoactiveMedicationCount > 20 {
                                vasoactiveMedicationCount = 20
                            }
                            
                            if meanArterialPressure < 0 {
                                meanArterialPressure = 0
                            }
                            
                            if meanArterialPressure > 250 {
                                meanArterialPressure = 250
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
        CardiovascularView(check: .constant(Check()))
    }
}
