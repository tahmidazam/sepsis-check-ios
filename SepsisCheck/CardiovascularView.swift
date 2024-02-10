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
    
    @State var saturationOfPeripheralOxygen: Double = 97
    @State var saturationOfPeripheralOxygenKnown: Bool = true
    
    @State var fractionOfInspiredOxygen: Double = 0.21
    @State var fractionOfInspiredOxygenKnown: Bool = true
    
    @State var isOnRespiratorySupport: Bool = false
    @State var isOnInvasiveMechanicalVentilation: Bool = false
    
    enum Field {
        case saturationOfPeripheralOxygen
        case fractionOfInspiredOxygen
    }
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0.0) {
                VStack(alignment: .leading, spacing: 0.0) {
                    VStack(alignment: .leading) {
                        Text("SpO₂")
                        
                        Text("Oxygen saturation")
                            .font(.subheadline.smallCaps())
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                        Group {
                            if saturationOfPeripheralOxygenKnown {
                                TextField("SpO₂", value: $saturationOfPeripheralOxygen, format: .number.precision(.fractionLength(0)))
                                    .focused($focusedField, equals: .saturationOfPeripheralOxygen)
                                    .keyboardType(.numberPad)
                            } else {
                                TextField("", text: .constant("--"))
                                    .disabled(true)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .font(.largeTitle)
                        
                        Text("%")
                            .font(.title2)
                            .foregroundStyle(saturationOfPeripheralOxygenKnown ? .primary : .secondary)
                    }
                    .multilineTextAlignment(.trailing)
                    .fontWidth(.expanded).disabled(!saturationOfPeripheralOxygenKnown)
                    
                    VStack(alignment: .leading) {
                        Slider(
                            value: $saturationOfPeripheralOxygen,
                            in: 0...100
                        )
                        .disabled(!saturationOfPeripheralOxygenKnown)
                        
                        Text("SpO₂:FIO₂ is only calculated if SpO₂ is 97% or less. [(Schlapbach et al., 2024)](https://jamanetwork.com/journals/jama/fullarticle/2814297).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.vertical)
                        
                        Button(saturationOfPeripheralOxygenKnown ? "I don't have SpO₂ values" : "Add SpO₂ value") {
                            saturationOfPeripheralOxygenKnown.toggle()
                        }
                        .font(.subheadline)
                    }
                }
            }
            .padding()
            .navigationTitle("Cardiovascular")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                if saturationOfPeripheralOxygenKnown {
                    check.saturationOfPeripheralOxygen = saturationOfPeripheralOxygen
                }
                
                if fractionOfInspiredOxygenKnown {
                    check.fractionOfInspiredOxygen = fractionOfInspiredOxygen
                }
                
                check.isOnRespiratorySupport = isOnRespiratorySupport
                check.isOnInvasiveMechanicalVentilation = isOnInvasiveMechanicalVentilation
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
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
                            
                            if saturationOfPeripheralOxygen < 0 {
                                saturationOfPeripheralOxygen = 0
                            }
                            
                            if saturationOfPeripheralOxygen > 100 {
                                saturationOfPeripheralOxygen = 100
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
