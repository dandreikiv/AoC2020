import Foundation

public class Day13Part1 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var timeStamp: Int = 0
    private var busId: [Int] = []

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        let data = str.split(separator: "\n").map(String.init)
        timeStamp = Int(data[0])!
        busId = data[1].split(separator: ",").compactMap { Int($0) }
    }
}

public extension Day13Part1 {

    func solve() -> Int {
        print(timeStamp)
        print(busId)
        var minTime = Int.max
        var minTimeId = 0
        for id in busId {
            let n = timeStamp / id
            if id * (n + 1) < minTime {
                minTime = id * (n + 1)
                minTimeId = id
            }
        }

        return (minTime - timeStamp) * minTimeId
    }
}
