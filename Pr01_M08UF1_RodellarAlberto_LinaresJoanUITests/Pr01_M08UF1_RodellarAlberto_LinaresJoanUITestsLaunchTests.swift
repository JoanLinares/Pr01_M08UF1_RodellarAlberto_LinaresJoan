//
//  Pr01_M08UF1_RodellarAlberto_LinaresJoanUITestsLaunchTests.swift
//  Pr01_M08UF1_RodellarAlberto_LinaresJoanUITests
//
//  Created by Joan Linares Vigo on 31/12/24.
//

import XCTest

final class Pr01_M08UF1_RodellarAlberto_LinaresJoanUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
