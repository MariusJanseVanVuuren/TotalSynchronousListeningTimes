import XCTest
@testable import SynchronousTimeCalculator

class SynchronousTimeEdgeCases2Tests: XCTestCase {
    var listeningItems: [ListeningTime] = []
    override func setUp() {
        guard let listeningTimes = readListeningTimesJson(file: "listeningTimesTest4", bundle: Bundle(for: type(of: self)))?.times else {
            XCTFail("Unable to read test data from json file")
            return
        }
        listeningItems = listeningTimes
    }

    func testRemovingDuplicates() {
        XCTAssertEqual(listeningItems.count, 4, "Initial count of listening items is incorrect")
        let nonContainedItems = determineNonContainedTimePeriods(in: listeningItems)
        XCTAssertEqual(nonContainedItems.count, 4, "All overlapping items have been removed")
    }
    
    func testUniques() {
        XCTAssertEqual(listeningItems.count, 4, "Initial count of listening items is incorrect")
        let uniqueListeningItems = listeningItems.uniques
        XCTAssertEqual(uniqueListeningItems.count, 4, "Initial count of listening items is incorrect")
    }
    
    func testTotalSynchronousTimeCalculation() {
        let totalListeningTime = determineTotalSynchronousListeningTime(from:  listeningItems)
        XCTAssertEqual(totalListeningTime, 5.0, "Total listeniung times is incorreect")
    }
    
    
    func testForInfiniteLoop() {
        guard let listeningTimesInfiniteLoop = readListeningTimesJson(file: "listeningTimesTest2", bundle: Bundle(for: type(of: self)))?.times else {
            XCTFail("Unable to read test data from json file")
            return
        }
        let nonContainedItems = determineNonContainedTimePeriods(in: listeningTimesInfiniteLoop)
        let totalListeningTime = determineTotalSynchronousListeningTime(from:  nonContainedItems)
        XCTAssertEqual(totalListeningTime, 5, "Total listeniung times is incorreect")
    }
    
    func testForCorrectTimeCalculationLoop() {
        guard let listeningTimesInfiniteLoop = readListeningTimesJson(file: "listeningTimesTest3", bundle: Bundle(for: type(of: self)))?.times else {
            XCTFail("Unable to read test data from json file")
            return
        }
        let totalListeningTime = determineTotalSynchronousListeningTime(from:  listeningTimesInfiniteLoop)
        XCTAssertEqual(totalListeningTime, 6, "Total listeniung times is incorreect")
    }
}
