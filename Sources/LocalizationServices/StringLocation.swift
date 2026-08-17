//
//  StringLocation.swift
//  LocalizationServices
//
//  Created by Levi Eggert on 8/14/26.
//

import Foundation

public enum StringLocation: Sendable {
    
    case english
    case locale(identifier: String)
    case system
    
    var id: String {
        switch self {
        case .english:
            return "english"
        case .locale(let identifier):
            return identifier
        case .system:
            return "system"
        }
    }
}
