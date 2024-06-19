//
//  LocalizationServices.swift
//  localization-services
//
//  Created by Levi Eggert on 6/18/20.
//  Copyright © 2020 Cru. All rights reserved.
//

import Foundation

public class LocalizationServices: LocalizationServicesInterface {
        
    private let stringsRepository: LocalizableStringsRepository
    
    public let bundleLoader: LocalizableStringsBundleLoader
    
    public init(localizableStringsFilesBundle: Bundle?) {
        
        let bundleLoader = LocalizableStringsBundleLoader(localizableStringsFilesBundle: localizableStringsFilesBundle)
        
        self.stringsRepository = LocalizableStringsRepository(localizableStringsBundleLoader: bundleLoader)
        self.bundleLoader = bundleLoader
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
