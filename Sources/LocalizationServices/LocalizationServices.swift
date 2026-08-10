//
//  LocalizationServices.swift
//  localization-services
//
//  Created by Levi Eggert on 6/18/20.
//  Copyright © 2020 Cru. All rights reserved.
//

import Foundation

public final class LocalizationServices: Sendable {
        
    public let stringsRepository: LocalizableStringsRepository
    public let bundleLoader: LocalizableStringsBundleLoader
    
    public init(localizableStringsFilesBundle: Bundle?, isUsingBaseInternationalization: Bool) {
        
        let bundleLoader = LocalizableStringsBundleLoader(
            localizableStringsFilesBundle: localizableStringsFilesBundle,
            isUsingBaseInternationalization: isUsingBaseInternationalization
        )
        
        self.stringsRepository = LocalizableStringsRepository(localizableStringsBundleLoader: bundleLoader)
        self.bundleLoader = bundleLoader
    }
    
    public func stringForLocale(localeIdentifier: String?, key: String) async -> String? {
        
        return await stringsRepository.stringForLocale(localeIdentifier: localeIdentifier, key: key)
    }
    
    public func stringForEnglish(key: String) async -> String {
        
        return await stringsRepository.stringForEnglish(key: key) ?? key
    }
    
    public func stringForSystemElseEnglish(key: String) async -> String {
        
        return await stringsRepository.stringForSystemElseEnglish(key: key) ?? key
    }
    
    public func stringForLocaleElseEnglish(localeIdentifier: String?, key: String) async -> String {

        return await stringsRepository.stringForLocaleElseEnglish(localeIdentifier: localeIdentifier, key: key) ?? key
    }
    
    public func stringForLocaleElseSystemElseEnglish(localeIdentifier: String?, key: String) async -> String {
        
        return await stringsRepository.stringForLocaleElseSystemElseEnglish(
            localeIdentifier: localeIdentifier,
            key: key
        ) ?? key
    }
}
