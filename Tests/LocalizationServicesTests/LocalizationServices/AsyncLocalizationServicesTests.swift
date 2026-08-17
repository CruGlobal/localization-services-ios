//
//  AsyncLocalizationServicesTests.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import Foundation
import Testing
@testable import LocalizationServices

struct AsyncLocalizationServicesTests {

    private static let missingLocale: String = LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource
    private static let missingKey: String = LocalizableStringsBundleTests.missingStringPhraseKey
    private static let englishOnlyKey: String = "test.value.englishOnly"

    private let localizationServices: AsyncLocalizationServices = AsyncLocalizationServices(
        config: LocalizationConfig(
            localizableStringsFilesBundle: Bundle.getTestBundle(),
            isUsingBaseInternationalization: true
        )
    )

    // MARK: - Strings By Location

    @Test
    func stringsForKeysReturnsEmptyDictionaryWhenFetchOrderIsEmpty() async {

        #expect(await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [], shouldFallbackToKey: false) == [:])
    }

    @Test
    func stringsForKeysReturnsEmptyDictionaryWhenKeysAreEmpty() async {

        #expect(await localizationServices.stringsForKeys(keys: [], fetchOrder: [.english], shouldFallbackToKey: false) == [:])
    }

    @Test
    func stringsForKeysReturnsStringForEveryKey() async {

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.englishOnlyKey], fetchOrder: [.english], shouldFallbackToKey: false)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "yes", Self.englishOnlyKey: "English Only"])
    }

    @Test
    func stringsForKeysReturnsStringFromFirstLocationThatHasIt() async {

        #expect(await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: false) == [LocalizableStringsKeys.testValueYes.key: "Sí"])
        #expect(await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.english, .locale(identifier: LocaleId.spanish.id)], shouldFallbackToKey: false) == [LocalizableStringsKeys.testValueYes.key: "yes"])
    }

    @Test
    func stringsForKeysFallsBackToNextLocationPerKey() async {

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.englishOnlyKey], fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: false)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí", Self.englishOnlyKey: "English Only"])
    }

    @Test
    func stringsForKeysOmitsKeysWithoutStringsWhenNotFallingBackToKey() async {

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey], fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: false)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysReturnsSystemStrings() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.system], shouldFallbackToKey: false) == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysFallsBackToKeyWhenStringDoesNotExist()async {

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey], fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: true)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí", Self.missingKey: Self.missingKey])
    }

    @Test
    func stringsForKeysFallingBackToKeyDoesNotReplaceStringFoundAtEarlierLocation()async {

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.locale(identifier: LocaleId.spanish.id), .locale(identifier: Self.missingLocale)], shouldFallbackToKey: true)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysReturnsEmptyDictionaryWhenFetchOrderIsEmptyAndFallingBackToKey()async {

        #expect(await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [], shouldFallbackToKey: true) == [:])
    }

    // MARK: - String By Location

    @Test
    func stringForKeyReturnsEnglishStringWhenLocationIsEnglish() async {

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.english], shouldFallbackToKey: false) == "yes")
    }

    @Test
    func stringForKeyReturnsLocaleStringWhenLocationIsLocale() async {

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: LocaleId.spanish.id)], shouldFallbackToKey: false) == "Sí")
    }

    @Test
    func stringForKeyReturnsSystemStringWhenLocationIsSystem() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.system], shouldFallbackToKey: false) == "Sí")
    }

    @Test
    func stringForKeyFallsBackToNextLocationWhenLocaleDoesNotExist() async {

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: Self.missingLocale), .english], shouldFallbackToKey: false) == "yes")
    }

    @Test
    func stringForKeyFallsBackToNextLocationWhenLocaleStringDoesNotExist() async {

        #expect(await localizationServices.stringForKey(key: Self.englishOnlyKey, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: false) == "English Only")
    }

    @Test
    func stringForKeyReturnsStringFromFirstLocationThatHasIt() async {

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: false) == "Sí")
        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.english, .locale(identifier: LocaleId.spanish.id)], shouldFallbackToKey: false) == "yes")
    }

    @Test
    func stringForKeyReturnsNilWhenKeyDoesNotExistInAnyLocation() async {

        #expect(await localizationServices.stringForKey(key: Self.missingKey, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .system, .english], shouldFallbackToKey: false) == nil)
    }

    @Test
    func stringForKeyReturnsKeyWhenStringDoesNotExistAndFallingBackToKey()async {

        #expect(await localizationServices.stringForKey(key: Self.missingKey, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: true) == Self.missingKey)
    }

    @Test
    func stringForKeyReturnsStringWhenFoundAndFallingBackToKey()async {

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: LocaleId.spanish.id)], shouldFallbackToKey: true) == "Sí")
    }

    @Test
    func stringForKeyReturnsNilWhenFetchOrderIsEmptyAndFallingBackToKey()async {

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [], shouldFallbackToKey: true) == nil)
    }

    // MARK: - String By Location - Fetch Order

    @Test
    func stringForKeyReturnsNilWhenFetchOrderIsEmpty() async {

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [], shouldFallbackToKey: false) == nil)
    }

    @Test
    func stringForKeyFetchOrderFallsBackToNextLocation() async {

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: Self.missingLocale), .locale(identifier: LocaleId.spanish.id)], shouldFallbackToKey: false) == "Sí")
    }

    // MARK: - English

    @Test
    func stringForEnglishReturnsEnglishString() async {

        #expect(await localizationServices.stringForEnglish(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForEnglishReturnsStringFromLocalizableStringsdict() async {

        #expect(await localizationServices.stringForEnglish(key: LocalizableStringsdictKeys.badgesToolsOpened.key) != nil)
    }

    @Test
    func stringForEnglishReturnsNilWhenKeyDoesNotExist() async {

        #expect(await localizationServices.stringForEnglish(key: Self.missingKey) == nil)
        #expect(await localizationServices.stringForEnglish(key: "") == nil)
    }

    // MARK: - Locale

    @Test
    func stringForLocaleReturnsLocaleString() async {

        #expect(await localizationServices.stringForLocale(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForUnsupportedLocaleIsLoadedAndUsesTableName() async {

        #expect(await localizationServices.stringForLocale(localeIdentifier: LocaleId.russianCentralAsia.id, key: "back") == "Назад")
    }

    @Test
    func stringForUnsupportedLocaleFallsBackToBaseLocaleEs() async {

        #expect(await localizationServices.stringForLocale(localeIdentifier: "es-143", key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleReturnsNilWhenLocaleIdentifierIsEmpty() async {

        #expect(await localizationServices.stringForLocale(localeIdentifier: "", key: LocalizableStringsKeys.testValueYes.key) == nil)
    }

    @Test
    func stringForLocaleReturnsNilWhenLocaleDoesNotExist() async {

        #expect(await localizationServices.stringForLocale(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == nil)
    }

    @Test
    func stringForLocaleReturnsNilWhenKeyDoesNotExist() async {

        #expect(await localizationServices.stringForLocale(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == nil)
    }

    @Test
    func stringForLocaleElseEnglishReturnsLocaleString() async {

        #expect(await localizationServices.stringForLocaleElseEnglish(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseEnglishFallsBackToEnglishWhenLocaleDoesNotExist() async {

        #expect(await localizationServices.stringForLocaleElseEnglish(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForLocaleElseEnglishReturnsNilWhenKeyDoesNotExist() async {

        #expect(await localizationServices.stringForLocaleElseEnglish(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == nil)
    }

    // MARK: - System

    @Test
    func stringForSystemReturnsSpanishStringWhenSystemIsSpanish() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await localizationServices.stringForSystem(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForSystemReturnsNilWhenSystemStringDoesNotExist() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await localizationServices.stringForSystem(key: Self.englishOnlyKey) == nil)
    }

    @Test
    func stringForSystemElseEnglishReturnsSystemString() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await localizationServices.stringForSystemElseEnglish(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForSystemElseEnglishFallsBackToEnglishWhenSystemStringDoesNotExist() async {

        #expect(await localizationServices.stringForSystemElseEnglish(key: Self.englishOnlyKey) == "English Only")
    }

    // MARK: - Key Fallback

    @Test
    func stringForEnglishElseKeyReturnsEnglishString() async {

        #expect(await localizationServices.stringForEnglishElseKey(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForEnglishElseKeyReturnsKeyWhenStringDoesNotExist() async {

        #expect(await localizationServices.stringForEnglishElseKey(key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForLocaleElseKeyReturnsLocaleString() async {

        #expect(await localizationServices.stringForLocaleElseKey(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseKeyReturnsKeyWhenLocaleStringDoesNotExist() async {

        #expect(await localizationServices.stringForLocaleElseKey(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == LocalizableStringsKeys.testValueYes.key)
        #expect(await localizationServices.stringForLocaleElseKey(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForLocaleElseEnglishElseKeyReturnsLocaleString() async {

        #expect(await localizationServices.stringForLocaleElseEnglishElseKey(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseEnglishElseKeyFallsBackToEnglishWhenLocaleDoesNotExist() async {

        #expect(await localizationServices.stringForLocaleElseEnglishElseKey(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForLocaleElseEnglishElseKeyReturnsKeyWhenLocaleAndEnglishStringsDoNotExist() async {

        #expect(await localizationServices.stringForLocaleElseEnglishElseKey(localeIdentifier: Self.missingLocale, key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForSystemElseEnglishElseKeyReturnsSystemString() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await localizationServices.stringForSystemElseEnglishElseKey(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForSystemElseEnglishElseKeyFallsBackToEnglishWhenSystemStringDoesNotExist() async {

        #expect(await localizationServices.stringForSystemElseEnglishElseKey(key: Self.englishOnlyKey) == "English Only")
    }

    @Test
    func stringForSystemElseEnglishElseKeyReturnsKeyWhenNoStringsExist() async {

        #expect(await localizationServices.stringForSystemElseEnglishElseKey(key: Self.missingKey) == Self.missingKey)
    }
}
