//
//  Config.swift
//  LocalizationServices
//
//  Created by Levi Eggert on 8/15/26.
//

import Foundation

public struct Config: Sendable {
    
    public static let defaultFetchOrder: [StringLocation] = [.english]
    public static let defaultShouldFallbackToKey: Bool = false
    
    let localizableStringsFilesBundle: Bundle?
    let isUsingBaseInternationalization: Bool
    let fetchStringsInOrder: [StringLocation]
    let shouldFallbackToKeyIfNoString: Bool
    
    public init(
        localizableStringsFilesBundle: Bundle?,
        isUsingBaseInternationalization: Bool,
        fetchStringsInOrder: [StringLocation]? = nil,
        shouldFallbackToKeyIfNoString: Bool? = nil
    ) {
        
        self.localizableStringsFilesBundle = localizableStringsFilesBundle
        self.isUsingBaseInternationalization = isUsingBaseInternationalization
        self.fetchStringsInOrder = fetchStringsInOrder ?? Self.defaultFetchOrder
        self.shouldFallbackToKeyIfNoString = shouldFallbackToKeyIfNoString ?? Self.defaultShouldFallbackToKey
    }
}
