//
//  LocalizationServicesTests.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import Foundation
import Testing
@testable import LocalizationServices

struct LocalizationServicesTests {

    private let localizationServices: LocalizationServices = LocalizationServices(
        localizableStringsFilesBundle: Bundle.getTestBundle(),
        isUsingBaseInternationalization: true
    )

    @Test
    func stringInEnglishLocalizableStringsExists() {

        let localizedString: String? = localizationServices.stringForEnglish(
            key: LocalizableStringsKeys.testValueYes.key
        )

        #expect(localizedString == "yes")
    }

    @Test
    func stringInEnglishLocalizableStringsdictExists() {

        let localizedString: String? = localizationServices.stringForEnglish(
            key: LocalizableStringsdictKeys.badgesToolsOpened.key
        )

        #expect(localizedString != nil)
    }

    @Test
    func missingStringInEnglishLocalizableStringsdictReturnsKeyValue() {

        let missingPhraseKey: String = LocalizableStringsBundleTests.missingStringPhraseKey
        let localizedString: String = localizationServices.stringForEnglish(key: missingPhraseKey)

        #expect(localizedString == missingPhraseKey)
    }

    @Test
    func missingStringInLocalizableStringsReturnsKeyValue() {

        let missingLocalizableStringsResource: String = LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource
        let missingPhraseKey: String = LocalizableStringsBundleTests.missingStringPhraseKey

        let missingStringForEnglish: String = localizationServices.stringForEnglish(key: missingPhraseKey)
        let missingStringForSystemElseEnglish: String = localizationServices.stringForSystemElseEnglish(key: missingPhraseKey)
        let missingStringForLocaleElseEnglish: String = localizationServices.stringForLocaleElseEnglish(localeIdentifier: missingLocalizableStringsResource, key: missingPhraseKey)
        let missingStringForLocaleElseSystemElseEnglish: String = localizationServices.stringForLocaleElseSystemElseEnglish(localeIdentifier: missingLocalizableStringsResource, key: missingPhraseKey)

        #expect(missingStringForEnglish == missingPhraseKey)
        #expect(missingStringForSystemElseEnglish == missingPhraseKey)
        #expect(missingStringForLocaleElseEnglish == missingPhraseKey)
        #expect(missingStringForLocaleElseSystemElseEnglish == missingPhraseKey)
    }

    @Test
    func stringForLocaleReturnsNilWhenPhraseDoesNotExist() {

        let existingString: String? = localizationServices.stringForLocale(localeIdentifier: "en", key: "test.value.yes")
        let missingString: String? = localizationServices.stringForLocale(localeIdentifier: "en", key: LocalizableStringsBundleTests.missingStringPhraseKey)

        #expect(existingString == "yes")
        #expect(missingString == nil)
    }
}
