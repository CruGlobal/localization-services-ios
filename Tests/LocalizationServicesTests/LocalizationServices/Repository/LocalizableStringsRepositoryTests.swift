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
        localizableStringsBundleLoader: LocalizableStringsBundleLoader(
            localizableStringsFilesBundle: Bundle.getTestBundle(),
            isUsingBaseInternationalization: true
        )
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
    
    func testStringForLocaleElseEnglishReturnsLocale() {
        
        XCTAssertTrue(stringsRepository.stringForLocaleElseEnglish(localeIdentifier: LocaleId.spanish.id, key: "test.value.yes") == "Sí")
    }
    
    func testStringForLocaleElseSystemElseEnglishReturnsLocale() {
        
        XCTAssertTrue(stringsRepository.stringForLocaleElseSystemElseEnglish(localeIdentifier: LocaleId.spanish.id, key: "test.value.yes") == "Sí")
    }
    
    func testStringForLocaleElseSystemElseEnglishReturnsEnglish() {
        
        let localizedString: String? = stringsRepository.stringForLocaleElseSystemElseEnglish(localeIdentifier: LocaleId.spanish.id, key: "test.value.englishOnly")
        
        XCTAssertTrue(localizedString == "English Only")
    }
    
    func testStringForLocaleReturnsNil() {
        
        XCTAssertNil(stringsRepository.stringForLocale(localeIdentifier: nil, key: "test.value.yes"))
        XCTAssertNil(stringsRepository.stringForLocale(localeIdentifier: "", key: "test.value.yes"))
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
    
    func testStringForUnsupportedLocaleIsLoadedAndUsesTableName() {
                
        let localizedString: String? = stringsRepository.stringForLocale(
            localeIdentifier: "ru-143",
            key: "back"
        )
        
        XCTAssertTrue(localizedString == "Назад")
    }
    
    func testStringForUnsupportedLocaleFallsBackToBaseLocaleEs() {
                
        let localizedString: String? = stringsRepository.stringForLocale(
            localeIdentifier: "es-143",
            key: "test.value.yes"
        )
        
        XCTAssertTrue(localizedString == "Sí")
    }
    
    // MARK: - System
    
    func testStringForSystemReturnsSpanishTranslationWhenSystemIsSpanish() {
        
        // Expects System to be in Spanish.  Configured in tests.
                
        XCTAssertTrue(stringsRepository.stringForSystem(key: "test.value.yes") == "Sí")
        XCTAssertTrue(stringsRepository.stringForSystemElseEnglish(key: "test.value.yes") == "Sí")
    }
    
    func testStringForSystemReturnsEnglishTranslationWhenSystemTranslationDoesNotExist() {
        
        // Expects System to be in Spanish.  Configured in tests.
                
        XCTAssertTrue(stringsRepository.stringForSystemElseEnglish(key: "test.value.englishOnly") == "English Only")
    }
}
