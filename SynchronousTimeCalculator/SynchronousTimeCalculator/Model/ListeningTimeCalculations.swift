import Foundation

// Model calculations
func determineTotalSynchronousListeningTime(from listeningTimes: [ListeningTime]) -> Float {
    let sortedListeningTimes = listeningTimes.sorted { (listeningTimeA, listeningTimeB) -> Bool in
        return listeningTimeA.startTime <= listeningTimeB.startTime
    }
    let uniqueListeningItems = sortedListeningTimes.uniques
    let nonContainedListeningPeriods = determineNonContainedTimePeriods(in: uniqueListeningItems)
    let removedOverLappingListeningTimes = removeOverlappingListeningTimes(in: nonContainedListeningPeriods)
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
