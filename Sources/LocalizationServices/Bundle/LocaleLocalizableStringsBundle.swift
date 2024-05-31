//
//  LocaleLocalizableStringsBundle.swift
//  localization-services
//
//  Created by Levi Eggert on 8/1/23.
//  Copyright © 2023 Cru. All rights reserved.
//

import Foundation

public class LocaleLocalizableStringsBundle: LocalizableStringsBundle {
    
    public let localeBundleLoader: LocalizableStringsBundleLoader
    public let locale: Locale
    public let localeIdentifier: String
    
    public init?(localeIdentifier: String, localeBundleLoader: LocalizableStringsBundleLoader, fileType: LocalizableStringsFileType) {
        
        self.localeBundleLoader = localeBundleLoader
        self.locale = Locale(identifier: localeIdentifier)
        self.localeIdentifier = localeIdentifier
                
        if let localeBundle = localeBundleLoader.bundleForResource(resourceName: localeIdentifier, fileType: fileType) {
            super.init(bundle: localeBundle.bundle)
        }
        else {
            return nil
        }
    }
}
