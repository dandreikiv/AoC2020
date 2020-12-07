import Foundation

public class Day7Part2 {
    struct Content: CustomDebugStringConvertible {
        let color: String
        let amount: Int

        var debugDescription: String {
            return "color: \(color), amount: \(amount)"
        }
    }
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [String] = []
    private var data: [String: [Content]] = [:]

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
            .replacingOccurrences(of: "bag[s]?", with: "", options: .regularExpression)
            .split(separator: "\n")
            .map(String.init)
    }

    func prepareData() {
        var bagRules: [String: [Content]] = [:]
        for str in input {
            let rule = str.split(separator: ":")
            let bagColor = rule[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let content = rule[1].split(separator: ",").compactMap { str -> Content? in
                if let amountRange = str.range(of: "\\d+", options: .regularExpression) {
                    let amount = Int(str[amountRange])!
                    let bagColor = str[amountRange.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)
                    let bagContent = Content(color: bagColor, amount: amount)
                    return bagContent
                }
                return nil
            }

            var bags = bagRules[bagColor] ?? []
            bags.append(contentsOf: content)
            bagRules[bagColor] = bags
        }
        data = bagRules
    }
}

public extension Day7Part2 {

    func solve() -> Int {
        return traverse(color: "shiny gold")
    }

    func traverse(color: String) -> Int {
        guard let bags = data[color], !bags.isEmpty else { return 0 }

        var count = 0
        for bag in bags {
            count += bag.amount + bag.amount * traverse(color: bag.color)
        }

        return count
    }
}
