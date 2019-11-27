import XCTest
@testable import SynchronousTimeCalculator

class SynchronousTimeCalculatorTests: XCTestCase {
    var listeningItems: [ListeningTime] = []
    override func setUp() {
        guard let listeningTimes = readListeningTimesJson(file: "listeningTimesTests", bundle: Bundle(for: type(of: self)))?.times else {
            XCTFail("Unable to read test data from json file")
            return
        }
        listeningItems = listeningTimes
    }

    func testRemovingDuplicates() {
        XCTAssertEqual(listeningItems.count, 14, "Initial count of listening items is incorrect")
        var nonContainedItems = determineNonContainedTimePeriods(in: listeningItems)
        XCTAssertEqual(nonContainedItems.count, 5, "All overlapping items have been removed")
    }
    
    func testUniques() {
        XCTAssertEqual(listeningItems.count, 14, "Initial count of listening items is incorrect")
        let uniqueListeningItems = listeningItems.uniques
        XCTAssertEqual(uniqueListeningItems.count, 11, "Initial count of listening items is incorrect")
    }
    
    func testItemContainedBetweenTwoItems() {
        XCTAssertEqual(listeningItems.count, 14, "Initial count of listening items is incorrect")
        let nonConatainedItems = removeListeningTimesContainedBetweenTwoOtherListeningPeriods(in: listeningItems)
        XCTAssertEqual(nonConatainedItems.count, 2, "Initial count of listening items is incorrect")
    }
    
    func testTotalSynchronousTimeCalculation() {
        let totalListeningTime = determineTotalSynchronousListeningTime(from:  listeningItems)
        XCTAssertEqual(totalListeningTime, 68.7, "Initial count of listening items is incorrect")
    }
}
