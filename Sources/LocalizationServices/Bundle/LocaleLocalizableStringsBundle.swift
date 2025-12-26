//
//  LocaleLocalizableStringsBundle.swift
//  localization-services
//
//  Created by Levi Eggert on 8/1/23.
//  Copyright © 2023 Cru. All rights reserved.
//

import Foundation

public final class LocaleLocalizableStringsBundle: LocalizableStringsBundle {
    
    public let localeBundleLoader: LocalizableStringsBundleLoader
    public let locale: Locale
    public let localeIdentifier: String
    
    public init?(localeIdentifier: String, localeBundleLoader: LocalizableStringsBundleLoader) {
        
        self.localeBundleLoader = localeBundleLoader
        self.locale = Locale(identifier: localeIdentifier)
        self.localeIdentifier = localeIdentifier
        
        if let localeBundle = localeBundleLoader.bundleForResource(bundleFilename: localeIdentifier) {
            super.init(bundle: localeBundle.bundle)
        }
        else if Self.hasRegionOrScriptCode(locale: locale), let languageCode = Self.getLanguageCode(locale: locale), let languageCodeBundle = localeBundleLoader.bundleForResource(bundleFilename: languageCode) {
            super.init(bundle: languageCodeBundle.bundle, table: localeIdentifier)
        }
        else {
            return nil
        }
    }
    
    private static func getLanguageCode(locale: Locale) -> String? {
        if #available(iOS 16.0, *) {
            return locale.language.languageCode?.identifier
        }
        else {
            return locale.languageCode
        }
    }
    
    private static func getRegionCode(locale: Locale) -> String? {
        if #available(iOS 16.0, *) {
            return locale.language.region?.identifier
        }
        else {
            return locale.regionCode
        }
    }
    
    private static func getScriptCode(locale: Locale) -> String? {
        if #available(iOS 16.0, *) {
            return locale.language.script?.identifier
        }
        else {
            return locale.scriptCode
        }
    }
    
    private static func hasRegionOrScriptCode(locale: Locale) -> Bool {
        return getRegionCode(locale: locale) != nil || getScriptCode(locale: locale) != nil
    }
}
