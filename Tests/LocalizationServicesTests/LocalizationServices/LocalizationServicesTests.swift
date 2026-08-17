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

    private static let missingLocale: String = LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource
    private static let missingKey: String = LocalizableStringsBundleTests.missingStringPhraseKey
    private static let englishOnlyKey: String = "test.value.englishOnly"

    private let localizationServices: LocalizationServices = LocalizationServices(
        config: LocalizationConfig(
            localizableStringsFilesBundle: Bundle.getTestBundle(),
            isUsingBaseInternationalization: true
        )
    )

    // MARK: - Strings By Location

    @Test
    func stringsForKeysReturnsEmptyDictionaryWhenFetchOrderIsEmpty() {

        #expect(localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [], shouldFallbackToKey: false) == [:])
    }

    @Test
    func stringsForKeysReturnsEmptyDictionaryWhenKeysAreEmpty() {

        #expect(localizationServices.stringsForKeys(keys: [], fetchOrder: [.english], shouldFallbackToKey: false) == [:])
    }

    @Test
    func stringsForKeysReturnsStringForEveryKey() {

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.englishOnlyKey], fetchOrder: [.english], shouldFallbackToKey: false)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "yes", Self.englishOnlyKey: "English Only"])
    }

    @Test
    func stringsForKeysReturnsStringFromFirstLocationThatHasIt() {

        #expect(localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: false) == [LocalizableStringsKeys.testValueYes.key: "Sí"])
        #expect(localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.english, .locale(identifier: LocaleId.spanish.id)], shouldFallbackToKey: false) == [LocalizableStringsKeys.testValueYes.key: "yes"])
    }

    @Test
    func stringsForKeysFallsBackToNextLocationPerKey() {

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.englishOnlyKey], fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: false)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí", Self.englishOnlyKey: "English Only"])
    }

    @Test
    func stringsForKeysOmitsKeysWithoutStringsWhenNotFallingBackToKey() {

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey], fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: false)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysReturnsSystemStrings() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.system], shouldFallbackToKey: false) == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysFallsBackToKeyWhenStringDoesNotExist() {

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey], fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: true)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí", Self.missingKey: Self.missingKey])
    }

    @Test
    func stringsForKeysFallingBackToKeyDoesNotReplaceStringFoundAtEarlierLocation() {

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.locale(identifier: LocaleId.spanish.id), .locale(identifier: Self.missingLocale)], shouldFallbackToKey: true)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysReturnsEmptyDictionaryWhenFetchOrderIsEmptyAndFallingBackToKey() {

        #expect(localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [], shouldFallbackToKey: true) == [:])
    }

    // MARK: - String By Location

    @Test
    func stringForKeyReturnsEnglishStringWhenLocationIsEnglish() {

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.english], shouldFallbackToKey: false) == "yes")
    }

    @Test
    func stringForKeyReturnsLocaleStringWhenLocationIsLocale() {

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: LocaleId.spanish.id)], shouldFallbackToKey: false) == "Sí")
    }

    @Test
    func stringForKeyReturnsSystemStringWhenLocationIsSystem() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.system], shouldFallbackToKey: false) == "Sí")
    }

    @Test
    func stringForKeyFallsBackToNextLocationWhenLocaleDoesNotExist() {

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: Self.missingLocale), .english], shouldFallbackToKey: false) == "yes")
    }

    @Test
    func stringForKeyFallsBackToNextLocationWhenLocaleStringDoesNotExist() {

        #expect(localizationServices.stringForKey(key: Self.englishOnlyKey, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: false) == "English Only")
    }

    @Test
    func stringForKeyReturnsStringFromFirstLocationThatHasIt() {

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: false) == "Sí")
        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.english, .locale(identifier: LocaleId.spanish.id)], shouldFallbackToKey: false) == "yes")
    }

    @Test
    func stringForKeyReturnsNilWhenKeyDoesNotExistInAnyLocation() {

        #expect(localizationServices.stringForKey(key: Self.missingKey, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .system, .english], shouldFallbackToKey: false) == nil)
    }

    @Test
    func stringForKeyReturnsKeyWhenStringDoesNotExistAndFallingBackToKey() {

        #expect(localizationServices.stringForKey(key: Self.missingKey, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKey: true) == Self.missingKey)
    }

    @Test
    func stringForKeyReturnsStringWhenFoundAndFallingBackToKey() {

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: LocaleId.spanish.id)], shouldFallbackToKey: true) == "Sí")
    }

    @Test
    func stringForKeyReturnsNilWhenFetchOrderIsEmptyAndFallingBackToKey() {

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [], shouldFallbackToKey: true) == nil)
    }

    // MARK: - String By Location - Fetch Order

    @Test
    func stringForKeyReturnsNilWhenFetchOrderIsEmpty() {

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [], shouldFallbackToKey: false) == nil)
    }

    @Test
    func stringForKeyFetchOrderFallsBackToNextLocation() {

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: Self.missingLocale), .locale(identifier: LocaleId.spanish.id)], shouldFallbackToKey: false) == "Sí")
    }

    // MARK: - English

    @Test
    func stringForEnglishReturnsEnglishString() {

        #expect(localizationServices.stringForEnglish(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForEnglishReturnsStringFromLocalizableStringsdict() {

        #expect(localizationServices.stringForEnglish(key: LocalizableStringsdictKeys.badgesToolsOpened.key) != nil)
    }

    @Test
    func stringForEnglishReturnsNilWhenKeyDoesNotExist() {

        #expect(localizationServices.stringForEnglish(key: Self.missingKey) == nil)
        #expect(localizationServices.stringForEnglish(key: "") == nil)
    }

    // MARK: - Locale

    @Test
    func stringForLocaleReturnsLocaleString() {

        #expect(localizationServices.stringForLocale(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleReturnsNilWhenLocaleIdentifierIsEmpty() {

        #expect(localizationServices.stringForLocale(localeIdentifier: "", key: LocalizableStringsKeys.testValueYes.key) == nil)
    }

    @Test
    func stringForLocaleReturnsNilWhenLocaleDoesNotExist() {

        #expect(localizationServices.stringForLocale(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == nil)
    }

    @Test
    func stringForLocaleReturnsNilWhenKeyDoesNotExist() {

        #expect(localizationServices.stringForLocale(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == nil)
    }

    @Test
    func stringForUnsupportedLocaleIsLoadedAndUsesTableName() {

        #expect(localizationServices.stringForLocale(localeIdentifier: LocaleId.russianCentralAsia.id, key: "back") == "Назад")
    }

    @Test
    func stringForUnsupportedLocaleFallsBackToBaseLocaleEs() {

        #expect(localizationServices.stringForLocale(localeIdentifier: "es-143", key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseEnglishReturnsLocaleString() {

        #expect(localizationServices.stringForLocaleElseEnglish(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseEnglishFallsBackToEnglishWhenLocaleDoesNotExist() {

        #expect(localizationServices.stringForLocaleElseEnglish(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForLocaleElseEnglishReturnsNilWhenKeyDoesNotExist() {

        #expect(localizationServices.stringForLocaleElseEnglish(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == nil)
    }

    // MARK: - System

    @Test
    func stringForSystemReturnsSpanishStringWhenSystemIsSpanish() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(localizationServices.stringForSystem(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForSystemReturnsNilWhenSystemStringDoesNotExist() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(localizationServices.stringForSystem(key: Self.englishOnlyKey) == nil)
    }

    @Test
    func stringForSystemElseEnglishReturnsSystemString() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(localizationServices.stringForSystemElseEnglish(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForSystemElseEnglishFallsBackToEnglishWhenSystemStringDoesNotExist() {

        #expect(localizationServices.stringForSystemElseEnglish(key: Self.englishOnlyKey) == "English Only")
    }

    // MARK: - Key Fallback

    @Test
    func stringForEnglishElseKeyReturnsEnglishString() {

        #expect(localizationServices.stringForEnglishElseKey(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForEnglishElseKeyReturnsKeyWhenStringDoesNotExist() {

        #expect(localizationServices.stringForEnglishElseKey(key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForLocaleElseKeyReturnsLocaleString() {

        #expect(localizationServices.stringForLocaleElseKey(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseKeyReturnsKeyWhenLocaleStringDoesNotExist() {

        #expect(localizationServices.stringForLocaleElseKey(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == LocalizableStringsKeys.testValueYes.key)
        #expect(localizationServices.stringForLocaleElseKey(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForLocaleElseEnglishElseKeyReturnsLocaleString() {

        #expect(localizationServices.stringForLocaleElseEnglishElseKey(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseEnglishElseKeyFallsBackToEnglishWhenLocaleDoesNotExist() {

        #expect(localizationServices.stringForLocaleElseEnglishElseKey(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForLocaleElseEnglishElseKeyReturnsKeyWhenLocaleAndEnglishStringsDoNotExist() {

        #expect(localizationServices.stringForLocaleElseEnglishElseKey(localeIdentifier: Self.missingLocale, key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForSystemElseEnglishElseKeyReturnsSystemString() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(localizationServices.stringForSystemElseEnglishElseKey(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForSystemElseEnglishElseKeyFallsBackToEnglishWhenSystemStringDoesNotExist() {

        #expect(localizationServices.stringForSystemElseEnglishElseKey(key: Self.englishOnlyKey) == "English Only")
    }

    @Test
    func stringForSystemElseEnglishElseKeyReturnsKeyWhenNoStringsExist() {

        #expect(localizationServices.stringForSystemElseEnglishElseKey(key: Self.missingKey) == Self.missingKey)
    }
}
