import Foundation

public class Day6Part2 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [[String]] = []


    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }

        input = str.replacingOccurrences(of: "\n\n", with: "#")
            .split(separator: "#")
            .map { String($0).split(separator: "\n").map(String.init) }
    }
}

public extension Day6Part2 {

    func solve() -> Int {
        var result = 0
        for group in input {
            let persons = group.count
            let answers = group.joined().map(Character.init).reduce(into: [Character:Int]()) { (result, char) in
                let count = result[char] ?? 0
                result[char] = count + 1
            }
            for (_, value) in answers {
                if value == persons {
                    result += 1
                }
            }
        }

        return result
    }

}
