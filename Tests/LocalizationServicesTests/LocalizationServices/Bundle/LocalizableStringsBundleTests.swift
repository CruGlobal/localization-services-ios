//
//  LocalizableStringsBundleTests.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import Foundation
import Testing
@testable import LocalizationServices

struct LocalizableStringsBundleTests {

    static let missingStringPhraseKey: String = "missing.string.phrase"

    private let stringsBundle: LocalizableStringsBundle = LocalizableStringsBundle(bundle: Bundle.getTestBundle())

    @Test
    func emptyKeyReturnsNil() {

        #expect(stringsBundle.stringForKey(key: "") == nil)
    }

    @Test
    func existingPhraseReturnsAValue() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(stringsBundle.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func missingPhraseReturnsANilValue() {

        #expect(stringsBundle.stringForKey(key: LocalizableStringsBundleTests.missingStringPhraseKey) == nil)
    }
}
