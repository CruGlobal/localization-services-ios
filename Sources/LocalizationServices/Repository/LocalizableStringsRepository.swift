//
//  LocalizableStringsRepository.swift
//  localization-services
//
//  Created by Levi Eggert on 8/9/23.
//  Copyright © 2023 Cru. All rights reserved.
//

import Foundation

public class LocalizableStringsRepository {
    
    private var lastLoadedEnglishLocalizableStringsBundle: LocalizableStringsBundle?
    private var lastLoadedSystemLocalizableStringsBundle: LocaleLocalizableStringsBundle?
    private var lastLoadedLocaleLocalizableStringsBundle: LocaleLocalizableStringsBundle?
    
    public let localizableStringsBundleLoader: LocalizableStringsBundleLoader
    
    public init(localizableStringsBundleLoader: LocalizableStringsBundleLoader) {
        
        self.localizableStringsBundleLoader = localizableStringsBundleLoader
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
                
        if let lastLoadedEnglishLocalizableStringsBundle = self.lastLoadedEnglishLocalizableStringsBundle {
            
            return lastLoadedEnglishLocalizableStringsBundle
        }
        else if let englishBundle = localizableStringsBundleLoader.getEnglishBundle() {
           
            lastLoadedEnglishLocalizableStringsBundle = englishBundle
            
            return englishBundle
        }
        
        return nil
    }
}

// MARK: - System Bundle

extension LocalizableStringsRepository {
    
    public func getSystemLocalizableStringsBundle() -> LocalizableStringsBundle? {
        
        let systemLocaleIdentifier: String = getSystemLocaleIdentifier()
        let systemLocaleChanged: Bool = systemLocaleIdentifier != lastLoadedSystemLocalizableStringsBundle?.localeIdentifier
        let enLocale: String = "en"
        
        if lastLoadedSystemLocalizableStringsBundle == nil || systemLocaleChanged {
            
            if let newSystemLocalizableStrings = LocaleLocalizableStringsBundle(localeIdentifier: systemLocaleIdentifier, localeBundleLoader: localizableStringsBundleLoader) {
                
                lastLoadedSystemLocalizableStringsBundle = newSystemLocalizableStrings
            }
            else if let currentSystemLocalizableStrings = self.lastLoadedSystemLocalizableStringsBundle, currentSystemLocalizableStrings.localeIdentifier != enLocale {
                
                lastLoadedSystemLocalizableStringsBundle = LocaleLocalizableStringsBundle(localeIdentifier: enLocale, localeBundleLoader: localizableStringsBundleLoader)
            }
        }
        
        return lastLoadedSystemLocalizableStringsBundle
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
        
        if let lastLoadedLocaleLocalizableStringsBundle = self.lastLoadedLocaleLocalizableStringsBundle,
           lastLoadedLocaleLocalizableStringsBundle.localeIdentifier.lowercased() == localeIdentifier.lowercased() {
            
            return lastLoadedLocaleLocalizableStringsBundle
        }
        else {
            
            lastLoadedLocaleLocalizableStringsBundle = LocaleLocalizableStringsBundle(
                localeIdentifier: localeIdentifier,
                localeBundleLoader: localizableStringsBundleLoader
            )
                        
            return lastLoadedLocaleLocalizableStringsBundle
        }
    }
}
