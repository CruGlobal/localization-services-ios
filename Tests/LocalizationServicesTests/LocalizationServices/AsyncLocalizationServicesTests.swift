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
        config: Config(
            localizableStringsFilesBundle: Bundle.getTestBundle(),
            isUsingBaseInternationalization: true
        )
    )

    private static func getLocalizationServices(fetchStringsInOrder: [StringLocation], shouldFallbackToKeyIfNoString: Bool? = nil) -> AsyncLocalizationServices {

        return AsyncLocalizationServices(
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
    func stringsForKeysReturnsNilWhenFetchStringsInOrderIsEmpty() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [])

        #expect(await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key]) == nil)
    }

    @Test
    func stringsForKeysReturnsNilWhenFetchOrderIsEmpty() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: []) == nil)
    }

    @Test
    func stringsForKeysReturnsEmptyDictionaryWhenKeysAreEmpty() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(await localizationServices.stringsForKeys(keys: []) == [:])
    }

    @Test
    func stringsForKeysReturnsStringForEveryKey() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.englishOnlyKey])

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "yes", Self.englishOnlyKey: "English Only"])
    }

    @Test
    func stringsForKeysReturnsStringFromFirstLocationThatHasIt() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [])

        #expect(await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english]) == [LocalizableStringsKeys.testValueYes.key: "Sí"])
        #expect(await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.english, .locale(identifier: LocaleId.spanish.id)]) == [LocalizableStringsKeys.testValueYes.key: "yes"])
    }

    @Test
    func stringsForKeysFallsBackToNextLocationPerKey() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english])

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.englishOnlyKey])

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí", Self.englishOnlyKey: "English Only"])
    }

    @Test
    func stringsForKeysOmitsKeysWithoutStringsWhenUsingDefaultConfig() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english])

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey])

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysFallsBackToKeyWhenStringDoesNotExist() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english])

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey], shouldFallbackToKey: true)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí", Self.missingKey: Self.missingKey])
    }

    @Test
    func stringsForKeysFallsBackToKeyWhenConfigFallsBackToKey() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: true)

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey])

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí", Self.missingKey: Self.missingKey])
    }

    @Test
    func stringsForKeysOmitsKeysWithoutStringsWhenConfigDoesNotFallBackToKey() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: false)

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey])

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysShouldFallbackToKeyOverridesConfig() async {

        let fallsBackToKeyServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: true)

        #expect(await fallsBackToKeyServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey], shouldFallbackToKey: false) == [LocalizableStringsKeys.testValueYes.key: "Sí"])

        let doesNotFallBackToKeyServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: false)

        #expect(await doesNotFallBackToKeyServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key, Self.missingKey], shouldFallbackToKey: true) == [LocalizableStringsKeys.testValueYes.key: "Sí", Self.missingKey: Self.missingKey])
    }

    @Test
    func stringsForKeysFallingBackToKeyFromConfigDoesNotReplaceStringFoundAtEarlierLocation() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .locale(identifier: Self.missingLocale)], shouldFallbackToKeyIfNoString: true)

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key])

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysFallingBackToKeyDoesNotReplaceStringFoundAtEarlierLocation() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .locale(identifier: Self.missingLocale)])

        let strings = await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], shouldFallbackToKey: true)

        #expect(strings == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysReturnsSystemStrings() async {

        // Expects System to be in Spanish.  Configured in tests.

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.system])

        #expect(await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key]) == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    @Test
    func stringsForKeysFetchOrderOverridesFetchStringsInOrder() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(await localizationServices.stringsForKeys(keys: [LocalizableStringsKeys.testValueYes.key], fetchOrder: [.locale(identifier: LocaleId.spanish.id)]) == [LocalizableStringsKeys.testValueYes.key: "Sí"])
    }

    // MARK: - String By Location

    @Test
    func stringForKeyReturnsNilWhenFetchStringsInOrderIsEmpty() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == nil)
    }

    @Test
    func stringForKeyReturnsEnglishStringWhenLocationIsEnglish() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForKeyReturnsLocaleStringWhenLocationIsLocale() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id)])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForKeyReturnsSystemStringWhenLocationIsSystem() async {

        // Expects System to be in Spanish.  Configured in tests.

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.system])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForKeyFallsBackToNextLocationWhenLocaleDoesNotExist() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: Self.missingLocale), .english])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForKeyFallsBackToNextLocationWhenLocaleStringDoesNotExist() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english])

        #expect(await localizationServices.stringForKey(key: Self.englishOnlyKey) == "English Only")
    }

    @Test
    func stringForKeyReturnsStringFromFirstLocationThatHasIt() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english, .locale(identifier: LocaleId.spanish.id)])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForKeyReturnsNilWhenKeyDoesNotExistInAnyLocation() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .system, .english])

        #expect(await localizationServices.stringForKey(key: Self.missingKey) == nil)
    }

    @Test
    func stringForKeyReturnsStringWhenFallingBackToKey() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id)])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, shouldFallbackToKey: true) == "Sí")
    }

    @Test
    func stringForKeyReturnsKeyWhenStringDoesNotExistAndFallingBackToKey() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english])

        #expect(await localizationServices.stringForKey(key: Self.missingKey, shouldFallbackToKey: true) == Self.missingKey)
    }

    @Test
    func stringForKeyReturnsNilWhenFetchStringsInOrderIsEmptyAndFallingBackToKey() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, shouldFallbackToKey: true) == nil)
    }

    @Test
    func stringForKeyReturnsKeyWhenConfigFallsBackToKey() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: true)

        #expect(await localizationServices.stringForKey(key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForKeyReturnsNilWhenConfigDoesNotFallBackToKey() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: false)

        #expect(await localizationServices.stringForKey(key: Self.missingKey) == nil)
    }

    @Test
    func stringForKeyShouldFallbackToKeyOverridesConfig() async {

        let fallsBackToKeyServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: true)

        #expect(await fallsBackToKeyServices.stringForKey(key: Self.missingKey, shouldFallbackToKey: false) == nil)

        let doesNotFallBackToKeyServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .english], shouldFallbackToKeyIfNoString: false)

        #expect(await doesNotFallBackToKeyServices.stringForKey(key: Self.missingKey, shouldFallbackToKey: true) == Self.missingKey)
    }

    // MARK: - String By Location - Fetch Order

    @Test
    func stringForKeyFetchOrderOverridesFetchStringsInOrder() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: LocaleId.spanish.id)]) == "Sí")
    }

    @Test
    func stringForKeyFetchOrderOverridesEmptyFetchStringsInOrder() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: LocaleId.spanish.id)]) == "Sí")
    }

    @Test
    func stringForKeyUsesFetchStringsInOrderWhenFetchOrderIsNil() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id)])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: nil) == "Sí")
    }

    @Test
    func stringForKeyReturnsNilWhenFetchOrderIsEmpty() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: []) == nil)
    }

    @Test
    func stringForKeyFetchOrderReturnsSystemString() async {

        // Expects System to be in Spanish.  Configured in tests.

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.system]) == "Sí")
    }

    @Test
    func stringForKeyFetchOrderFallsBackToNextLocation() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: Self.missingLocale), .locale(identifier: LocaleId.spanish.id)]) == "Sí")
    }

    @Test
    func stringForKeyFetchOrderReturnsStringFromFirstLocationThatHasIt() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english]) == "Sí")
        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, fetchOrder: [.english, .locale(identifier: LocaleId.spanish.id)]) == "yes")
    }

    @Test
    func stringForKeyFetchOrderReturnsNilWhenKeyDoesNotExistInAnyLocation() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(await localizationServices.stringForKey(key: Self.missingKey, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .system, .english]) == nil)
    }

    @Test
    func stringForKeyFetchOrderOverridesFetchStringsInOrderWhenFallingBackToKey() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, shouldFallbackToKey: true, fetchOrder: [.locale(identifier: LocaleId.spanish.id)]) == "Sí")
    }

    @Test
    func stringForKeyReturnsNilWhenFetchOrderIsEmptyAndFallingBackToKey() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(await localizationServices.stringForKey(key: LocalizableStringsKeys.testValueYes.key, shouldFallbackToKey: true, fetchOrder: []) == nil)
    }

    @Test
    func stringForKeyFetchOrderReturnsKeyWhenStringDoesNotExistAndFallingBackToKey() async {

        let localizationServices = Self.getLocalizationServices(fetchStringsInOrder: [.english])

        #expect(await localizationServices.stringForKey(key: Self.missingKey, shouldFallbackToKey: true, fetchOrder: [.locale(identifier: LocaleId.spanish.id), .english]) == Self.missingKey)
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
