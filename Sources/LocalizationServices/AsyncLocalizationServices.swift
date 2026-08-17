//
//  AsyncLocalizationServices.swift
//  LocalizationServices
//
//  Created by Levi Eggert on 8/15/26.
//

import Foundation

public actor AsyncLocalizationServices {
    
    private static let englishStringsBundle: String = "en"
    
    private let stringsBundlePool: LocalizableStringsBundlePool
            
    public let config: LocalizationConfig
    public let bundleLoader: LocalizableStringsBundleLoader
    
    public init(config: LocalizationConfig) {
        
        let bundleLoader = LocalizableStringsBundleLoader(
            localizableStringsFilesBundle: config.localizableStringsFilesBundle,
            isUsingBaseInternationalization: config.isUsingBaseInternationalization
        )
        
        self.config = config
        
        self.stringsBundlePool = LocalizableStringsBundlePool(
            localizableStringsBundleLoader: bundleLoader
        )
        
        self.bundleLoader = bundleLoader
    }
    
    public func getStringsBundle(stringLocation: StringLocation) async -> LocalizableStringsBundle? {
        
        switch stringLocation {
            
        case .english:
            return await stringsBundlePool.getStringsBundle(localeIdentifier: Self.englishStringsBundle)
        case .locale(let identifier):
            return await stringsBundlePool.getStringsBundle(localeIdentifier: identifier)
        case .system:
            return await stringsBundlePool.getStringsBundle(localeIdentifier: bundleLoader.systemLocaleIdentifier)
        }
    }
    
    // MARK: - Strings By Location
    
    public func stringsForKeys(
        keys: [String],
        fetchOrder: [StringLocation],
        shouldFallbackToKey: Bool
    ) async -> [String: String] {

        guard !fetchOrder.isEmpty else {
            return Dictionary()
        }

        var stringBundles: [String: LocalizableStringsBundle] = Dictionary()
        var strings: [String: String] = Dictionary()

        for key in keys {

            for index in 0 ..< fetchOrder.count {

                let stringLocation: StringLocation = fetchOrder[index]
                let reachedEnd: Bool = index == fetchOrder.count - 1

                let id: String = stringLocation.id

                if stringBundles[id] == nil {
                    stringBundles[id] = await getStringsBundle(stringLocation: stringLocation)
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
        fetchOrder: [StringLocation],
        shouldFallbackToKey: Bool
    ) async -> String? {

        guard !fetchOrder.isEmpty else {
            return nil
        }

        for stringLocation in fetchOrder {

            let stringsBundle: LocalizableStringsBundle? = await getStringsBundle(stringLocation: stringLocation)

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

    public func stringForEnglish(key: String) async -> String? {

        let stringsBundle = await stringsBundlePool.getStringsBundle(localeIdentifier: Self.englishStringsBundle)

        guard let stringsBundle = stringsBundle else {
            return nil
        }

        return stringsBundle.stringForKey(key: key)
    }

    // MARK: - Locale

    public func stringForLocale(localeIdentifier: String, key: String) async -> String? {

        guard !localeIdentifier.isEmpty else {
            return nil
        }

        let stringsBundle = await stringsBundlePool.getStringsBundle(localeIdentifier: localeIdentifier)

        guard let stringsBundle = stringsBundle else {
            return nil
        }

        return stringsBundle.stringForKey(key: key)
    }

    public func stringForLocaleElseEnglish(localeIdentifier: String, key: String) async -> String? {
        
        if let localeString = await stringForLocale(localeIdentifier: localeIdentifier, key: key) {
            
            return localeString
        }
        else if let englishString = await stringForEnglish(key: key) {
            
            return englishString
        }
        
        return nil
    }

    // MARK: - System

    public func stringForSystem(key: String) async -> String? {

        let stringsBundle = await stringsBundlePool.getStringsBundle(localeIdentifier: bundleLoader.systemLocaleIdentifier)

        guard let stringsBundle = stringsBundle else {
            return nil
        }

        return stringsBundle.stringForKey(key: key)
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

    // MARK: - Key Fallback

    public func stringForEnglishElseKey(key: String) async -> String {

        return await stringForEnglish(key: key) ?? key
    }

    public func stringForLocaleElseKey(localeIdentifier: String, key: String) async -> String {

        return await stringForLocale(localeIdentifier: localeIdentifier, key: key) ?? key
    }

    public func stringForLocaleElseEnglishElseKey(localeIdentifier: String, key: String) async -> String {

        return await stringForLocaleElseEnglish(localeIdentifier: localeIdentifier, key: key) ?? key
    }

    public func stringForSystemElseEnglishElseKey(key: String) async -> String {

        return await stringForSystemElseEnglish(key: key) ?? key
    }
}
