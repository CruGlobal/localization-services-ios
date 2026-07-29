//
//  LocalizableStringsBundlePoolTests.swift
//  LocalizationServices
//
//  Created by Levi Eggert on 7/29/26.
//

import Foundation
import Testing
@testable import LocalizationServices

@MainActor
struct LocalizableStringsBundlePoolTests {

    private static let missingLocale: String = LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource

    private let bundleLoader: LocalizableStringsBundleLoader = LocalizableStringsBundleLoader(
        localizableStringsFilesBundle: Bundle.getTestBundle(),
        isUsingBaseInternationalization: true
    )

    private func getPool(maxSize: Int = 5) -> LocalizableStringsBundlePool {

        return LocalizableStringsBundlePool(
            localizableStringsBundleLoader: bundleLoader,
            maxSize: maxSize
        )
    }

    private func getTestStringsBundle() -> LocalizableStringsBundle {

        return LocalizableStringsBundle(bundle: Bundle.getTestBundle())
    }

    // MARK: - Get Strings Bundle

    @Test
    func gettingStringsBundleForExistingLocaleReturnsBundle() {

        let pool: LocalizableStringsBundlePool = getPool()

        #expect(pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id) != nil)
    }

    @Test
    func gettingStringsBundleForMissingLocaleReturnsNil() {

        let pool: LocalizableStringsBundlePool = getPool()

        #expect(pool.getStringsBundle(localeIdentifier: Self.missingLocale) == nil)
    }

    @Test
    func gettingStringsBundleForEmptyLocaleReturnsNil() {

        let pool: LocalizableStringsBundlePool = getPool()

        #expect(pool.getStringsBundle(localeIdentifier: "") == nil)
    }

    @Test
    func gettingStringsBundleForUnsupportedLocaleReturnsBaseLanguageBundleWithLocaleTable() throws {

        let pool: LocalizableStringsBundlePool = getPool()

        let stringsBundle: LocalizableStringsBundle = try #require(
            pool.getStringsBundle(localeIdentifier: LocaleId.russianCentralAsia.id)
        )

