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
    func stringInEnglishLocalizableStringsExists() async {

        let localizedString: String? = await stringsRepository.stringForEnglish(
            key: LocalizableStringsKeys.testValueYes.key
        )

        #expect(localizedString == "yes")
    }

    @Test
    func stringInEnglishLocalizableStringsdictExists() async {

        let localizedString: String? = await stringsRepository.stringForEnglish(
            key: LocalizableStringsdictKeys.badgesToolsOpened.key
        )

        #expect(localizedString != nil)
    }

    // MARK: - String For Locale

    @Test
    func stringInSpanishLocalizableStringsExists() async {

        let localizedString: String? = await stringsRepository.stringForLocale(
            localeIdentifier: LocaleId.spanish.id,
            key: LocalizableStringsKeys.testValueYes.key
        )

        #expect(localizedString == "Sí")
    }

    @Test
    func stringForLocaleElseEnglishReturnsLocale() async {

        #expect(await stringsRepository.stringForLocaleElseEnglish(localeIdentifier: LocaleId.spanish.id, key: "test.value.yes") == "Sí")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishReturnsLocale() async {

        #expect(await stringsRepository.stringForLocaleElseSystemElseEnglish(localeIdentifier: LocaleId.spanish.id, key: "test.value.yes") == "Sí")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishReturnsEnglish() async {

        let localizedString: String? = await stringsRepository.stringForLocaleElseSystemElseEnglish(localeIdentifier: LocaleId.spanish.id, key: "test.value.englishOnly")

        #expect(localizedString == "English Only")
    }

    @Test
    func stringForLocaleReturnsNil() async {

        #expect(await stringsRepository.stringForLocale(localeIdentifier: nil, key: "test.value.yes") == nil)
        #expect(await stringsRepository.stringForLocale(localeIdentifier: "", key: "test.value.yes") == nil)
    }

    @Test
    func stringForLocaleDoesNotExist() async {

        let localizedString: String? = await stringsRepository.stringForLocale(
            localeIdentifier: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource,
            key: LocalizableStringsKeys.testValueYes.key
        )

        #expect(localizedString == nil)
    }

    @Test
    func stringForLocaleFallsBackToEnglish() async {

        let localizedString: String? = await stringsRepository.stringForLocaleElseEnglish(
            localeIdentifier: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource,
            key: LocalizableStringsKeys.testValueYes.key
        )

        #expect(localizedString == "yes")
    }

    @Test
    func stringForLocaleFallsBackToSystemElseEnglish() async {

        let localizedString: String? = await stringsRepository.stringForLocaleElseSystemElseEnglish(
            localeIdentifier: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource,
            key: LocalizableStringsKeys.testValueYes.key
        )

        #expect(localizedString != nil)
    }

    @Test
    func stringForUnsupportedLocaleIsLoadedAndUsesTableName() async {

        let localizedString: String? = await stringsRepository.stringForLocale(
            localeIdentifier: "ru-143",
            key: "back"
        )

        #expect(localizedString == "Назад")
    }

    @Test
    func stringForUnsupportedLocaleFallsBackToBaseLocaleEs() async {

        let localizedString: String? = await stringsRepository.stringForLocale(
            localeIdentifier: "es-143",
            key: "test.value.yes"
        )

        #expect(localizedString == "Sí")
    }

    // MARK: - System

    @Test
    func stringForSystemReturnsSpanishTranslationWhenSystemIsSpanish() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await stringsRepository.stringForSystem(key: "test.value.yes") == "Sí")
        #expect(await stringsRepository.stringForSystemElseEnglish(key: "test.value.yes") == "Sí")
    }

    @Test
    func stringForSystemReturnsEnglishTranslationWhenSystemTranslationDoesNotExist() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await stringsRepository.stringForSystemElseEnglish(key: "test.value.englishOnly") == "English Only")
    }
}
