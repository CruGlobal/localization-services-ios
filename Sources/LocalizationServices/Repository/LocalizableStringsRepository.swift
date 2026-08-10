//
//  LocalizableStringsRepository.swift
//  localization-services
//
//  Created by Levi Eggert on 8/9/23.
//  Copyright © 2023 Cru. All rights reserved.
//

import Foundation

public actor LocalizableStringsRepository {
    
    private static let englishStringsBundle: String = "en"
    
    private let stringsBundlePool: LocalizableStringsBundlePool
        
    public let localizableStringsBundleLoader: LocalizableStringsBundleLoader
    
    public init(localizableStringsBundleLoader: LocalizableStringsBundleLoader) {
        
        self.localizableStringsBundleLoader = localizableStringsBundleLoader
        self.stringsBundlePool = LocalizableStringsBundlePool(
            localizableStringsBundleLoader: localizableStringsBundleLoader
        )
    }
    
    public func stringForEnglish(key: String) async -> String? {
        
        let stringsBundle = await getEnglishLocalizableStringsBundle()
        
        return stringsBundle?.stringForKey(key: key)
    }
    
    public func stringForSystem(key: String) async -> String? {
        
        let stringsBundle = await  getSystemLocalizableStringsBundle()
        
        return stringsBundle?.stringForKey(key: key)
    }
    
    public func stringForSystemElseEnglish(key: String) async -> String? {
        
        if let systemString = await stringForSystem(key: key) {
            
            return systemString
        }
        else if let englishString = await stringForEnglish(key: key) {
            
            return englishString
        }
        
        return nil
    }
    
    public func stringForLocale(localeIdentifier: String?, key: String) async -> String? {
        
        guard let localeIdentifier = localeIdentifier, !localeIdentifier.isEmpty else {
            return nil
        }
        
        let stringsBundle = await  getLocaleStringsBundle(localeIdentifier: localeIdentifier)
        
        return stringsBundle?.stringForKey(key: key)
    }
    
    public func stringForLocaleElseEnglish(localeIdentifier: String?, key: String) async -> String? {
        
        if let localeString = await stringForLocale(localeIdentifier: localeIdentifier, key: key) {
            
            return localeString
        }
        else if let englishString = await stringForEnglish(key: key) {
            
            return englishString
        }
        
        return nil
    }
    
    public func stringForLocaleElseSystemElseEnglish(localeIdentifier: String?, key: String) async -> String? {

        if let localeString = await stringForLocale(localeIdentifier: localeIdentifier, key: key) {
            
            return localeString
        }
        else if let systemString = await stringForSystem(key: key) {
            
            return systemString
        }
        else if let englishString = await stringForEnglish(key: key) {
            
            return englishString
        }
        
        return nil
    }
}

// MARK: - English Bundle

extension LocalizableStringsRepository {
    
    public func getEnglishLocalizableStringsBundle() async -> LocalizableStringsBundle? {
        
        return await stringsBundlePool.getStringsBundle(localeIdentifier: Self.englishStringsBundle)
    }
}

// MARK: - System Bundle

extension LocalizableStringsRepository {
    
    public func getSystemLocalizableStringsBundle() async -> LocalizableStringsBundle? {
        
        let systemLocaleIdentifier: String = getSystemLocaleIdentifier()
        
        return await stringsBundlePool.getStringsBundle(localeIdentifier: systemLocaleIdentifier)
    }
    
    private func getSystemLocaleIdentifier() -> String {
        
        let localizationFilesBundle: Bundle = localizableStringsBundleLoader.localizableStringsFilesBundle
        let preferredLocalizations: [String] = Bundle.preferredLocalizations(from: localizationFilesBundle.localizations, forPreferences: Locale.preferredLanguages)
        
        return preferredLocalizations.first ?? Locale.current.identifier
    }
}

// MARK: - Locale Bundle

extension LocalizableStringsRepository {
    
    public func getLocaleStringsBundle(localeIdentifier: String) async -> LocalizableStringsBundle? {
                
        guard !localeIdentifier.isEmpty else {
            return nil
        }
        
        return await stringsBundlePool.getStringsBundle(localeIdentifier: localeIdentifier)
    }
}
