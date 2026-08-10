//
//  LocalizableStringsRepositoryTests.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import Foundation
import Testing
@testable import LocalizationServices

struct LocalizableStringsRepositoryTests {

    private let stringsRepository: LocalizableStringsRepository = LocalizableStringsRepository(
        localizableStringsBundleLoader: LocalizableStringsBundleLoader(
            localizableStringsFilesBundle: Bundle.getTestBundle(),
            isUsingBaseInternationalization: true
        )
    )

    // MARK: - English

    @Test
    func stringInEnglishLocalizableStringsExists() {

        let localizedString: String? = stringsRepository.stringForEnglish(
            key: LocalizableStringsKeys.testValueYes.key
        )

        #expect(localizedString == "yes")
    }

    @Test
    func stringInEnglishLocalizableStringsdictExists() {

        let localizedString: String? = stringsRepository.stringForEnglish(
            key: LocalizableStringsdictKeys.badgesToolsOpened.key
        )

        #expect(localizedString != nil)
    }

    // MARK: - String For Locale

    @Test
    func stringInSpanishLocalizableStringsExists() {

        let localizedString: String? = stringsRepository.stringForLocale(
            localeIdentifier: LocaleId.spanish.id,
            key: LocalizableStringsKeys.testValueYes.key
        )

        #expect(localizedString == "Sí")
    }

    @Test
    func stringForLocaleElseEnglishReturnsLocale() {

        #expect(stringsRepository.stringForLocaleElseEnglish(localeIdentifier: LocaleId.spanish.id, key: "test.value.yes") == "Sí")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishReturnsLocale() {

        #expect(stringsRepository.stringForLocaleElseSystemElseEnglish(localeIdentifier: LocaleId.spanish.id, key: "test.value.yes") == "Sí")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishReturnsEnglish() {

        let localizedString: String? = stringsRepository.stringForLocaleElseSystemElseEnglish(localeIdentifier: LocaleId.spanish.id, key: "test.value.englishOnly")

        #expect(localizedString == "English Only")
    }

    @Test
    func stringForLocaleReturnsNil() {

        #expect(stringsRepository.stringForLocale(localeIdentifier: nil, key: "test.value.yes") == nil)
        #expect(stringsRepository.stringForLocale(localeIdentifier: "", key: "test.value.yes") == nil)
    }

    @Test
    func stringForLocaleDoesNotExist() {

        let localizedString: String? = stringsRepository.stringForLocale(
            localeIdentifier: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource,
            key: LocalizableStringsKeys.testValueYes.key
        )

        #expect(localizedString == nil)
    }

    @Test
    func stringForLocaleFallsBackToEnglish() {

        let localizedString: String? = stringsRepository.stringForLocaleElseEnglish(
            localeIdentifier: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource,
            key: LocalizableStringsKeys.testValueYes.key
        )

        #expect(localizedString == "yes")
    }

    @Test
    func stringForLocaleFallsBackToSystemElseEnglish() {

        let localizedString: String? = stringsRepository.stringForLocaleElseSystemElseEnglish(
            localeIdentifier: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource,
            key: LocalizableStringsKeys.testValueYes.key
        )

        #expect(localizedString != nil)
    }

    @Test
    func stringForUnsupportedLocaleIsLoadedAndUsesTableName() {

        let localizedString: String? = stringsRepository.stringForLocale(
            localeIdentifier: "ru-143",
            key: "back"
        )

        #expect(localizedString == "Назад")
    }

    @Test
    func stringForUnsupportedLocaleFallsBackToBaseLocaleEs() {

        let localizedString: String? = stringsRepository.stringForLocale(
            localeIdentifier: "es-143",
            key: "test.value.yes"
        )

        #expect(localizedString == "Sí")
    }

    // MARK: - System

    @Test
    func stringForSystemReturnsSpanishTranslationWhenSystemIsSpanish() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(stringsRepository.stringForSystem(key: "test.value.yes") == "Sí")
        #expect(stringsRepository.stringForSystemElseEnglish(key: "test.value.yes") == "Sí")
    }

    @Test
    func stringForSystemReturnsEnglishTranslationWhenSystemTranslationDoesNotExist() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(stringsRepository.stringForSystemElseEnglish(key: "test.value.englishOnly") == "English Only")
    }
}
