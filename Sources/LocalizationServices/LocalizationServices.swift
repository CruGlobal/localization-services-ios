//
//  LocalizationServices.swift
//  localization-services
//
//  Created by Levi Eggert on 6/18/20.
//  Copyright © 2020 Cru. All rights reserved.
//

import Foundation

public actor LocalizationServices: Sendable {
    
    private static let englishStringsBundle: String = "en"
    
    private let stringsBundlePool: LocalizableStringsBundlePool
        
    public let bundleLoader: LocalizableStringsBundleLoader
    
    public init(localizableStringsFilesBundle: Bundle?, isUsingBaseInternationalization: Bool) {
        
        let bundleLoader = LocalizableStringsBundleLoader(
            localizableStringsFilesBundle: localizableStringsFilesBundle,
            isUsingBaseInternationalization: isUsingBaseInternationalization
        )
        
        self.stringsBundlePool = LocalizableStringsBundlePool(
            localizableStringsBundleLoader: bundleLoader
        )
        
        self.bundleLoader = bundleLoader
    }
    
    nonisolated private func getLocaleStringsBundle(localeIdentifier: String) -> LocaleLocalizableStringsBundle? {
        
        return LocaleLocalizableStringsBundle(
            localeIdentifier: localeIdentifier,
            localeBundleLoader: bundleLoader
        )
    }
    
    nonisolated public func getStringsBundle(localeIdentifier: String) -> LocalizableStringsBundle? {
        
        return getLocaleStringsBundle(localeIdentifier: localeIdentifier)?.localizableStringsBundle
    }
    
    // MARK: - English
    
    public func stringForEnglishAsync(key: String) async -> String? {
        
        let stringsBundle = await stringsBundlePool.getStringsBundle(localeIdentifier: Self.englishStringsBundle)
        
        guard let stringsBundle = stringsBundle else {
            return nil
        }
        
        return stringsBundle.stringForKey(key: key)
    }
    
    nonisolated public func stringForEnglish(key: String) -> String? {

        let stringsBundle = getStringsBundle(localeIdentifier: Self.englishStringsBundle)

        guard let stringsBundle = stringsBundle else {
            return nil
        }

        return stringsBundle.stringForKey(key: key)
    }
    
    // MARK: - Locale

    public func stringForLocaleAsync(localeIdentifier: String, key: String) async -> String? {

        guard !localeIdentifier.isEmpty else {
            return nil
        }

        let stringsBundle = await stringsBundlePool.getStringsBundle(localeIdentifier: localeIdentifier)

        guard let stringsBundle = stringsBundle else {
            return nil
        }

        return stringsBundle.stringForKey(key: key)
    }

    nonisolated public func stringForLocale(localeIdentifier: String, key: String) -> String? {

        guard !localeIdentifier.isEmpty else {
            return nil
        }

        let stringsBundle = getStringsBundle(localeIdentifier: localeIdentifier)

        guard let stringsBundle = stringsBundle else {
            return nil
        }

        return stringsBundle.stringForKey(key: key)
    }

    public func stringForLocaleElseEnglishAsync(localeIdentifier: String, key: String) async -> String? {

        if let localeString = await stringForLocaleAsync(localeIdentifier: localeIdentifier, key: key) {

            return localeString
        }
        else if let englishString = await stringForEnglishAsync(key: key) {

            return englishString
        }

        return nil
    }

    nonisolated public func stringForLocaleElseEnglish(localeIdentifier: String, key: String) -> String? {

        if let localeString = stringForLocale(localeIdentifier: localeIdentifier, key: key) {

            return localeString
        }
        else if let englishString = stringForEnglish(key: key) {

            return englishString
        }

        return nil
    }

    public func stringForLocaleElseSystemElseEnglishAsync(localeIdentifier: String, key: String) async -> String? {

        if let localeString = await stringForLocaleAsync(localeIdentifier: localeIdentifier, key: key) {

            return localeString
        }
        else if let systemString = await stringForSystemAsync(key: key) {

            return systemString
        }
        else if let englishString = await stringForEnglishAsync(key: key) {

            return englishString
        }

        return nil
    }

    nonisolated public func stringForLocaleElseSystemElseEnglish(localeIdentifier: String, key: String) -> String? {

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

    // MARK: - System
    
    nonisolated private func getSystemLocaleIdentifier() -> String {
        
        let localizationFilesBundle: Bundle = bundleLoader.localizableStringsFilesBundle
        
        let preferredLocalizations: [String] = Bundle.preferredLocalizations(
            from: localizationFilesBundle.localizations,
            forPreferences: Locale.preferredLanguages
        )
        
        return preferredLocalizations.first ?? Locale.current.identifier
    }
    
    public func stringForSystemAsync(key: String) async -> String? {
        
        let stringsBundle = await stringsBundlePool.getStringsBundle(localeIdentifier: getSystemLocaleIdentifier())
        
        guard let stringsBundle = stringsBundle else {
            return nil
        }
        
        return stringsBundle.stringForKey(key: key)
    }
    
    nonisolated public func stringForSystem(key: String) -> String? {
        
        let stringsBundle = getStringsBundle(localeIdentifier: getSystemLocaleIdentifier())

        guard let stringsBundle = stringsBundle else {
            return nil
        }

        return stringsBundle.stringForKey(key: key)
    }
    
    public func stringForSystemElseEnglishAsync(key: String) async -> String? {
        
        if let systemString = await stringForSystemAsync(key: key) {
            
            return systemString
        }
        else if let englishString = await stringForEnglishAsync(key: key) {
            
            return englishString
        }
        
        return nil
    }
    
    nonisolated public func stringForSystemElseEnglish(key: String) -> String? {
        
        if let systemString = stringForSystem(key: key) {
            
            return systemString
        }
        else if let englishString = stringForEnglish(key: key) {
            
            return englishString
        }
        
        return nil
    }
    
    // MARK: - Key Fallback

    public func stringForEnglishElseKeyAsync(key: String) async -> String {

        return await stringForEnglishAsync(key: key) ?? key
    }

    nonisolated public func stringForEnglishElseKey(key: String) -> String {

        return stringForEnglish(key: key) ?? key
    }

    public func stringForLocaleElseKeyAsync(localeIdentifier: String, key: String) async -> String {

        return await stringForLocaleAsync(localeIdentifier: localeIdentifier, key: key) ?? key
    }

    nonisolated public func stringForLocaleElseKey(localeIdentifier: String, key: String) -> String {

        return stringForLocale(localeIdentifier: localeIdentifier, key: key) ?? key
    }

    public func stringForLocaleElseEnglishElseKeyAsync(localeIdentifier: String, key: String) async -> String {

        return await stringForLocaleElseEnglishAsync(localeIdentifier: localeIdentifier, key: key) ?? key
    }

    nonisolated public func stringForLocaleElseEnglishElseKey(localeIdentifier: String, key: String) -> String {

        return stringForLocaleElseEnglish(localeIdentifier: localeIdentifier, key: key) ?? key
    }

    public func stringForLocaleElseSystemElseEnglishElseKeyAsync(localeIdentifier: String, key: String) async -> String {

        return await stringForLocaleElseSystemElseEnglishAsync(localeIdentifier: localeIdentifier, key: key) ?? key
    }

    nonisolated public func stringForLocaleElseSystemElseEnglishElseKey(localeIdentifier: String, key: String) -> String {

        return stringForLocaleElseSystemElseEnglish(localeIdentifier: localeIdentifier, key: key) ?? key
    }

    public func stringForSystemElseEnglishElseKeyAsync(key: String) async -> String {

        return await stringForSystemElseEnglishAsync(key: key) ?? key
    }

    nonisolated public func stringForSystemElseEnglishElseKey(key: String) -> String {

        return stringForSystemElseEnglish(key: key) ?? key
    }
}
