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
        localizableStringsFilesBundle: Bundle.getTestBundle(),
        isUsingBaseInternationalization: true
    )

    // MARK: - English

    @Test
    func stringForEnglishAsyncReturnsEnglishString() async {

        #expect(await localizationServices.stringForEnglishAsync(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForEnglishReturnsEnglishString() {

        #expect(localizationServices.stringForEnglish(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForEnglishAsyncReturnsStringFromLocalizableStringsdict() async {

        #expect(await localizationServices.stringForEnglishAsync(key: LocalizableStringsdictKeys.badgesToolsOpened.key) != nil)
    }

    @Test
    func stringForEnglishReturnsStringFromLocalizableStringsdict() {

        #expect(localizationServices.stringForEnglish(key: LocalizableStringsdictKeys.badgesToolsOpened.key) != nil)
    }

    @Test
    func stringForEnglishAsyncReturnsNilWhenKeyDoesNotExist() async {

        #expect(await localizationServices.stringForEnglishAsync(key: Self.missingKey) == nil)
        #expect(await localizationServices.stringForEnglishAsync(key: "") == nil)
    }

    @Test
    func stringForEnglishReturnsNilWhenKeyDoesNotExist() {

        #expect(localizationServices.stringForEnglish(key: Self.missingKey) == nil)
        #expect(localizationServices.stringForEnglish(key: "") == nil)
    }

    // MARK: - Locale

    @Test
    func stringForLocaleAsyncReturnsLocaleString() async {

        #expect(await localizationServices.stringForLocaleAsync(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleReturnsLocaleString() {

        #expect(localizationServices.stringForLocale(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleAsyncReturnsNilWhenLocaleIdentifierIsEmpty() async {

        #expect(await localizationServices.stringForLocaleAsync(localeIdentifier: "", key: LocalizableStringsKeys.testValueYes.key) == nil)
    }

    @Test
    func stringForLocaleReturnsNilWhenLocaleIdentifierIsEmpty() {

        #expect(localizationServices.stringForLocale(localeIdentifier: "", key: LocalizableStringsKeys.testValueYes.key) == nil)
    }

    @Test
    func stringForLocaleAsyncReturnsNilWhenLocaleDoesNotExist() async {

        #expect(await localizationServices.stringForLocaleAsync(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == nil)
    }

    @Test
    func stringForLocaleReturnsNilWhenLocaleDoesNotExist() {

        #expect(localizationServices.stringForLocale(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == nil)
    }

    @Test
    func stringForLocaleAsyncReturnsNilWhenKeyDoesNotExist() async {

        #expect(await localizationServices.stringForLocaleAsync(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == nil)
    }

    @Test
    func stringForLocaleReturnsNilWhenKeyDoesNotExist() {

        #expect(localizationServices.stringForLocale(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == nil)
    }

    @Test
    func stringForUnsupportedLocaleIsLoadedAndUsesTableName() async {

        #expect(await localizationServices.stringForLocaleAsync(localeIdentifier: LocaleId.russianCentralAsia.id, key: "back") == "Назад")
        #expect(localizationServices.stringForLocale(localeIdentifier: LocaleId.russianCentralAsia.id, key: "back") == "Назад")
    }

    @Test
    func stringForUnsupportedLocaleFallsBackToBaseLocaleEs() async {

        #expect(await localizationServices.stringForLocaleAsync(localeIdentifier: "es-143", key: LocalizableStringsKeys.testValueYes.key) == "Sí")
        #expect(localizationServices.stringForLocale(localeIdentifier: "es-143", key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseEnglishAsyncReturnsLocaleString() async {

        #expect(await localizationServices.stringForLocaleElseEnglishAsync(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseEnglishReturnsLocaleString() {

        #expect(localizationServices.stringForLocaleElseEnglish(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseEnglishAsyncFallsBackToEnglishWhenLocaleDoesNotExist() async {

        #expect(await localizationServices.stringForLocaleElseEnglishAsync(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForLocaleElseEnglishFallsBackToEnglishWhenLocaleDoesNotExist() {

        #expect(localizationServices.stringForLocaleElseEnglish(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForLocaleElseEnglishAsyncReturnsNilWhenKeyDoesNotExist() async {

        #expect(await localizationServices.stringForLocaleElseEnglishAsync(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == nil)
    }

    @Test
    func stringForLocaleElseEnglishReturnsNilWhenKeyDoesNotExist() {

        #expect(localizationServices.stringForLocaleElseEnglish(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == nil)
    }

    @Test
    func stringForLocaleElseSystemElseEnglishAsyncReturnsLocaleString() async {

        #expect(await localizationServices.stringForLocaleElseSystemElseEnglishAsync(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishReturnsLocaleString() {

        #expect(localizationServices.stringForLocaleElseSystemElseEnglish(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishAsyncFallsBackToSystemWhenLocaleDoesNotExist() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await localizationServices.stringForLocaleElseSystemElseEnglishAsync(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishFallsBackToSystemWhenLocaleDoesNotExist() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(localizationServices.stringForLocaleElseSystemElseEnglish(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishAsyncFallsBackToEnglishWhenLocaleAndSystemStringsDoNotExist() async {

        #expect(await localizationServices.stringForLocaleElseSystemElseEnglishAsync(localeIdentifier: Self.missingLocale, key: Self.englishOnlyKey) == "English Only")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishFallsBackToEnglishWhenLocaleAndSystemStringsDoNotExist() {

        #expect(localizationServices.stringForLocaleElseSystemElseEnglish(localeIdentifier: Self.missingLocale, key: Self.englishOnlyKey) == "English Only")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishAsyncReturnsNilWhenKeyDoesNotExist() async {

        #expect(await localizationServices.stringForLocaleElseSystemElseEnglishAsync(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == nil)
    }

    @Test
    func stringForLocaleElseSystemElseEnglishReturnsNilWhenKeyDoesNotExist() {

        #expect(localizationServices.stringForLocaleElseSystemElseEnglish(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == nil)
    }

    // MARK: - System

    @Test
    func stringForSystemAsyncReturnsSpanishStringWhenSystemIsSpanish() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await localizationServices.stringForSystemAsync(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForSystemReturnsSpanishStringWhenSystemIsSpanish() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(localizationServices.stringForSystem(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForSystemAsyncReturnsNilWhenSystemStringDoesNotExist() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await localizationServices.stringForSystemAsync(key: Self.englishOnlyKey) == nil)
    }

    @Test
    func stringForSystemReturnsNilWhenSystemStringDoesNotExist() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(localizationServices.stringForSystem(key: Self.englishOnlyKey) == nil)
    }

    @Test
    func stringForSystemElseEnglishAsyncReturnsSystemString() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await localizationServices.stringForSystemElseEnglishAsync(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForSystemElseEnglishReturnsSystemString() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(localizationServices.stringForSystemElseEnglish(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForSystemElseEnglishAsyncFallsBackToEnglishWhenSystemStringDoesNotExist() async {

        #expect(await localizationServices.stringForSystemElseEnglishAsync(key: Self.englishOnlyKey) == "English Only")
    }

    @Test
    func stringForSystemElseEnglishFallsBackToEnglishWhenSystemStringDoesNotExist() {

        #expect(localizationServices.stringForSystemElseEnglish(key: Self.englishOnlyKey) == "English Only")
    }

    // MARK: - Key Fallback

    @Test
    func stringForEnglishElseKeyAsyncReturnsEnglishString() async {

        #expect(await localizationServices.stringForEnglishElseKeyAsync(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForEnglishElseKeyReturnsEnglishString() {

        #expect(localizationServices.stringForEnglishElseKey(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForEnglishElseKeyAsyncReturnsKeyWhenStringDoesNotExist() async {

        #expect(await localizationServices.stringForEnglishElseKeyAsync(key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForEnglishElseKeyReturnsKeyWhenStringDoesNotExist() {

        #expect(localizationServices.stringForEnglishElseKey(key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForLocaleElseKeyAsyncReturnsLocaleString() async {

        #expect(await localizationServices.stringForLocaleElseKeyAsync(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseKeyReturnsLocaleString() {

        #expect(localizationServices.stringForLocaleElseKey(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseKeyAsyncReturnsKeyWhenLocaleStringDoesNotExist() async {

        #expect(await localizationServices.stringForLocaleElseKeyAsync(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == LocalizableStringsKeys.testValueYes.key)
        #expect(await localizationServices.stringForLocaleElseKeyAsync(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForLocaleElseKeyReturnsKeyWhenLocaleStringDoesNotExist() {

        #expect(localizationServices.stringForLocaleElseKey(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == LocalizableStringsKeys.testValueYes.key)
        #expect(localizationServices.stringForLocaleElseKey(localeIdentifier: LocaleId.spanish.id, key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForLocaleElseEnglishElseKeyAsyncReturnsLocaleString() async {

        #expect(await localizationServices.stringForLocaleElseEnglishElseKeyAsync(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseEnglishElseKeyReturnsLocaleString() {

        #expect(localizationServices.stringForLocaleElseEnglishElseKey(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseEnglishElseKeyAsyncFallsBackToEnglishWhenLocaleDoesNotExist() async {

        #expect(await localizationServices.stringForLocaleElseEnglishElseKeyAsync(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForLocaleElseEnglishElseKeyFallsBackToEnglishWhenLocaleDoesNotExist() {

        #expect(localizationServices.stringForLocaleElseEnglishElseKey(localeIdentifier: Self.missingLocale, key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }

    @Test
    func stringForLocaleElseEnglishElseKeyAsyncReturnsKeyWhenLocaleAndEnglishStringsDoNotExist() async {

        #expect(await localizationServices.stringForLocaleElseEnglishElseKeyAsync(localeIdentifier: Self.missingLocale, key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForLocaleElseEnglishElseKeyReturnsKeyWhenLocaleAndEnglishStringsDoNotExist() {

        #expect(localizationServices.stringForLocaleElseEnglishElseKey(localeIdentifier: Self.missingLocale, key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForLocaleElseSystemElseEnglishElseKeyAsyncReturnsLocaleString() async {

        #expect(await localizationServices.stringForLocaleElseSystemElseEnglishElseKeyAsync(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishElseKeyReturnsLocaleString() {

        #expect(localizationServices.stringForLocaleElseSystemElseEnglishElseKey(localeIdentifier: LocaleId.spanish.id, key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishElseKeyAsyncFallsBackToEnglishWhenLocaleAndSystemStringsDoNotExist() async {

        #expect(await localizationServices.stringForLocaleElseSystemElseEnglishElseKeyAsync(localeIdentifier: Self.missingLocale, key: Self.englishOnlyKey) == "English Only")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishElseKeyFallsBackToEnglishWhenLocaleAndSystemStringsDoNotExist() {

        #expect(localizationServices.stringForLocaleElseSystemElseEnglishElseKey(localeIdentifier: Self.missingLocale, key: Self.englishOnlyKey) == "English Only")
    }

    @Test
    func stringForLocaleElseSystemElseEnglishElseKeyAsyncReturnsKeyWhenNoStringsExist() async {

        #expect(await localizationServices.stringForLocaleElseSystemElseEnglishElseKeyAsync(localeIdentifier: Self.missingLocale, key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForLocaleElseSystemElseEnglishElseKeyReturnsKeyWhenNoStringsExist() {

        #expect(localizationServices.stringForLocaleElseSystemElseEnglishElseKey(localeIdentifier: Self.missingLocale, key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForSystemElseEnglishElseKeyAsyncReturnsSystemString() async {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(await localizationServices.stringForSystemElseEnglishElseKeyAsync(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForSystemElseEnglishElseKeyReturnsSystemString() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(localizationServices.stringForSystemElseEnglishElseKey(key: LocalizableStringsKeys.testValueYes.key) == "Sí")
    }

    @Test
    func stringForSystemElseEnglishElseKeyAsyncFallsBackToEnglishWhenSystemStringDoesNotExist() async {

        #expect(await localizationServices.stringForSystemElseEnglishElseKeyAsync(key: Self.englishOnlyKey) == "English Only")
    }

    @Test
    func stringForSystemElseEnglishElseKeyFallsBackToEnglishWhenSystemStringDoesNotExist() {

        #expect(localizationServices.stringForSystemElseEnglishElseKey(key: Self.englishOnlyKey) == "English Only")
    }

    @Test
    func stringForSystemElseEnglishElseKeyAsyncReturnsKeyWhenNoStringsExist() async {

        #expect(await localizationServices.stringForSystemElseEnglishElseKeyAsync(key: Self.missingKey) == Self.missingKey)
    }

    @Test
    func stringForSystemElseEnglishElseKeyReturnsKeyWhenNoStringsExist() {

        #expect(localizationServices.stringForSystemElseEnglishElseKey(key: Self.missingKey) == Self.missingKey)
    }
}
