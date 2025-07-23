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
    
    private let bundleLoaderUsingBaseInternationalization: LocalizableStringsBundleLoader = LocalizableStringsBundleLoader(
        localizableStringsFilesBundle: Bundle.getTestBundle(),
        isUsingBaseInternationalization: true
    )
    
    private let bundleLoaderNotUsingBaseInternationalization: LocalizableStringsBundleLoader = LocalizableStringsBundleLoader(
        localizableStringsFilesBundle: Bundle.getTestBundle(),
        isUsingBaseInternationalization: false
    )
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadingBaseLocalizableStringsExists() {
        
    }
    
    func testLoadingBaseLocalizableStringsExistsWhenUsingBaseInternationalization() {
                                            
        XCTAssertNotNil(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: BaseInternationalization.baseBundleFilename), "Failed to load Base localizable strings.")
    }
    
    func testLoadingBaseLocalizableStringsDictExistsWhenUsingBaseInternationalization() {
                                   
        XCTAssertNotNil(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: BaseInternationalization.baseBundleFilename), "Failed to load Base localizable stringsdict.")
    }
    
    func testLoadingBaseLocalizableStringsDoesNotExistWhenNotUsingBaseInternationalization() {
                                            
        XCTAssertNil(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: BaseInternationalization.baseBundleFilename), "Should not load Base localizable strings.")
    }
    
    func testLoadingBaseLocalizableStringsDictDoesNotExistWhenNotUsingBaseInternationalization() {
                                   
        XCTAssertNil(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: BaseInternationalization.baseBundleFilename), "Should not load Base localizable stringsdict.")
    }
    
    func testLoadingEnglishLocalizableStringsExistsWhenUsingBaseInternationalization() {
                                    
        XCTAssertNotNil(bundleLoaderUsingBaseInternationalization.getEnglishBundle(), "Failed to load English localizable strings.")
        
        XCTAssertNotNil(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.english.id), "Failed to load English localizable strings.")
    }
    
    func testLoadingEnglishLocalizableStringsDictExistsWhenUsingBaseInternationalization() {
                           
        XCTAssertNotNil(bundleLoaderUsingBaseInternationalization.getEnglishBundle(), "Failed to load English localizable stringsdict.")
        
        XCTAssertNotNil(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.english.id), "Failed to load English localizable stringsdict.")
    }
    
    func testLoadingEnglishLocalizableStringsExistsWhenNotUsingBaseInternationalization() {
                                    
        XCTAssertNotNil(bundleLoaderNotUsingBaseInternationalization.getEnglishBundle(), "Failed to load English localizable strings.")
        
        XCTAssertNotNil(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.english.id), "Failed to load English localizable strings.")
    }
    
    func testLoadingEnglishLocalizableStringsDictExistsWhenNotUsingBaseInternationalization() {
                           
        XCTAssertNotNil(bundleLoaderNotUsingBaseInternationalization.getEnglishBundle(), "Failed to load English localizable stringsdict.")
        
        XCTAssertNotNil(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.english.id), "Failed to load English localizable stringsdict.")
    }
    
    func testLoadingSpanishLocalizableStringsExists() {
                                            
        XCTAssertNotNil(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.spanish.id), "Failed to load Spanish localizable strings.")
        
        XCTAssertNotNil(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.spanish.id), "Failed to load Spanish localizable strings.")
    }
    
    func testLoadingSpanishLocalizableStringsDictExists() {
                                   
        XCTAssertNotNil(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.spanish.id), "Failed to load Spanish localizable stringsdict.")
        
        XCTAssertNotNil(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.spanish.id), "Failed to load Spanish localizable stringsdict.")
    }
    
    func testLoadingLocalizableStringsBundleDoesNotExist() {
                
        XCTAssertNil(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource))
        
        XCTAssertNil(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource))
    }
    
    func testLoadingLocalizableStringsdictBundleDoesNotExist() {
        
        XCTAssertNil(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource))
        
        XCTAssertNil(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource))
    }
    
    func testEmptyBundleFilenameShouldReturnNil() {
        
        XCTAssertNil(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: ""))
        
        XCTAssertNil(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: ""))
    }
}
