//
//  LocalizableStringsRepositoryTests.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import XCTest
@testable import LocalizationServices

class LocalizableStringsRepositoryTests: XCTestCase {
 
    private let stringsRepository: LocalizableStringsRepository = LocalizableStringsRepository(
        localizableStringsBundleLoader: LocalizableStringsBundleLoader(localizableStringsFilesBundle: Bundle.getTestBundle())
    )
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - English
    
    func testStringInEnglishLocalizableStringsExists() {
                
        let localizedString: String? = stringsRepository.stringForEnglish(
            key: LocalizableStringsKeys.testValueYes.key
        )
        
        XCTAssertNotNil(localizedString)
        XCTAssertEqual(localizedString, "yes")
    }
    
    func testStringInEnglishLocalizableStringsdictExists() {
                
        let localizedString: String? = stringsRepository.stringForEnglish(
            key: LocalizableStringsdictKeys.badgesToolsOpened.key
        )
        
        XCTAssertNotNil(localizedString)
    }
    
    // MARK: - String For Locale
    
    func testStringInSpanishLocalizableStringsExists() {
        
        let localizedString: String? = stringsRepository.stringForLocale(
            localeIdentifier: LocaleId.spanish.id,
            key: LocalizableStringsKeys.testValueYes.key
        )
        
        XCTAssertNotNil(localizedString)
        XCTAssertEqual(localizedString, "Sí")
    }
    
    func testStringForLocaleDoesNotExist() {
        
        let localizedString: String? = stringsRepository.stringForLocale(
            localeIdentifier: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource,
            key: LocalizableStringsKeys.testValueYes.key
        )
        
        XCTAssertNil(localizedString)
    }
    
    func testStringForLocaleFallsBackToEnglish() {
        
        let localizedString: String? = stringsRepository.stringForLocaleElseEnglish(
            localeIdentifier: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource,
            key: LocalizableStringsKeys.testValueYes.key
        )
        
        XCTAssertNotNil(localizedString)
        XCTAssertEqual(localizedString, "yes")
    }
    
    func testStringForLocaleFallsBackToSystemElseEnglish() {
        
        let localizedString: String? = stringsRepository.stringForLocaleElseSystemElseEnglish(
            localeIdentifier: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource,
            key: LocalizableStringsKeys.testValueYes.key
        )
        
        XCTAssertNotNil(localizedString)
    }
}
