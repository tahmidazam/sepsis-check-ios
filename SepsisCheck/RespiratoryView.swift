//
//  RespiratoryView.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 10/02/2024.
//

import SwiftUI

struct RespiratoryView: View {
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
                                TextField("", value: $saturationOfPeripheralOxygen, format: .number.precision(.fractionLength(0)))
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
                        
                        Text("SpO₂:FIO₂ is only calculated if SpO₂ is 97% or less [(Schlapbach et al., 2024)](https://jamanetwork.com/journals/jama/fullarticle/2814297).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.vertical)
                        
                        Button(saturationOfPeripheralOxygenKnown ? "I don't have SpO₂ values" : "Add SpO₂ value") {
                            saturationOfPeripheralOxygenKnown.toggle()
                        }
                        .font(.subheadline)
                    }
                }
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 0.0) {
                    VStack(alignment: .leading) {
                        Text("FiO₂")
                        
                        Text("Fraction of inspired oxygen")
                            .font(.subheadline.smallCaps())
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                        
                        Group {
                            if fractionOfInspiredOxygenKnown {
                                TextField("", value: $fractionOfInspiredOxygen, format: .number.precision(.fractionLength(2)))
                                    .focused($focusedField, equals: .fractionOfInspiredOxygen)
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
                    .fontWidth(.expanded).disabled(!fractionOfInspiredOxygenKnown)
                    
                    VStack(alignment: .leading) {
                        Slider(
                            value: $fractionOfInspiredOxygen,
                            in: 0...1
                        )
                        .disabled(!fractionOfInspiredOxygenKnown)
                        
                        Button(fractionOfInspiredOxygenKnown ? "I don't have FiO₂ values" : "Add FiO₂ value") {
                            fractionOfInspiredOxygenKnown.toggle()
                        }
                        .font(.subheadline)
                    }
                }
                
                HStack {
                    Text("SpO₂:FIO₂")
                    
                    Spacer()
                    
                    Text(saturationToFractionRatio()?.formatted(.number.precision(.fractionLength(2))) ?? "--")
                        .foregroundStyle(saturationToFractionRatio() == nil ? .secondary : .primary)
                        .contentTransition(.numericText())
                        .animation(.default, value: saturationToFractionRatio())
                    
                    .multilineTextAlignment(.trailing)
                    .fontWidth(.expanded)
                }
                .padding(.vertical)
                
                Divider()
                    .padding(.bottom)
                
                VStack {
                    Toggle(
                        "Is on respiratory support",
                        isOn: $isOnRespiratorySupport
                    )
                    .onChange(of: isOnRespiratorySupport) { oldValue, newValue in
                        if !newValue {
                            isOnInvasiveMechanicalVentilation = false
                        }
                    }
                    
                    Toggle(
                        "Is on invasive mechanical ventilation",
                        isOn: $isOnInvasiveMechanicalVentilation
                    )
                    .disabled(!isOnRespiratorySupport)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Respiratory")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                if saturationOfPeripheralOxygenKnown {
                    check.saturationOfPeripheralOxygen = saturationOfPeripheralOxygen / 100
                }
                
                if fractionOfInspiredOxygenKnown {
                    check.fractionOfInspiredOxygen = fractionOfInspiredOxygen
                }
                
                check.isOnRespiratorySupport = isOnRespiratorySupport
                check.isOnInvasiveMechanicalVentilation = isOnInvasiveMechanicalVentilation
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink {
                        CardiovascularView(check: $check)
                    } label: {
                        Text("Next")
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
    
    func saturationToFractionRatio() -> Double? {
        guard 
            saturationOfPeripheralOxygenKnown,
            fractionOfInspiredOxygenKnown,
            saturationOfPeripheralOxygen <= 97,
            fractionOfInspiredOxygen != 0 else {
            return nil
        }
        
        return saturationOfPeripheralOxygen / fractionOfInspiredOxygen
    }
}

#Preview {
    NavigationStack {
        RespiratoryView(check: .constant(Check()))
    }
}
