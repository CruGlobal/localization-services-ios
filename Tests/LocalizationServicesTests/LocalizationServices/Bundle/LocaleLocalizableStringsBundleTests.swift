//
//  LocaleLocalizableStringsBundleTests.swift
//  LocalizationServices
//
//  Created by Levi Eggert on 9/4/25.
//

import XCTest
@testable import LocalizationServices

class LocaleLocalizableStringsBundleTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMissingLocaleResourceReturnsNilBundle() {
        
        let localeBundle: LocaleLocalizableStringsBundle? = LocaleLocalizableStringsBundle(
            localeIdentifier: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource,
            localeBundleLoader: LocalizableStringsBundleLoader(
                localizableStringsFilesBundle: Bundle.getTestBundle(),
                isUsingBaseInternationalization: false
            )
        )
        
        XCTAssertNil(localeBundle)
    }
    
    func testExistingLocaleResourceReturnsBundle() {
        
        let localeBundle: LocaleLocalizableStringsBundle? = LocaleLocalizableStringsBundle(
            localeIdentifier: "es",
            localeBundleLoader: LocalizableStringsBundleLoader(
                localizableStringsFilesBundle: Bundle.getTestBundle(),
                isUsingBaseInternationalization: false
            )
        )
        
        XCTAssertNotNil(localeBundle)
    }
    
    func testUnsupportedLocaleLoadsBaseLanguageLocale() {
        
        let unsupportedLocale: String = "ru-143"
        
        let localeBundle: LocaleLocalizableStringsBundle? = LocaleLocalizableStringsBundle(
            localeIdentifier: unsupportedLocale,
            localeBundleLoader: LocalizableStringsBundleLoader(
                localizableStringsFilesBundle: Bundle.getTestBundle(),
                isUsingBaseInternationalization: false
            )
        )
        
        XCTAssertNotNil(localeBundle)
        XCTAssertTrue(localeBundle?.table == unsupportedLocale)
        XCTAssertTrue(localeBundle?.stringForKey(key: "back", table: "ru-143") == "Назад")
    }
}
