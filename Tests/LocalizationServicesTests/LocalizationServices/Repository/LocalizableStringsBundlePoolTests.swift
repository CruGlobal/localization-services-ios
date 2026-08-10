//
//  LocalizableStringsBundlePoolTests.swift
//  LocalizationServices
//
//  Created by Levi Eggert on 7/29/26.
//

import Foundation
import Testing
@testable import LocalizationServices

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
    func gettingStringsBundleForExistingLocaleReturnsBundle() async {

        let pool: LocalizableStringsBundlePool = getPool()

        #expect(await pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id) != nil)
    }

    @Test
    func gettingStringsBundleForMissingLocaleReturnsNil() async {

        let pool: LocalizableStringsBundlePool = getPool()

        #expect(await pool.getStringsBundle(localeIdentifier: Self.missingLocale) == nil)
    }

    @Test
    func gettingStringsBundleForEmptyLocaleReturnsNil() async {

        let pool: LocalizableStringsBundlePool = getPool()

        #expect(await pool.getStringsBundle(localeIdentifier: "") == nil)
    }

    @Test
    func gettingStringsBundleForUnsupportedLocaleReturnsBaseLanguageBundleWithLocaleTable() async throws {

        let pool: LocalizableStringsBundlePool = getPool()

        let stringsBundle: LocalizableStringsBundle = try #require(
            await pool.getStringsBundle(localeIdentifier: LocaleId.russianCentralAsia.id)
        )

        #expect(stringsBundle.table == LocaleId.russianCentralAsia.id)
        #expect(stringsBundle.stringForKey(key: "back") == "Назад")
    }

    // MARK: - Caching

    @Test
    func gettingStringsBundleForSameLocaleReturnsCachedBundleInstance() async throws {

        let pool: LocalizableStringsBundlePool = getPool()

        let firstStringsBundle: LocalizableStringsBundle = try #require(
            await pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        let secondStringsBundle: LocalizableStringsBundle = try #require(
            await pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        #expect(firstStringsBundle === secondStringsBundle)
    }

    @Test
    func gettingStringsBundleForDifferentLocalesReturnsDifferentBundleInstances() async throws {

        let pool: LocalizableStringsBundlePool = getPool()

        let spanishStringsBundle: LocalizableStringsBundle = try #require(
            await pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        let englishStringsBundle: LocalizableStringsBundle = try #require(
            await pool.getStringsBundle(localeIdentifier: LocaleId.english.id)
        )

        #expect(spanishStringsBundle !== englishStringsBundle)
    }

    // MARK: - Add Strings Bundle

    @Test
    func gettingStringsBundleReturnsAddedBundleInstance() async throws {

        let pool: LocalizableStringsBundlePool = getPool()

        let addedStringsBundle: LocalizableStringsBundle = getTestStringsBundle()

        await pool.addStringsBundle(
            localeIdentifier: LocaleId.spanish.id,
            stringsBundle: addedStringsBundle
        )

        let stringsBundle: LocalizableStringsBundle = try #require(
            await pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        #expect(stringsBundle === addedStringsBundle)
    }

    @Test
    func gettingStringsBundleReturnsAddedBundleForLocaleThatCanNotBeLoaded() async throws {

        let pool: LocalizableStringsBundlePool = getPool()

        let addedStringsBundle: LocalizableStringsBundle = getTestStringsBundle()

        await pool.addStringsBundle(
            localeIdentifier: Self.missingLocale,
            stringsBundle: addedStringsBundle
        )

        let stringsBundle: LocalizableStringsBundle = try #require(
            await pool.getStringsBundle(localeIdentifier: Self.missingLocale)
        )

        #expect(stringsBundle === addedStringsBundle)
    }

    @Test
    func addingNilStringsBundleForExistingLocaleReturnsNilWithoutLoadingBundle() async {

        let pool: LocalizableStringsBundlePool = getPool()

        await pool.addStringsBundle(
            localeIdentifier: LocaleId.spanish.id,
            stringsBundle: nil
        )

        #expect(await pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id) == nil)
    }

    @Test
    func addingStringsBundleForSameLocaleReturnsMostRecentlyAddedBundle() async throws {

        let pool: LocalizableStringsBundlePool = getPool()

        let firstStringsBundle: LocalizableStringsBundle = getTestStringsBundle()
        let secondStringsBundle: LocalizableStringsBundle = getTestStringsBundle()

        await pool.addStringsBundle(localeIdentifier: LocaleId.spanish.id, stringsBundle: firstStringsBundle)
        await pool.addStringsBundle(localeIdentifier: LocaleId.spanish.id, stringsBundle: secondStringsBundle)

        let stringsBundle: LocalizableStringsBundle = try #require(
            await pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        #expect(stringsBundle === secondStringsBundle)
    }

    // MARK: - Max Size

    @Test
    func stringsBundleIsRetainedWhenMaxSizeIsNotExceeded() async throws {

        let pool: LocalizableStringsBundlePool = getPool(maxSize: 3)

        let addedStringsBundle: LocalizableStringsBundle = getTestStringsBundle()

        await pool.addStringsBundle(localeIdentifier: LocaleId.spanish.id, stringsBundle: addedStringsBundle)
        await pool.addStringsBundle(localeIdentifier: "locale.1", stringsBundle: getTestStringsBundle())
        await pool.addStringsBundle(localeIdentifier: "locale.2", stringsBundle: getTestStringsBundle())

        let stringsBundle: LocalizableStringsBundle = try #require(
            await pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        #expect(stringsBundle === addedStringsBundle)
    }

    @Test
    func oldestStringsBundleIsRemovedWhenMaxSizeIsExceeded() async throws {

        let pool: LocalizableStringsBundlePool = getPool(maxSize: 2)

        let addedStringsBundle: LocalizableStringsBundle = getTestStringsBundle()

        await pool.addStringsBundle(localeIdentifier: LocaleId.spanish.id, stringsBundle: addedStringsBundle)
        await pool.addStringsBundle(localeIdentifier: "locale.1", stringsBundle: getTestStringsBundle())
        await pool.addStringsBundle(localeIdentifier: "locale.2", stringsBundle: getTestStringsBundle())

        let stringsBundle: LocalizableStringsBundle = try #require(
            await pool.getStringsBundle(localeIdentifier: LocaleId.spanish.id)
        )

        #expect(stringsBundle !== addedStringsBundle, "Expected the oldest pool object to be removed and the strings bundle to be reloaded.")
    }

    @Test
    func mostRecentlyAddedStringsBundlesAreRetainedWhenMaxSizeIsExceeded() async throws {

        let pool: LocalizableStringsBundlePool = getPool(maxSize: 2)

        let firstStringsBundle: LocalizableStringsBundle = getTestStringsBundle()
        let secondStringsBundle: LocalizableStringsBundle = getTestStringsBundle()
        let thirdStringsBundle: LocalizableStringsBundle = getTestStringsBundle()

        await pool.addStringsBundle(localeIdentifier: "locale.1", stringsBundle: firstStringsBundle)
        await pool.addStringsBundle(localeIdentifier: "locale.2", stringsBundle: secondStringsBundle)
        await pool.addStringsBundle(localeIdentifier: "locale.3", stringsBundle: thirdStringsBundle)

        let thirdPooledStringsBundle: LocalizableStringsBundle = try #require(await pool.getStringsBundle(localeIdentifier: "locale.3"))
        let secondPooledStringsBundle: LocalizableStringsBundle = try #require(await pool.getStringsBundle(localeIdentifier: "locale.2"))

        #expect(thirdPooledStringsBundle === thirdStringsBundle)
        #expect(secondPooledStringsBundle === secondStringsBundle)
        #expect(await pool.getStringsBundle(localeIdentifier: "locale.1") == nil)
    }
}
