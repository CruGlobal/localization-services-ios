//
//  LocalizableStringsBundleLoaderTests.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import XCTest
@testable import LocalizationServices

class LocalizableStringsBundleLoaderTests: XCTestCase {
    
    static let missingLocalizableStringsResource: String = "ru"
    
    private let bundleLoader: LocalizableStringsBundleLoader = LocalizableStringsBundleLoader(localizableStringsFilesBundle: Bundle.getTestBundle())
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadingEnglishLocalizableStringsExists() {
                            
        let stringsFileType: LocalizableStringsFileType = .strings
        
        XCTAssertNotNil(bundleLoader.getEnglishBundle(fileType: stringsFileType), "Failed to load English localizable strings.")
        
        XCTAssertNotNil(bundleLoader.bundleForResource(resourceName: LocaleId.english.id, fileType: stringsFileType), "Failed to load English localizable strings.")
    }
    
    func testLoadingEnglishLocalizableStringsDictExists() {
                   
        let stringsdictFileType: LocalizableStringsFileType = .stringsdict
        
        XCTAssertNotNil(bundleLoader.getEnglishBundle(fileType: stringsdictFileType), "Failed to load English localizable stringsdict.")
        
        XCTAssertNotNil(bundleLoader.bundleForResource(resourceName: LocaleId.english.id, fileType: stringsdictFileType), "Failed to load English localizable stringsdict.")
    }
    
    func testLoadingSpanishLocalizableStringsExists() {
                            
        let stringsFileType: LocalizableStringsFileType = .strings
                
        XCTAssertNotNil(bundleLoader.bundleForResource(resourceName: LocaleId.spanish.id, fileType: stringsFileType), "Failed to load Spanish localizable strings.")
    }
    
    func testLoadingSpanishLocalizableStringsDictExists() {
                   
        let stringsdictFileType: LocalizableStringsFileType = .stringsdict
                
        XCTAssertNotNil(bundleLoader.bundleForResource(resourceName: LocaleId.spanish.id, fileType: stringsdictFileType), "Failed to load Spanish localizable stringsdict.")
    }
    
    func testLoadingLocalizableStringsBundleDoesNotExist() {
                
        XCTAssertNil(bundleLoader.bundleForResource(resourceName: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource, fileType: .strings))
    }
    
    func testLoadingLocalizableStringsdictBundleDoesNotExist() {
        
        XCTAssertNil(bundleLoader.bundleForResource(resourceName: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource, fileType: .stringsdict))
    }
}
