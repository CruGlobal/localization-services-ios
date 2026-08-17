//
//  LocalizableStringsBundleLoaderTests.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import Foundation
import Testing
@testable import LocalizationServices

struct LocalizableStringsBundleLoaderTests {

    static let missingLocalizableStringsResource: String = "am"

    private let bundleLoaderUsingBaseInternationalization: LocalizableStringsBundleLoader = LocalizableStringsBundleLoader(
        localizableStringsFilesBundle: Bundle.getTestBundle(),
        isUsingBaseInternationalization: true
    )

    private let bundleLoaderNotUsingBaseInternationalization: LocalizableStringsBundleLoader = LocalizableStringsBundleLoader(
        localizableStringsFilesBundle: Bundle.getTestBundle(),
        isUsingBaseInternationalization: false
    )

    @Test
    func systemLocaleIdentifierIsSpanishWhenSystemIsSpanish() {

        // Expects System to be in Spanish.  Configured in tests.

        #expect(bundleLoaderUsingBaseInternationalization.systemLocaleIdentifier == LocaleId.spanish.id)
    }

    @Test
    func loadingBaseLocalizableStringsExistsWhenUsingBaseInternationalization() {

        #expect(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: BaseInternationalization.baseBundleFilename) != nil, "Failed to load Base localizable strings.")
    }

    @Test
    func loadingBaseLocalizableStringsDictExistsWhenUsingBaseInternationalization() {

        #expect(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: BaseInternationalization.baseBundleFilename) != nil, "Failed to load Base localizable stringsdict.")
    }

    @Test
    func loadingBaseLocalizableStringsDoesNotExistWhenNotUsingBaseInternationalization() {

        #expect(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: BaseInternationalization.baseBundleFilename) == nil, "Should not load Base localizable strings.")
    }

    @Test
    func loadingBaseLocalizableStringsDictDoesNotExistWhenNotUsingBaseInternationalization() {

        #expect(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: BaseInternationalization.baseBundleFilename) == nil, "Should not load Base localizable stringsdict.")
    }

    @Test
    func loadingEnglishLocalizableStringsExistsWhenUsingBaseInternationalization() {

        #expect(bundleLoaderUsingBaseInternationalization.getEnglishBundle() != nil, "Failed to load English localizable strings.")

        #expect(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.english.id) != nil, "Failed to load English localizable strings.")
    }

    @Test
    func loadingEnglishLocalizableStringsDictExistsWhenUsingBaseInternationalization() {

        #expect(bundleLoaderUsingBaseInternationalization.getEnglishBundle() != nil, "Failed to load English localizable stringsdict.")

        #expect(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.english.id) != nil, "Failed to load English localizable stringsdict.")
    }

    @Test
    func loadingEnglishLocalizableStringsExistsWhenNotUsingBaseInternationalization() {

        #expect(bundleLoaderNotUsingBaseInternationalization.getEnglishBundle() != nil, "Failed to load English localizable strings.")

        #expect(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.english.id) != nil, "Failed to load English localizable strings.")
    }

    @Test
    func loadingEnglishLocalizableStringsDictExistsWhenNotUsingBaseInternationalization() {

        #expect(bundleLoaderNotUsingBaseInternationalization.getEnglishBundle() != nil, "Failed to load English localizable stringsdict.")

        #expect(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.english.id) != nil, "Failed to load English localizable stringsdict.")
    }

    @Test
    func loadingSpanishLocalizableStringsExists() {

        #expect(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.spanish.id) != nil, "Failed to load Spanish localizable strings.")

        #expect(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.spanish.id) != nil, "Failed to load Spanish localizable strings.")
    }

    @Test
    func loadingSpanishLocalizableStringsDictExists() {

        #expect(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.spanish.id) != nil, "Failed to load Spanish localizable stringsdict.")

        #expect(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: LocaleId.spanish.id) != nil, "Failed to load Spanish localizable stringsdict.")
    }

    @Test
    func loadingLocalizableStringsBundleDoesNotExist() {

        #expect(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource) == nil)

        #expect(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource) == nil)
    }

    @Test
    func loadingLocalizableStringsdictBundleDoesNotExist() {

        #expect(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource) == nil)

        #expect(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource) == nil)
    }

    @Test
    func emptyBundleFilenameShouldReturnNil() {

        #expect(bundleLoaderUsingBaseInternationalization.bundleForResource(bundleFilename: "") == nil)

        #expect(bundleLoaderNotUsingBaseInternationalization.bundleForResource(bundleFilename: "") == nil)
    }
}
