//
//  LocalizationServices.swift
//  localization-services
//
//  Created by Levi Eggert on 6/18/20.
//  Copyright © 2020 Cru. All rights reserved.
//

import Foundation

public final class LocalizationServices: Sendable {
    
    private static let englishStringsBundle: String = "en"
                
    public let config: LocalizationConfig
    public let bundleLoader: LocalizableStringsBundleLoader
    
    public init(config: LocalizationConfig) {
        
        let bundleLoader = LocalizableStringsBundleLoader(
            localizableStringsFilesBundle: config.localizableStringsFilesBundle,
            isUsingBaseInternationalization: config.isUsingBaseInternationalization
        )
        
        self.config = config
        self.bundleLoader = bundleLoader
    }
    
    private func getLocaleStringsBundle(localeIdentifier: String) -> LocaleLocalizableStringsBundle? {
        
        return LocaleLocalizableStringsBundle(
            localeIdentifier: localeIdentifier,
            localeBundleLoader: bundleLoader
        )
    }
    
    public func getStringsBundle(stringLocation: StringLocation) -> LocalizableStringsBundle? {
        
        switch stringLocation {
            
        case .english:
            return getStringsBundle(localeIdentifier: Self.englishStringsBundle)
        case .locale(let identifier):
            return getStringsBundle(localeIdentifier: identifier)
        case .system:
            return getStringsBundle(localeIdentifier: bundleLoader.systemLocaleIdentifier)
        }
    }
    
    public func getStringsBundle(localeIdentifier: String) -> LocalizableStringsBundle? {
        
        return getLocaleStringsBundle(localeIdentifier: localeIdentifier)?.localizableStringsBundle
    }
    
    // MARK: - Strings By Location

    public func stringsForKeys(
        keys: [String],
        shouldFallbackToKey: Bool? = nil,
        fetchOrder: [StringLocation]? = nil
    ) -> [String: String] {
        
        let stringLocationOrder = fetchOrder ?? config.fetchStringsInOrder
        let shouldFallbackToKey: Bool = shouldFallbackToKey ?? config.shouldFallbackToKeyIfNoString
        
        guard !stringLocationOrder.isEmpty else {
            return Dictionary()
        }
        
        var stringBundles: [String: LocalizableStringsBundle] = Dictionary()
        var strings: [String: String] = Dictionary()
        
        for key in keys {
            
            for index in 0 ..< stringLocationOrder.count {
                
                let stringLocation: StringLocation = stringLocationOrder[index]
                let reachedEnd: Bool = index == stringLocationOrder.count - 1
                
                let id: String = stringLocation.id
                
                if stringBundles[id] == nil {
                    stringBundles[id] = getStringsBundle(stringLocation: stringLocation)
                }
                
                if let string = stringBundles[id]?.stringForKey(key: key) {
                    strings[key] = string
                    break
                }
                else if reachedEnd && shouldFallbackToKey {
                    strings[key] = key
                }
            }
        }
        
        return strings
    }
    
    // MARK: - String By Location

    public func stringForKey(
        key: String,
        shouldFallbackToKey: Bool? = nil,
        fetchOrder: [StringLocation]? = nil
    ) -> String? {
        
        let stringLocationOrder = fetchOrder ?? config.fetchStringsInOrder
        let shouldFallbackToKey: Bool = shouldFallbackToKey ?? config.shouldFallbackToKeyIfNoString
        
        guard !stringLocationOrder.isEmpty else {
            return nil
        }
        
        for stringLocation in stringLocationOrder {
            
            let stringsBundle: LocalizableStringsBundle? = getStringsBundle(stringLocation: stringLocation)
            
            guard let string = stringsBundle?.stringForKey(key: key) else {
                continue
            }
            
            return string
        }
        
        if shouldFallbackToKey {
            return key
        }
        
        return nil
    }
    
    // MARK: - English
    
    public func stringForEnglish(key: String) -> String? {

        let stringsBundle = getStringsBundle(localeIdentifier: Self.englishStringsBundle)

        guard let stringsBundle = stringsBundle else {
            return nil
        }

        return stringsBundle.stringForKey(key: key)
    }
    
    // MARK: - Locale
    
    public func stringForLocale(localeIdentifier: String, key: String) -> String? {

        guard !localeIdentifier.isEmpty else {
            return nil
        }

        let stringsBundle = getStringsBundle(localeIdentifier: localeIdentifier)

        guard let stringsBundle = stringsBundle else {
            return nil
        }

        return stringsBundle.stringForKey(key: key)
    }
    
    public func stringForLocaleElseEnglish(localeIdentifier: String, key: String) -> String? {

        if let localeString = stringForLocale(localeIdentifier: localeIdentifier, key: key) {

            return localeString
        }
        else if let englishString = stringForEnglish(key: key) {

            return englishString
        }

        return nil
    }

    // MARK: - System
    
    public func stringForSystem(key: String) -> String? {
        
        let stringsBundle = getStringsBundle(localeIdentifier: bundleLoader.systemLocaleIdentifier)

        guard let stringsBundle = stringsBundle else {
            return nil
        }

        return stringsBundle.stringForKey(key: key)
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
    
    // MARK: - Key Fallback
    
    public func stringForEnglishElseKey(key: String) -> String {

        return stringForEnglish(key: key) ?? key
    }
    
    public func stringForLocaleElseKey(localeIdentifier: String, key: String) -> String {

        return stringForLocale(localeIdentifier: localeIdentifier, key: key) ?? key
    }
    
    public func stringForLocaleElseEnglishElseKey(localeIdentifier: String, key: String) -> String {

        return stringForLocaleElseEnglish(localeIdentifier: localeIdentifier, key: key) ?? key
    }
    
    public func stringForSystemElseEnglishElseKey(key: String) -> String {

        return stringForSystemElseEnglish(key: key) ?? key
    }
}
