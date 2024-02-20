//
//  NeurologicalView.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 11/02/2024.
//

import SwiftUI

struct NeurologicalView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var appModel: AppModel
    @Environment(\.modelContext) private var modelContext
    
    @Binding var check: Check
    
    @State var glasgowComaScale: Int = 15
    @State var glasgowComaScaleKnown: Bool = true
    
    @State var pupilState: Check.PupilState = .reactive
    @State var pupilStateKnown: Bool = true
    
    enum Field {
        case glasgowComaScale
    }
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0.0) {
                VStack(alignment: .leading, spacing: 0.0) {
                    VStack(alignment: .leading) {
                        Text("GCS")
                        
                        Text("Glasgow coma scale")
                            .font(.subheadline.smallCaps())
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0.0) {
                        Group {
                            if glasgowComaScaleKnown {
                                TextField("", value: $glasgowComaScale, format: .number.precision(.fractionLength(0)))
                                    .focused($focusedField, equals: .glasgowComaScale)
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
                    .disabled(!glasgowComaScaleKnown)
                    
                    VStack(alignment: .leading) {
                        Stepper("", value: $glasgowComaScale, in: 3...15)
                            .disabled(!glasgowComaScaleKnown)
                            .controlSize(.large)
                            .labelsHidden()
                        
                        Button(glasgowComaScaleKnown ? "I don't have a score" : "Add a score") {
                            glasgowComaScaleKnown.toggle()
                        }
                        .font(.subheadline)
                        .padding(.top)
                    }
                }
                
                VStack(alignment: .leading, spacing: 0.0) {
                    Picker("", selection: $pupilState) {
                        ForEach(Check.PupilState.allCases) { pupilStateCase in
                            Text(pupilStateCase.rawValue)
                                .tag(pupilStateCase)
                        }
                    }
                    .pickerStyle(.segmented)
                    .disabled(!pupilStateKnown)
                    .padding(.top)
                    
                    Button(pupilStateKnown ? "I don't have pupil state" : "Add pupil state") {
                        pupilStateKnown.toggle()
                    }
                    .font(.subheadline)
                    .padding(.top)
                }
            }
            .padding()
            .navigationTitle("Neurological")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                if glasgowComaScaleKnown {
                    check.glasgowComaScale = glasgowComaScale
                }
                
                if pupilStateKnown {
                    check.pupilState = pupilState
                }
                
                modelContext.insert(check)
            }
            .toolbar {
                
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink {
                        CheckDetail(check: $check)
                            .toolbar {
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Done") {
                                        appModel.sheet = nil
                                    }
                                }
                            }
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("Finish")
                    }
                    
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        
                        Button("Done") {
                            focusedField = nil
                            
                            if glasgowComaScale < 3 {
                                glasgowComaScale = 3
                            }
                            
                            if glasgowComaScale > 15 {
                                glasgowComaScale = 15
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
        NeurologicalView(check: .constant(Check()))
    }
}
