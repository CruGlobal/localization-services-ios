//
//  LocalizationServices.swift
//  localization-services
//
//  Created by Levi Eggert on 6/18/20.
//  Copyright © 2020 Cru. All rights reserved.
//

import Foundation

public final class LocalizationServices {
        
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
    
    public func stringForLocale(localeIdentifier: String?, key: String) -> String? {
        
        return stringsRepository.stringForLocale(localeIdentifier: localeIdentifier, key: key)
    }
    
    public func stringForEnglish(key: String) -> String {
        
        return stringsRepository.stringForEnglish(key: key) ?? key
    }
    
    public func stringForSystemElseEnglish(key: String) -> String {
        
        return stringsRepository.stringForSystemElseEnglish(key: key) ?? key
    }
    
    public func stringForLocaleElseEnglish(localeIdentifier: String?, key: String) -> String {

        return stringsRepository.stringForLocaleElseEnglish(localeIdentifier: localeIdentifier, key: key) ?? key
    }
    
    public func stringForLocaleElseSystemElseEnglish(localeIdentifier: String?, key: String) -> String {
        
        return stringsRepository.stringForLocaleElseSystemElseEnglish(localeIdentifier: localeIdentifier, key: key) ?? key
    }
}
