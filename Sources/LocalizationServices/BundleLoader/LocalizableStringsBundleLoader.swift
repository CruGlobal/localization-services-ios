//
//  LocalizableStringsBundleLoader.swift
//  localization-services
//
//  Created by Levi Eggert on 8/1/23.
//  Copyright © 2023 Cru. All rights reserved.
//

import Foundation

public class LocalizableStringsBundleLoader {
    
    private static let possibleEnglishBundleFilenames: [String] = [
        LocalizableStringsBundleLoader.enBundleFilename,
        LocalizableStringsBundleLoader.englishBundleFilename
    ]
    
    public static let enBundleFilename: String = "en"
    public static let englishBundleFilename: String = "English"
    
    public let localizableStringsFilesBundle: Bundle
    public let baseInternationalization: BaseInternationalization?
    
    public init(localizableStringsFilesBundle: Bundle?, isUsingBaseInternationalization: Bool, baseInternationalizationBaseLanguage: String = "en") {
        
        self.localizableStringsFilesBundle = localizableStringsFilesBundle ?? Bundle.main
        
        if isUsingBaseInternationalization {
            baseInternationalization = BaseInternationalization(baseLanguage: baseInternationalizationBaseLanguage)
        }
        else {
            baseInternationalization = nil
        }
    }
    
    public func getEnglishBundle() -> LocalizableStringsBundle? {
        
        var bundleFilenames: [String] = Self.possibleEnglishBundleFilenames
        
        if let baseInternationalization = self.baseInternationalization, baseInternationalization.isEnglish {
            bundleFilenames.insert(BaseInternationalization.baseBundleFilename, at: 0)
        }
        
        return getBundle(bundleFilenames: bundleFilenames)
    }
    
    public func bundleForResource(bundleFilename: String) -> LocalizableStringsBundle? {
                
        guard !bundleFilename.isEmpty else {
            return nil
        }
        
        let bundleFilenameIsBaseFilename: Bool = bundleFilename.lowercased() == BaseInternationalization.baseBundleFilename.lowercased()
        let bundleFilenameIsEnglish: Bool = Self.possibleEnglishBundleFilenames.map{$0.lowercased()}.contains(bundleFilename.lowercased())
        
        if let baseInternationalization = self.baseInternationalization,
           (bundleFilenameIsBaseFilename || baseInternationalization.baseLanguage == bundleFilename),
           let baseBundle = getBundle(bundleFilename: BaseInternationalization.baseBundleFilename) {
            
            return LocalizableStringsBundle(bundle: baseBundle)
        }
        else if bundleFilenameIsEnglish {
            
            return getBundle(bundleFilenames: Self.possibleEnglishBundleFilenames)
        }
        
        if bundleFilenameIsBaseFilename && baseInternationalization == nil {
            return nil
        }

        guard let bundle = getBundle(bundleFilename: bundleFilename) else {
            return nil
        }
        
        let localizableStringsBundle = LocalizableStringsBundle(bundle: bundle)
        
        return localizableStringsBundle
    }
    
    private func getBundle(bundleFilenames: [String]) -> LocalizableStringsBundle? {
        
        for bundleFilename in bundleFilenames {
            if let bundle = getBundle(bundleFilename: bundleFilename) {
                return LocalizableStringsBundle(bundle: bundle)
            }
        }
        
        return nil
    }
    
    private func getBundle(bundleFilename: String) -> Bundle? {
        
        guard let bundlePath = localizableStringsFilesBundle.path(forResource: bundleFilename, ofType: "lproj") else {
            return nil
        }
        
        return Bundle(path: bundlePath)
    }
}
