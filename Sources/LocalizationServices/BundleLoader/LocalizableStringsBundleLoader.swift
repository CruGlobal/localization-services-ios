//
//  LocalizableStringsBundleLoader.swift
//  localization-services
//
//  Created by Levi Eggert on 8/1/23.
//  Copyright © 2023 Cru. All rights reserved.
//

import Foundation

public class LocalizableStringsBundleLoader {
    
    // NOTE: Will be Base if Use Base Internationalization is checked in Project > Info > Localizations Section.
    //       English.lproj is deprecated for Localizable.strings. ~Levi
    public static let englishLocalizableStringsFile: String = "Base"
    
    // NOTE: Stringsdict still uses deprecated English.lproj. ~Levi
    public static let englishLocalizableStringsdictFile: String = "Base"
    
    public let localizableStringsFilesBundle: Bundle
    
    public init(localizableStringsFilesBundle: Bundle?) {
        
        self.localizableStringsFilesBundle = localizableStringsFilesBundle ?? Bundle.main
    }
    
    public func getEnglishBundle() -> LocalizableStringsBundle? {
        
        guard let englishBundle = bundleForResource(resourceName: "en") else {
            return nil
        }
        
        return englishBundle
    }
    
    public func bundleForResource(resourceName: String) -> LocalizableStringsBundle? {
                
        guard !resourceName.isEmpty else {
            return nil
        }
        
        let possibleEnglishLocalizableStringsFiles: [String] = ["en", "english", "base"]
        let isEnglishResource: Bool = possibleEnglishLocalizableStringsFiles.contains(resourceName.lowercased())
            
        let bundle: Bundle?
        
        if isEnglishResource {
           
            if let baseBundle = getBundle(bundleFilename: "Base") {
                bundle = baseBundle
            }
            else if let englishBundle = getBundle(bundleFilename: "English") {
                bundle = englishBundle
            }
            else {
                bundle = nil
            }
        }
        else {
            bundle = getBundle(bundleFilename: resourceName)
        }
          
        guard let bundle = bundle else {
            return nil
        }
        
        let localizableStringsBundle = LocalizableStringsBundle(bundle: bundle)
        
        return localizableStringsBundle
    }
    
    private func getBundle(bundleFilename: String) -> Bundle? {
        
        guard let bundlePath = localizableStringsFilesBundle.path(forResource: bundleFilename, ofType: "lproj") else {
            return nil
        }
        
        guard let bundle = Bundle(path: bundlePath) else {
            return nil
        }
        
        return bundle
    }
}