        #expect(stringsBundle.table == LocaleId.russianCentralAsia.id)
        #expect(stringsBundle.stringForKey(key: "back") == "Назад")
    }

    // MARK: - Caching

    @Test
    func gettingStringsBundleForSameLocaleReturnsCachedBundleInstance() throws {

        let pool: LocalizableStringsBundlePool = getPool()

        let firstStringsBundle: LocalizableStringsBundle = try #require(
            pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        let secondStringsBundle: LocalizableStringsBundle = try #require(
            pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        #expect(firstStringsBundle === secondStringsBundle)
    }

    @Test
    func gettingStringsBundleForDifferentLocalesReturnsDifferentBundleInstances() throws {

        let pool: LocalizableStringsBundlePool = getPool()

        let spanishStringsBundle: LocalizableStringsBundle = try #require(
            pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        let englishStringsBundle: LocalizableStringsBundle = try #require(
            pool.getStringsBundle(localeIdentifier: LocaleId.english.id)
        )

        #expect(spanishStringsBundle !== englishStringsBundle)
    }

    // MARK: - Add Strings Bundle

    @Test
    func gettingStringsBundleReturnsAddedBundleInstance() throws {

        let pool: LocalizableStringsBundlePool = getPool()

        let addedStringsBundle: LocalizableStringsBundle = getTestStringsBundle()

        pool.addStringsBundle(
            localeIdentifier: LocaleId.spanish.id,
            stringsBundle: addedStringsBundle
        )

        let stringsBundle: LocalizableStringsBundle = try #require(
            pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        #expect(stringsBundle === addedStringsBundle)
    }

    @Test
    func gettingStringsBundleReturnsAddedBundleForLocaleThatCanNotBeLoaded() throws {

        let pool: LocalizableStringsBundlePool = getPool()

        let addedStringsBundle: LocalizableStringsBundle = getTestStringsBundle()

        pool.addStringsBundle(
            localeIdentifier: Self.missingLocale,
            stringsBundle: addedStringsBundle
        )

        let stringsBundle: LocalizableStringsBundle = try #require(
            pool.getStringsBundle(localeIdentifier: Self.missingLocale)
        )

        #expect(stringsBundle === addedStringsBundle)
    }

    @Test
    func addingNilStringsBundleForExistingLocaleReturnsNilWithoutLoadingBundle() {

        let pool: LocalizableStringsBundlePool = getPool()

        pool.addStringsBundle(
            localeIdentifier: LocaleId.spanish.id,
            stringsBundle: nil
        )

        #expect(pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id) == nil)
    }

    @Test
    func addingStringsBundleForSameLocaleReturnsMostRecentlyAddedBundle() throws {

        let pool: LocalizableStringsBundlePool = getPool()

        let firstStringsBundle: LocalizableStringsBundle = getTestStringsBundle()
        let secondStringsBundle: LocalizableStringsBundle = getTestStringsBundle()

        pool.addStringsBundle(localeIdentifier: LocaleId.spanish.id, stringsBundle: firstStringsBundle)
        pool.addStringsBundle(localeIdentifier: LocaleId.spanish.id, stringsBundle: secondStringsBundle)

        let stringsBundle: LocalizableStringsBundle = try #require(
            pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        #expect(stringsBundle === secondStringsBundle)
    }

    // MARK: - Max Size

    @Test
    func stringsBundleIsRetainedWhenMaxSizeIsNotExceeded() throws {

        let pool: LocalizableStringsBundlePool = getPool(maxSize: 3)

        let addedStringsBundle: LocalizableStringsBundle = getTestStringsBundle()

        pool.addStringsBundle(localeIdentifier: LocaleId.spanish.id, stringsBundle: addedStringsBundle)
        pool.addStringsBundle(localeIdentifier: "locale.1", stringsBundle: getTestStringsBundle())
        pool.addStringsBundle(localeIdentifier: "locale.2", stringsBundle: getTestStringsBundle())

        let stringsBundle: LocalizableStringsBundle = try #require(
            pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        #expect(stringsBundle === addedStringsBundle)
    }

    @Test
    func oldestStringsBundleIsRemovedWhenMaxSizeIsExceeded() throws {

        let pool: LocalizableStringsBundlePool = getPool(maxSize: 2)

        let addedStringsBundle: LocalizableStringsBundle = getTestStringsBundle()

        pool.addStringsBundle(localeIdentifier: LocaleId.spanish.id, stringsBundle: addedStringsBundle)
        pool.addStringsBundle(localeIdentifier: "locale.1", stringsBundle: getTestStringsBundle())
        pool.addStringsBundle(localeIdentifier: "locale.2", stringsBundle: getTestStringsBundle())

        let stringsBundle: LocalizableStringsBundle = try #require(
            pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        #expect(stringsBundle !== addedStringsBundle, "Expected the oldest pool object to be removed and the strings bundle to be reloaded.")
    }

    @Test
    func mostRecentlyAddedStringsBundlesAreRetainedWhenMaxSizeIsExceeded() throws {

        let pool: LocalizableStringsBundlePool = getPool(maxSize: 2)

        let firstStringsBundle: LocalizableStringsBundle = getTestStringsBundle()
        let secondStringsBundle: LocalizableStringsBundle = getTestStringsBundle()
        let thirdStringsBundle: LocalizableStringsBundle = getTestStringsBundle()

        pool.addStringsBundle(localeIdentifier: "locale.1", stringsBundle: firstStringsBundle)
        pool.addStringsBundle(localeIdentifier: "locale.2", stringsBundle: secondStringsBundle)
        pool.addStringsBundle(localeIdentifier: "locale.3", stringsBundle: thirdStringsBundle)

        let thirdPooledStringsBundle: LocalizableStringsBundle = try #require(pool.getStringsBundle(localeIdentifier: "locale.3"))
        let secondPooledStringsBundle: LocalizableStringsBundle = try #require(pool.getStringsBundle(localeIdentifier: "locale.2"))

        #expect(thirdPooledStringsBundle === thirdStringsBundle)
        #expect(secondPooledStringsBundle === secondStringsBundle)
        #expect(pool.getStringsBundle(localeIdentifier: "locale.1") == nil)
    }
}
