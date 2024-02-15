//
//  AppModel.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 15/02/2024.
//

import Foundation

class AppModel: ObservableObject {
    @Published var sheet: Sheet?
    @Published var check: Check?
    
    enum Sheet: Identifiable {
        case newCheck
        
        var id: Int { hashValue }
    }
    
    init(
        sheet: Sheet? = nil,
        check: Check? = nil
    ) {
        self.sheet = sheet
        self.check = check
    }
}
