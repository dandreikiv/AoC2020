import Foundation

public class Day7Part1 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [String] = []
    private var data: [String: [String]] = [:]

    public init() {
        loadInput()
        prepareData()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        input = str
            .replacingOccurrences(of: "contain", with: ":")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "no other", with: "")
            .replacingOccurrences(of: "[0-9]*", with: "", options: .regularExpression)
            .replacingOccurrences(of: "bag[s]?", with: "", options: .regularExpression)
            .split(separator: "\n")
            .map(String.init)
    }

    func prepareData() {
        var bagRules: [String: [String]] = [:]
        for str in input {
            let rule = str.split(separator: ":")
            let bagColor = rule[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let content = rule[1].split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }

            var bags = bagRules[bagColor] ?? []
            bags.append(contentsOf: content)
            bagRules[bagColor] = bags
        }

        data = bagRules
    }
}

public extension Day7Part1 {

    func solve() -> Int {
        var result = 0
        for (key, _) in data {
            if traverse(color: key) {
                result += 1
            }
        }
        return result
    }

    func traverse(color: String) -> Bool {
        guard let bugs = data[color] else { return false }

        if bugs.contains("shiny gold") {
            return true
        }

        var result = false
        for color in bugs {
            result = result || traverse(color: color)
        }

        return result
    }
}
