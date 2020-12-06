import Foundation

public class Day5Part1 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [[Character]] = []

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }

        input = str.split(separator: "\n").map { str in str.map(Character.init) }
    }
}

public extension Day5Part1 {

    func solve() -> Int {
        var maxID = 0
        for arr in input {
            let row = findRow(in: Array(arr[0...6]))
            let seat = findSeat(in: Array(arr[7...9]))

            let seatId = row * 8 + seat
            maxID = max(maxID, seatId)
        }
        return maxID
    }

    func findRow(in chars: [Character]) -> Int {
        var l = 0, r = 127
        for ch in chars {
            if ch == "F" {
                r  = (l + r) / 2
            } else if ch == "B" {
                l = (l + r) / 2 + 1
            }
        }
        return l
    }

    func findSeat(in chars: [Character]) -> Int {
        var l = 0, r = 7
        for ch in chars {
            if ch == "L" {
                r  = (l + r) / 2
            } else if ch == "R" {
                l = (l + r) / 2 + 1
            }
        }
        return l
    }
}
