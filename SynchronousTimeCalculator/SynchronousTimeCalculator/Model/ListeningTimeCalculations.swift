import Foundation

// Model calculations
func determineTotalSynchronousListeningTime(from listeningTimes: [ListeningTime]) -> Float {
    let sortedListeningTimes = listeningTimes.sorted { (listeningTimeA, listeningTimeB) -> Bool in
        return listeningTimeA.startTime <= listeningTimeB.startTime
    }
    let uniqueListeningItems = sortedListeningTimes.uniques
    let nonContainedListeningPeriods = determineNonContainedTimePeriods(in: uniqueListeningItems)
    let nonContainedBetweenTwoTimeLines = removeListeningTimesContainedBetweenTwoOtherListeningPeriods(in: nonContainedListeningPeriods)
    let removedOverLappingListeningTimes = removeOverlappingListeningTimes(in: nonContainedBetweenTwoTimeLines)
    return determineListeningDuration(for: removedOverLappingListeningTimes)
}

// Remove values which are wholly within another time line
func determineNonContainedTimePeriods(in listeningItems: [ListeningTime]) -> [ListeningTime] {
    var nonContainedListeningTimes = [ListeningTime]()
    for item in listeningItems {
        var listeningTimeIsContainedWithinAnotherPeriod = false
        for comparingToItem in listeningItems {
            if item != comparingToItem {
                if item.startTime >= comparingToItem.startTime && item.endTime <= comparingToItem.endTime {
                    listeningTimeIsContainedWithinAnotherPeriod = true
                }
            }
        }
        if listeningTimeIsContainedWithinAnotherPeriod == false {
            nonContainedListeningTimes.append(item)
        }
    }
    return nonContainedListeningTimes
}

// remove items that are wholly contained between its previous and next time line items
func removeListeningTimesContainedBetweenTwoOtherListeningPeriods(in listeningItems: [ListeningTime]) -> [ListeningTime]{
    var nonContainedBetweenTwoListeningTimesItems = [ListeningTime]()
    var mutableListningItems = listeningItems
    var foundContainedItem = true
    whileCondition : while (foundContainedItem) {
        foundContainedItem = false
        forCondition: for index in 0...mutableListningItems.count - 1 {
            var itemTimeLineIsContainedBetweenTwoOthervalues = false
            if index == 0 {
                // Do nothing since the first value can not have a starting date before any other or be contained
                nonContainedBetweenTwoListeningTimesItems.append(mutableListningItems[index])
            } else if index == mutableListningItems.count - 1 {
                // Last value can not be contained between two values due to sorting and removing of contained values
                nonContainedBetweenTwoListeningTimesItems.append(mutableListningItems[index])
            } else {
                let currentItem = mutableListningItems[index]
                let nextItem = mutableListningItems[index+1]
                let previousItem = mutableListningItems[index]
                if currentItem.startTime < previousItem.endTime && currentItem.startTime < nextItem.startTime
                    && previousItem.endTime > nextItem.startTime && currentItem.endTime < nextItem.endTime
                    && nextItem.endTime > currentItem.endTime {
                    itemTimeLineIsContainedBetweenTwoOthervalues = true
                    foundContainedItem = true
                }
                if itemTimeLineIsContainedBetweenTwoOthervalues == false {
                    nonContainedBetweenTwoListeningTimesItems.append(currentItem)
                    if let firstIndexOfListeningItem = mutableListningItems.firstIndex(of: currentItem) {
                        mutableListningItems.remove(at: firstIndexOfListeningItem)
                    }
                    break forCondition
                }
            }
        }
    }
    return nonContainedBetweenTwoListeningTimesItems
}

// Remove the over lapping time between time line values
func removeOverlappingListeningTimes(in listeningItems: [ListeningTime]) -> [ListeningTime] {
    var nonOverLappingListeningTimes = [ListeningTime]()
    for index in 0...listeningItems.count - 1 {
        if index == 0 {
            // Do nothing since the first value can not have a starting date before any other or be contained
            nonOverLappingListeningTimes.append(listeningItems[index])
        } else {
            let previousItem = listeningItems[index-1]
            var itemToSave = listeningItems[index]
            if itemToSave.startTime < previousItem.endTime {
                itemToSave = ListeningTime(startTime: previousItem.endTime, endTime: itemToSave.endTime)
            }
            nonOverLappingListeningTimes.append(itemToSave)
        }
    }
    return nonOverLappingListeningTimes
}

// Determine the actual listinge duration for the provided listening times
func determineListeningDuration(for listeningTimes: [ListeningTime]) -> Float {
    var duration: Float = 0.0
    for item in listeningTimes {
        duration = duration + (item.endTime-item.startTime) // assume end time is always after start time
    }
    return duration
}
