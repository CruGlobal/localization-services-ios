//
//  LocalizableStringsBundleLoader.swift
//  localization-services
//
//  Created by Levi Eggert on 8/1/23.
//  Copyright © 2023 Cru. All rights reserved.
//

import Foundation

public class LocalizableStringsBundleLoader {
    
    public let localizableStringsFilesBundle: Bundle
    
    public init(localizableStringsFilesBundle: Bundle?) {
        
        self.localizableStringsFilesBundle = localizableStringsFilesBundle ?? Bundle.main
    }
    
    public func getEnglishBundle() -> LocalizableStringsBundle? {
        return bundleForResource(resourceName: "en")
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
            else if let enBundle = getBundle(bundleFilename: "en") {
                bundle = enBundle
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
        
        return Bundle(path: bundlePath)
    }
}
