import XCTest
@testable import SimpleAnalytics

let successMsgTemplate = "Successfully submitted <%@> items"

final class SubmissionTests: XCTestCase {
    private let endpoint = "testEndpoint"
    private let appName = "AppAnalytics Tester"
    private let moveSquare = "move square"
    private let jumpFive = "jump 5"
    
    var manager = AppAnalytics(endpoint: "", appName: "")
    
    override func setUp() {
        manager = AppAnalytics(endpoint: endpoint, appName: appName)
    }
    
    func testSubmitSuccess() {
        manager.submitter = TestSubmitter(shouldSucceed: true)
        manager.addAnalyticsItem(moveSquare)
        manager.addAnalyticsItem(jumpFive)
        manager.addAnalyticsItem(moveSquare)
        manager.addAnalyticsItem(jumpFive)
        manager.addAnalyticsItem(moveSquare)
        manager.addAnalyticsItem(jumpFive)
        XCTAssertEqual(manager.items.count, 6)
        manager.clearAndSubmitItems()
        XCTAssertTrue(manager.items.isEmpty)
    }
    
    func testSubmitFailure() {
        manager.submitter = TestSubmitter(shouldSucceed: false)
        manager.setMaxItemCount(12)
        manager.maxCountResetValue = 5
        manager.addAnalyticsItem(moveSquare)
        manager.addAnalyticsItem(jumpFive)
        manager.addAnalyticsItem(moveSquare)
        manager.addAnalyticsItem(jumpFive)
        manager.addAnalyticsItem(moveSquare)
        manager.addAnalyticsItem(jumpFive)
        XCTAssertEqual(manager.items.count, 6)
        manager.clearAndSubmitItems()
        XCTAssertFalse(manager.items.isEmpty)
        XCTAssertEqual(manager.items.count, 6)
        manager.addAnalyticsItem(moveSquare)
        manager.addAnalyticsItem(jumpFive)
        XCTAssertEqual(manager.items.count, 8)
        manager.addAnalyticsItem(moveSquare)
        manager.addAnalyticsItem(jumpFive)
        XCTAssertEqual(manager.items.count, 10)
        manager.addAnalyticsItem(moveSquare)
        manager.addAnalyticsItem(jumpFive)
        manager.addAnalyticsItem(moveSquare)
        manager.addAnalyticsItem(jumpFive)
        XCTAssertEqual(manager.items.count, 14)
        // maxCount should now be 17
        manager.submitter = TestSubmitter(shouldSucceed: true)
        manager.addAnalyticsItem(moveSquare)
        manager.addAnalyticsItem(jumpFive)
        // 17th item should result in successful submission and reset
        manager.addAnalyticsItem(moveSquare)
        manager.addAnalyticsItem(jumpFive)
        XCTAssertEqual(manager.items.count, 1)
    }
    
    func testAutomaticSubmission() {
        manager.setMaxItemCount(5)
        manager.submitter = TestSubmitter(shouldSucceed: true)
        
        manager.addAnalyticsItem(moveSquare)
        XCTAssertEqual(manager.items.count, 1)
        manager.addAnalyticsItem(jumpFive)
        XCTAssertEqual(manager.items.count, 2)
        manager.addAnalyticsItem(moveSquare)
        XCTAssertEqual(manager.items.count, 3)
        manager.addAnalyticsItem(jumpFive)
        XCTAssertEqual(manager.items.count, 4)
        manager.addAnalyticsItem(moveSquare)
        XCTAssertEqual(manager.items.count, 0)
        manager.addAnalyticsItem(jumpFive)
        XCTAssertEqual(manager.items.count, 1)
    }

}


struct TestSubmitter: AnalyticsSubmitting {
    var shouldSucceed: Bool
    
    func submitItems(_ items: [AnalyticsItem], itemCounts: [String : Int],
                     successHandler: @escaping(String) -> Void,
                     errorHandler: @escaping([AnalyticsItem], [String : Int]) -> Void) {
        if shouldSucceed == true {
            successHandler(successMsgTemplate.replacingOccurrences(of: "<%@>", with: "\(items.count + itemCounts.count)"))
        } else {
            errorHandler(items, itemCounts)
        }
    }
}
