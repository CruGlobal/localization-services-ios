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
        config: Config(
            localizableStringsFilesBundle: Bundle.getTestBundle(),
            isUsingBaseInternationalization: true
        )
    )

    private static func getLocalizationServices(fetchStringsInOrder: [StringLocation], shouldFallbackToKeyIfNoString: Bool? = nil) -> LocalizationServices {

        return LocalizationServices(
            config: Config(
                localizableStringsFilesBundle: Bundle.getTestBundle(),
                isUsingBaseInternationalization: true,
                fetchStringsInOrder: fetchStringsInOrder,
                shouldFallbackToKeyIfNoString: shouldFallbackToKeyIfNoString
            )
        )
    }

    // MARK: - Strings By Location

    @Test
    func stringsForKeysReturnsNilWhenFetchStringsInOrderIsEmpty() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [])

        #expect(localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key]) == nil)
    }

    @Test
    func stringsForKeysReturnsNilWhenFetchOrderIsEmpty() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: []) == nil)
    }

    @Test
    func stringsForKeysReturnsEmptyDictionaryWhenKeysAreEmpty() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(localizationServices.stringsForKeys(keys: []) == [:])
    }

    @Test
    func stringsForKeysReturnsStringForEveryKey() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.englishOnlyKey])

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "yes", Self.englishOnlyKey: "English Only"])
    }

    @Test
    func stringsForKeysReturnsStringFromFirstLocationThatHasIt() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [])

        #expect(localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english]) == [LocalizableStringsKeys.testValueYes.key: "Sí"])
        #expect(localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.english, .locale(identifier: LocaleId.spanish.id)]) == [LocalizableStringsKeys.testValueYes.key: "yes"])
    }

    @Test
    func stringsForKeysFallsBackToNextLocationPerKey() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english])

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.englishOnlyKey])

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí", Self.englishOnlyKey: "English Only"])
    }

    @Test
    func stringsForKeysOmitsKeysWithoutStringsWhenUsingDefaultConfig() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english])

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey])

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysFallsBackToKeyWhenStringDoesNotExist() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english])

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey], shouldFallbackToKey: true)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí", Self.missingKey: Self.missingKey])
    }

    @Test
    func stringsForKeysFallsBackToKeyWhenConfigFallsBackToKey() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: true)

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey])

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí", Self.missingKey: Self.missingKey])
    }

    @Test
    func stringsForKeysOmitsKeysWithoutStringsWhenConfigDoesNotFallBackToKey() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: false)

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey])

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysShouldFallbackToKeyOverridesConfig() {

        let fallsBackToKeyServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: true)

        #expect(fallsBackToKeyServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey], shouldFallbackToKey: false) == [LocalizableStringsKeys.testValueYes.key: "Sí"])

        let doesNotFallBackToKeyServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: false)

        #expect(doesNotFallBackToKeyServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey], shouldFallbackToKey: true) == [LocalizableStringsKeys.testValueYes.key: "Sí", Self.missingKey: Self.missingKey])
    }

    @Test
    func stringsForKeysFallingBackToKeyFromConfigDoesNotReplaceStringFoundAtEarlierLocation() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .locale(identifier: Self.missingLocale)], shouldFallbackToKeyIfNoString: true)

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key])

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysFallingBackToKeyDoesNotReplaceStringFoundAtEarlierLocation() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .locale(identifier: Self.missingLocale)])

        let strings = localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], shouldFallbackToKey: true)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysReturnsSystemStrings() {

        // Expects System to be in Spanish.  Configured in tests.

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.system])

        #expect(localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key]) == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysFetchOrderOverridesFetchStringsInOrder() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.locale(identifier: LocaleId.spanish.id)]) == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    // MARK: - String By Location

    @Test
    func stringForKeyReturnsNilWhenFetchStringsInOrderIsEmpty() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == nil)
    }

    @Test
    func stringForKeyReturnsEnglishStringWhenLocationIsEnglish() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForKeyReturnsLocaleStringWhenLocationIsLocale() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id)])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForKeyReturnsSystemStringWhenLocationIsSystem() {

        // Expects System to be in Spanish.  Configured in tests.

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.system])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForKeyFallsBackToNextLocationWhenLocaleDoesNotExist() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: Self.missingLocale), .english])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForKeyFallsBackToNextLocationWhenLocaleStringDoesNotExist() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english])

        #expect(localizationServices.stringForKey(key: Self.englishOnlyKey) == "English Only")
    }

    @Test
    func stringForKeyReturnsStringFromFirstLocationThatHasIt() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english, .locale(identifier: LocaleId.spanish.id)])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForKeyReturnsNilWhenKeyDoesNotExistInAnyLocation() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .system, .english])

        #expect(localizationServices.stringForKey(key: Self.missingKey) == nil)
    }

    @Test
    func stringForKeyReturnsStringWhenFallingBackToKey() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id)])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, shouldFallbackToKey: true) == "Sí")
    }

    @Test
    func stringForKeyReturnsKeyWhenStringDoesNotExistAndFallingBackToKey() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english])

        #expect(localizationServices.stringForKey(key: Self.missingKey, shouldFallbackToKey: true) == Self.missingKey)
    }

    @Test
    func stringForKeyReturnsNilWhenFetchStringsInOrderIsEmptyAndFallingBackToKey() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, shouldFallbackToKey: true) == nil)
    }

    @Test
    func stringForKeyReturnsKeyWhenConfigFallsBackToKey() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: true)

        #expect(localizationServices.stringForKey(key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForKeyReturnsNilWhenConfigDoesNotFallBackToKey() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: false)

        #expect(localizationServices.stringForKey(key: Self.missingKey) == nil)
    }

    @Test
    func stringForKeyShouldFallbackToKeyOverridesConfig() {

        let fallsBackToKeyServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: true)

        #expect(fallsBackToKeyServices.stringForKey(key: Self.missingKey, shouldFallbackToKey: false) == nil)

        let doesNotFallBackToKeyServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: false)

        #expect(doesNotFallBackToKeyServices.stringForKey(key: Self.missingKey, shouldFallbackToKey: true) == Self.missingKey)
    }

    // MARK: - String By Location - Fetch Order

    @Test
    func stringForKeyFetchOrderOverridesFetchStringsInOrder() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: LocaleId.spanish.id)]) == "Sí")
    }

    @Test
    func stringForKeyFetchOrderOverridesEmptyFetchStringsInOrder() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: LocaleId.spanish.id)]) == "Sí")
    }

    @Test
    func stringForKeyUsesFetchStringsInOrderWhenFetchOrderIsNil() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id)])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: nil) == "Sí")
    }

    @Test
    func stringForKeyReturnsNilWhenFetchOrderIsEmpty() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: []) == nil)
    }

    @Test
    func stringForKeyFetchOrderReturnsSystemString() {

        // Expects System to be in Spanish.  Configured in tests.

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.system]) == "Sí")
    }

    @Test
    func stringForKeyFetchOrderFallsBackToNextLocation() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: Self.missingLocale), .locale(identifier: LocaleId.spanish.id)]) == "Sí")
    }

    @Test
    func stringForKeyFetchOrderReturnsStringFromFirstLocationThatHasIt() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english]) == "Sí")
        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.english, .locale(identifier: LocaleId.spanish.id)]) == "yes")
    }

    @Test
    func stringForKeyFetchOrderReturnsNilWhenKeyDoesNotExistInAnyLocation() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(localizationServices.stringForKey(key: Self.missingKey, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .system, .english]) == nil)
    }

    @Test
    func stringForKeyFetchOrderOverridesFetchStringsInOrderWhenFallingBackToKey() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, shouldFallbackToKey: true, fetchOrder: [.locale(identifier: LocaleId.spanish.id)]) == "Sí")
    }

    @Test
    func stringForKeyReturnsNilWhenFetchOrderIsEmptyAndFallingBackToKey() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, shouldFallbackToKey: true, fetchOrder: []) == nil)
    }

    @Test
    func stringForKeyFetchOrderReturnsKeyWhenStringDoesNotExistAndFallingBackToKey() {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(localizationServices.stringForKey(key: Self.missingKey, shouldFallbackToKey: true, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english]) == Self.missingKey)
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
