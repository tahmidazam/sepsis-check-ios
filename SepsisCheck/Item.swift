//
//  Item.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 09/02/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
