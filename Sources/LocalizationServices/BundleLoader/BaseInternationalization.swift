//
//  BaseInternationalization.swift
//  LocalizationServices
//
//  Created by Levi Eggert on 7/23/25.
//

import Foundation

public struct BaseInternationalization: Sendable {
    
    public static let baseBundleFilename: String = "Base"
    
    public let baseLanguage: String
    
    public init(baseLanguage: String) {
        
        self.baseLanguage = baseLanguage
    }
    
    var isEnglish: Bool {
        return LocalizableStringsBundleLoader.possibleEnglishBundleFilenames.contains(baseLanguage)
    }
}
