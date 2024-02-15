//
//  AgeBandView.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 10/02/2024.
//

import SwiftUI

struct AgeBandView: View {
    @Environment(\.dismiss) var dismiss
    @State var check: Check = .init()
    
    @State var ageBand: Check.AgeBand = .lessThanOneMonth
    @State var dateOfBirth: Date = Date()
    
    @State var inputMethod: InputMethod = .bandSelection
    
    enum InputMethod: CaseIterable, Identifiable {
        case bandSelection
        case dateOfBirthEntry
        
        var id: Int { hashValue }
        
        var label: String {
            switch self {
            case .bandSelection:
                "age band"
            case .dateOfBirthEntry:
                "date of birth"
            }
        }
        
        var otherInputMethod: InputMethod {
            switch self {
            case .bandSelection:
                InputMethod.dateOfBirthEntry
            case .dateOfBirthEntry:
                InputMethod.bandSelection
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Group {
                    switch inputMethod {
                    case .bandSelection:
                        Picker("Age band", selection: $ageBand) {
                            ForEach(Check.AgeBand.allCases) { ageBand in
                                Text(ageBand.rawValue)
                                    .tag(ageBand)
                            }
                        }
                        .pickerStyle(.wheel)
                        .transition(.move(edge: .leading))
                    case .dateOfBirthEntry:
                        DatePicker(
                            "Date of birth",
                            selection: $dateOfBirth,
                            in: Calendar.current.date(
                                byAdding: .year,
                                value: -18,
                                to: Date()
                            )!...Date(),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .transition(.move(edge: .trailing))
                        .onChange(of: dateOfBirth) { oldValue, newValue in
                            if let newAgeBand = Check.AgeBand(
                                dateOfBirth: dateOfBirth
                            ) {
                                ageBand = newAgeBand
                            }
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 0.0) {
                    Button {
                        withAnimation {
                            switch inputMethod {
                            case .bandSelection:
                                inputMethod = .dateOfBirthEntry
                            case .dateOfBirthEntry:
                                inputMethod = .bandSelection
                            }
                        }
                    } label: {
                        Text("Record \(inputMethod.otherInputMethod.label) instead")
                    }
                    .font(.subheadline)
                    
                    Text("Age is not adjusted for prematurity, and the criteria do not apply to birth hospitalizations, children whose postconceptional age is younger than 37 weeks, or those 18 years or older [(Schlapbach et al., 2024)](https://jamanetwork.com/journals/jama/fullarticle/2814297).")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.vertical)
                    
                    NavigationLink {
                        RespiratoryView(check: $check)
                    } label: {
                        Text("I don't have this information")
                            .font(.subheadline)
                    }
                }
                .padding()
            }
            .navigationTitle("New Check")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                if inputMethod == .dateOfBirthEntry {
                    check.dateOfBirth = dateOfBirth
                }
                
                check.ageBand = ageBand
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink {
                        RespiratoryView(check: $check)
                    } label: {
                        Text("Next")
                    }
                }
            }
        }
    }
    
    func toggleInputMethod() {
        
    }
}

#Preview {
    NavigationStack {
        AgeBandView(check: Check())
    }
}
