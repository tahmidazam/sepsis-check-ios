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
            
            Text(check.timestamp, format: .dateTime)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
//            if let formattedTimeDelta = RelativeDateTimeFormatter().string(for: check.timestamp) {
//                Text(formattedTimeDelta)
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
//            }
        }
    }
}

#Preview {
    CheckThumbnail(check: Check())
}
