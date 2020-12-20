import Foundation

public class Day16Part1 {
    struct Range {
        let start: Int
        let end: Int

        func contains(number: Int) -> Bool {
            return start <= number && number <= end
        }
    }

    struct RuleRange {
        let start: Range
        let end: Range

        func contains(number: Int) -> Bool {
            return start.contains(number: number) || end.contains(number: number)
        }
    }

    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var data: [Int] = []
    private var rules: [String: RuleRange] = [:]
    private var tickets: [[Int]] = []

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        let lines = str.split(separator: "\n").map(String.init)
        var idx = 0
        var line = lines[idx]
        // Get rules
        while line.contains("your ticket:") == false {
            let parts = line.split(separator: ":")
            let rule = String(parts[0])
            let rangeParts = parts[1].replacingOccurrences(of: "or", with: ",").split(separator: ",").map(String.init)

            let rangeOne = rangeFromString(rangeParts[0])
            let rangeTwo = rangeFromString(rangeParts[1])

            rules[rule] = RuleRange(start: rangeOne, end: rangeTwo)
            idx = idx + 1
            line = lines[idx]
        }
        // Skip to the "nearby tickets:"
        while lines[idx].contains("nearby tickets:") == false {
            idx = idx + 1
        }
        idx = idx + 1

        while idx < lines.count {
            let ticket = lines[idx].split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                .compactMap(Int.init)
            tickets.append(ticket)
            idx = idx + 1
        }
    }

    func rangeFromString(_ string: String) -> Range {
        let parts = string.split(separator: "-").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        let start = Int(parts[0])!
        let end = Int(parts[1])!
        return .init(start: start, end: end)
    }
}

public extension Day16Part1 {

    func solve() -> Int {
        var nonValidNumbers: [Int] = []
        for t in tickets {
            for n in t {
                if isNumberValid(number: n) == false {
                    nonValidNumbers.append(n)
                }
            }
        }
        return nonValidNumbers.reduce(0, +)
    }

    func isNumberValid(number: Int) -> Bool {
        var result = false
        for (_, v) in rules {
            result = result || v.contains(number: number)
        }
        return result
    }
}
