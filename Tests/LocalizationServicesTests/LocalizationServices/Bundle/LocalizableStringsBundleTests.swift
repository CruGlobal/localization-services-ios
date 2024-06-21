//
//  LocalizableStringsBundleTests.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import XCTest
@testable import LocalizationServices

class LocalizableStringsBundleTests: XCTestCase {
 
    static let missingStringPhraseKey: String = "missing.string.phrase"
    
    private let stringsBundle: LocalizableStringsBundle = LocalizableStringsBundle(bundle: Bundle.getTestBundle())
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEmptyKeyReturnsNil() {
        
        XCTAssertNil(stringsBundle.stringForKey(key: LocalizableStringsBundleTests.missingStringPhraseKey), "")
    }
    
    func testExistingPhraseReturnsAValue() {
        
        XCTAssertEqual(stringsBundle.stringForKey(key: LocalizableStringsKeys.testValueYes.key), "yes", "Value should equal yes.")
    }
    
    func testMissingPhraseReturnsANilValue() {
        
        XCTAssertNil(stringsBundle.stringForKey(key: LocalizableStringsBundleTests.missingStringPhraseKey), "Value returned should be nil.")
    }
}
