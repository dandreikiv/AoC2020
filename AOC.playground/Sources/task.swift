import Foundation

public class Day19Part1 {

    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [String] = []
    private var data: [Int: [[Value]]] = [:]
    private var messages: [String] = []

    public init() {
        loadInput()
        parse()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        input = str.replacingOccurrences(of: "\"", with: "").split(separator: "\n").map(String.init)
    }

    func parse() {
        for line in input {
            guard line.contains(":") else {
                messages.append(line)
                continue
            }
            let parts = line.split(separator: ":").map(String.init)
            let step = Int(parts[0])!
            data[step] = parts[1].split(separator: "|").map { variant in
                variant.split(separator: " ").map(String.init).map { str -> Value in
                    if let ruleNumber = Int(str) {
                        return .int(ruleNumber)
                    } else {
                        return .string(str)
                    }
                }
            }
        }
    }
}

public extension Day19Part1 {
    enum Value: CustomDebugStringConvertible {
        case string(String)
        case int(Int)

        public var debugDescription: String {
            switch self {
                case .int(let number):
                    return "\(number)"
                case .string(let string):
                    return string
            }
        }
    }

    func solve() -> Int {
        let rule0 = data[0]!
        var setOfRules = rule0

        while true {
            var allRulesDone = true
            var newSetOfRules: [[Value]] = []
            for rule in setOfRules {
                var temp: [[Value]] = []
                for el in rule {
                    if case .string = el {
                        if temp.isEmpty {
                            temp.append([el])
                        } else {
                            for i in 0..<temp.count {
                                temp[i].append(el)
                            }
                        }
                    }
                    else if case .int(let n) = el, let nextRule = data[n] {
                        allRulesDone = false
                        var t: [[Value]] = []
                        if temp.isEmpty {
                            temp.append([])
                        }

                        for tempEl in temp {
                            for nextRuleEl in nextRule {
                                t.append(tempEl + nextRuleEl)
                            }
                        }
                        temp = t
                    }
                }
                newSetOfRules.append(contentsOf: temp)
            }
            setOfRules = newSetOfRules
            if allRulesDone { break }
        }

        let rules = setOfRules.compactMap { rule -> String? in
            return rule.compactMap { v -> String? in
                if case .string(let s) = v {
                    return s
                }
                return nil
            }.joined()
        }

        let stf = Set(rules)
        var count = 0
        for m in messages {
            count += stf.contains(m) ? 1 : 0
        }

        return count
    }
}
