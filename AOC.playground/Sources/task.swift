import Foundation

public class Day3Part1 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [Character] = []
    private var rows: Int = 0
    private var cols: Int = 0

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        let lines = str.split(separator: "\n")
        cols = lines.first?.count ?? 0
        rows = lines.count

        input = lines.flatMap { s in s.map(Character.init) }
    }
}

public extension Day3Part1 {

    func solve() -> Int {
        let stepRight = 3
        let stepDown = 1
        var result = 0
        var x = 0
        var y = 0
        var pos = 0

        while y < rows && pos < input.count {
            x = x + stepRight
            y = y + stepDown

            if x >= cols { x = x % cols }

            pos = x + y * cols
            if pos >= input.count { break }
            result += input[pos] == "#" ? 1 : 0
        }
        return result
    }
}
