import Foundation

public class Day6Part1 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [String] = []

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }

        input = str.replacingOccurrences(of: "\n\n", with: "#")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "#", with: "\n")
            .split(separator: "\n")
            .map(String.init)
    }
}

public extension Day6Part1 {

    func solve() -> Int {
        var result = 0
        for str in input {
            result += Set(str.map(Character.init)).count
        }
        return result
    }

}
