//
//  LocalizationServices.swift
//  localization-services
//
//  Created by Levi Eggert on 6/18/20.
//  Copyright © 2020 Cru. All rights reserved.
//

import Foundation

public class LocalizationServices: LocalizationServicesInterface {
        
    private let stringsRepositories: [LocalizableStringsFileType: LocalizableStringsRepository]
    
    public let bundleLoader: LocalizableStringsBundleLoader
    
    public init(localizableStringsFilesBundle: Bundle?) {
        
        self.bundleLoader = LocalizableStringsBundleLoader(localizableStringsFilesBundle: localizableStringsFilesBundle)
        
        stringsRepositories = [
            .strings: LocalizableStringsRepository(localizableStringsBundleLoader: bundleLoader, fileType: .strings),
            .stringsdict: LocalizableStringsRepository(localizableStringsBundleLoader: bundleLoader, fileType: .stringsdict)
        ]
    }
    
    public func stringForEnglish(key: String, fileType: LocalizableStringsFileType = .strings) -> String {
        
        return stringsRepositories[fileType]?.stringForEnglish(key: key) ?? key
    }
    
    public func stringForSystemElseEnglish(key: String, fileType: LocalizableStringsFileType = .strings) -> String {
        
        return stringsRepositories[fileType]?.stringForSystemElseEnglish(key: key) ?? key
    }
    
    public func stringForLocaleElseEnglish(localeIdentifier: String?, key: String, fileType: LocalizableStringsFileType = .strings) -> String {

        return stringsRepositories[fileType]?.stringForLocaleElseEnglish(localeIdentifier: localeIdentifier, key: key) ?? key
    }
    
    public func stringForLocaleElseSystemElseEnglish(localeIdentifier: String?, key: String, fileType: LocalizableStringsFileType = .strings) -> String {
        
        return stringsRepositories[fileType]?.stringForLocaleElseSystemElseEnglish(localeIdentifier: localeIdentifier, key: key) ?? key
    }
}
