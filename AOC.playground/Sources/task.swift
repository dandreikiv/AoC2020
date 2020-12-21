import Foundation

public class Day16Part2 {
    struct Range {
        let start: Int
        let end: Int

        func contains(number: Int) -> Bool {
            return start <= number && number <= end
        }
    }

    struct RuleRange: CustomDebugStringConvertible {
        let start: Range
        let end: Range

        func contains(number: Int) -> Bool {
            return start.contains(number: number) || end.contains(number: number)
        }

        var debugDescription: String {
            return "\(start.start)-\(start.end) or \(end.start)-\(end.end)"
        }
    }

    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var data: [Int] = []
    private var rules: [String: RuleRange] = [:]
    private var tickets: [[Int]] = []
    private var myTicket: [Int] = []

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

        // Skip to the "your ticket:"
        while lines[idx].contains("your ticket:") == false { idx = idx + 1 }
        idx = idx + 1
        myTicket = lines[idx].split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }.compactMap(Int.init)

        // Skip to the "nearby tickets:"
        while lines[idx].contains("nearby tickets:") == false { idx = idx + 1 }
        idx = idx + 1

        while idx < lines.count {
            let ticket = lines[idx].split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                .compactMap(Int.init)
            tickets.append(ticket)
            idx = idx + 1
        }
        print("myTicket: \(myTicket)")
    }

    func rangeFromString(_ string: String) -> Range {
        let parts = string.split(separator: "-").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        let start = Int(parts[0])!
        let end = Int(parts[1])!
        return .init(start: start, end: end)
    }

    func satisfyingRule(for position: Int, in tickets: [[Int]]) -> (rule: String, range: RuleRange)? {
        let values = tickets.map { $0[position] }
        var rls = rules
        var validRules: [String: RuleRange] = [:]
        for v in values {
            for (rule, range) in rls {
                if range.contains(number: v) {
                    validRules[rule] = range
                }
            }
            rls = validRules
            validRules = [:]
        }

        if rls.count == 1 {
            return (rule: rls.first!.key, range: rls.first!.value)
        }

        return nil
    }
}

public extension Day16Part2 {

    func solve() -> Int {
        let validTickets = tickets.filter(isTicketValid)
        let count = tickets[0].count
        var resultPositions: [Int] = []
        while rules.count > 0 {
            for pos in 0..<count {
                if let res = satisfyingRule(for: pos, in: validTickets) {
                    print("pos: \(pos), rule: \(res.rule)")
                    rules.removeValue(forKey: res.rule)
                    if res.rule.contains("departure") {
                        resultPositions.append(pos)
                    }
                }
            }
        }

        print(resultPositions)
        return resultPositions.map { myTicket[$0] }.reduce(1, *)
    }

    func isTicketValid(ticket: [Int]) -> Bool {
        for t in ticket {
            if isNumberValid(number: t) == false { return false }
        }
        return true
    }

    func isNumberValid(number: Int) -> Bool {
        var result = false
        for (_, v) in rules {
            result = result || v.contains(number: number)
        }
        return result
    }
}
