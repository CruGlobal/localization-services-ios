//
//  LocalizationServicesTests.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import XCTest
@testable import LocalizationServices

class LocalizationServicesTests: XCTestCase {
 
    private let localizationServices: LocalizationServices = LocalizationServices(
        localizableStringsFilesBundle: Bundle.getTestBundle(),
        isUsingBaseInternationalization: true
    )
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testStringInEnglishLocalizableStringsExists() {
                
        let localizedString: String? = localizationServices.stringForEnglish(
            key: LocalizableStringsKeys.testValueYes.key
        )
        
        XCTAssertNotNil(localizedString)
        XCTAssertEqual(localizedString, "yes")
    }
    
    func testStringInEnglishLocalizableStringsdictExists() {
                
        let localizedString: String? = localizationServices.stringForEnglish(
            key: LocalizableStringsdictKeys.badgesToolsOpened.key
        )
        
        XCTAssertNotNil(localizedString)
    }
    
    func testMissingStringInEnglishLocalizableStringsdictReturnsKeyValue() {
                
        let missingPhraseKey: String = LocalizableStringsBundleTests.missingStringPhraseKey
        let localizedString: String = localizationServices.stringForEnglish(key: missingPhraseKey)
        
        XCTAssertEqual(localizedString, missingPhraseKey)
    }
    
    func testMissingStringInLocalizableStringsReturnsKeyValue() {
        
        let missingLocalizableStringsResource: String = LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource
        let missingPhraseKey: String = LocalizableStringsBundleTests.missingStringPhraseKey
        
        let missingStringForEnglish: String = localizationServices.stringForEnglish(key: missingPhraseKey)
        let missingStringForSystemElseEnglish: String = localizationServices.stringForSystemElseEnglish(key: missingPhraseKey)
        let missingStringForLocaleElseEnglish: String = localizationServices.stringForLocaleElseEnglish(localeIdentifier: missingLocalizableStringsResource, key: missingPhraseKey)
        let missingStringForLocaleElseSystemElseEnglish: String = localizationServices.stringForLocaleElseSystemElseEnglish(localeIdentifier: missingLocalizableStringsResource, key: missingPhraseKey)
        
        XCTAssertEqual(missingStringForEnglish, missingPhraseKey)
        XCTAssertEqual(missingStringForSystemElseEnglish, missingPhraseKey)
        XCTAssertEqual(missingStringForLocaleElseEnglish, missingPhraseKey)
        XCTAssertEqual(missingStringForLocaleElseSystemElseEnglish, missingPhraseKey)
    }
    
    func testStringForLocaleReturnsNilWhenPhraseDoesNotExist() {
        
        let existingString: String? = localizationServices.stringForLocale(localeIdentifier: "en", key: "test.value.yes")
        let missingString: String? = localizationServices.stringForLocale(localeIdentifier: "en", key: LocalizableStringsBundleTests.missingStringPhraseKey)
        
        XCTAssertTrue(existingString == "yes")
        XCTAssertNil(missingString)
    }
}

