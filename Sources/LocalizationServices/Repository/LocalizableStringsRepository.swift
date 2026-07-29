//
//  LocalizableStringsRepository.swift
//  localization-services
//
//  Created by Levi Eggert on 8/9/23.
//  Copyright © 2023 Cru. All rights reserved.
//

import Foundation

@MainActor public final class LocalizableStringsRepository {
    
    private static let englishStringsBundle: String = "en"
    
    private let stringsBundlePool: LocalizableStringsBundlePool
        
    public let localizableStringsBundleLoader: LocalizableStringsBundleLoader
    
    public init(localizableStringsBundleLoader: LocalizableStringsBundleLoader) {
        
        self.localizableStringsBundleLoader = localizableStringsBundleLoader
        self.stringsBundlePool = LocalizableStringsBundlePool(
            localizableStringsBundleLoader: localizableStringsBundleLoader
        )
        
        stringsBundlePool.addStringsBundle(
            localeIdentifier: Self.englishStringsBundle,
            stringsBundle: localizableStringsBundleLoader.getEnglishBundle()
        )
    }
    
    public func stringForEnglish(key: String) -> String? {
        
        return getEnglishLocalizableStringsBundle()?.stringForKey(key: key)
    }
    
    public func stringForSystem(key: String) -> String? {
        
        return getSystemLocalizableStringsBundle()?.stringForKey(key: key)
    }
    
    public func stringForSystemElseEnglish(key: String) -> String? {
        
        if let systemString = stringForSystem(key: key) {
            
            return systemString
        }
        else if let englishString = stringForEnglish(key: key) {
            
            return englishString
        }
        
        return nil
    }
    
    public func stringForLocale(localeIdentifier: String?, key: String) -> String? {
        
        guard let localeIdentifier = localeIdentifier, !localeIdentifier.isEmpty else {
            return nil
        }
        
        return getLocaleStringsBundle(localeIdentifier: localeIdentifier)?.stringForKey(key: key)
    }
    
    public func stringForLocaleElseEnglish(localeIdentifier: String?, key: String) -> String? {
        
        if let localeString = stringForLocale(localeIdentifier: localeIdentifier, key: key) {
            
            return localeString
        }
        else if let englishString = stringForEnglish(key: key) {
            
            return englishString
        }
        
        return nil
    }
    
    public func stringForLocaleElseSystemElseEnglish(localeIdentifier: String?, key: String) -> String? {

        if let localeString = stringForLocale(localeIdentifier: localeIdentifier, key: key) {
            
            return localeString
        }
        else if let systemString = stringForSystem(key: key) {
            
            return systemString
        }
        else if let englishString = stringForEnglish(key: key) {
            
            return englishString
        }
        
        return nil
    }
}

// MARK: - English Bundle

extension LocalizableStringsRepository {
    
    public func getEnglishLocalizableStringsBundle() -> LocalizableStringsBundle? {
        
        return stringsBundlePool.getStringsBundle(localeIdentifier: Self.englishStringsBundle)
    }
}

// MARK: - System Bundle

extension LocalizableStringsRepository {
    
    public func getSystemLocalizableStringsBundle() -> LocalizableStringsBundle? {
        
        let systemLocaleIdentifier: String = getSystemLocaleIdentifier()
        
        return stringsBundlePool.getStringsBundle(localeIdentifier: systemLocaleIdentifier)
    }
    
    private func getSystemLocaleIdentifier() -> String {
        
        let localizationFilesBundle: Bundle = localizableStringsBundleLoader.localizableStringsFilesBundle
        let preferredLocalizations: [String] = Bundle.preferredLocalizations(from: localizationFilesBundle.localizations, forPreferences: Locale.preferredLanguages)
        
        return preferredLocalizations.first ?? Locale.current.identifier
    }
}

// MARK: - Locale Bundle

extension LocalizableStringsRepository {
    
    public func getLocaleStringsBundle(localeIdentifier: String) -> LocalizableStringsBundle? {
                
        guard !localeIdentifier.isEmpty else {
            return nil
        }
        
        return stringsBundlePool.getStringsBundle(localeIdentifier: localeIdentifier)
    }
}
