import Foundation


struct ListeningTimes: Decodable, Hashable {
    let times: [ListeningTime]
}

struct ListeningTime: Decodable, Hashable {
    let startTime: Float
    let endTime: Float
    
    var hashValue: Int {
        return (startTime + endTime).hashValue
    }
}

// Fetch
func readListeningTimesJsonFile() -> ListeningTimes? {
    if let path = Bundle.main.path(forResource: "listeningTimes", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            return try decoder.decode(ListeningTimes.self, from: data)
        } catch {
            print("Unable to load json file")
        }
    }
    return nil
}
