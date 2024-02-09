//
//  CheckThumbnail.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 09/02/2024.
//

import SwiftUI

struct CheckThumbnail: View {
    var check: Check
    
    var body: some View {
        HStack {
            Text(check.diagnosis.rawValue)
                .font(.headline)
                .foregroundStyle(check.diagnosis.colour)
            
            
            Spacer()
            
            Text(check.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    CheckThumbnail(check: Check())
}
