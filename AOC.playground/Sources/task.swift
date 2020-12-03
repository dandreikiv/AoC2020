import Foundation

public class Day3Part2 {
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

    func treesForSlope(right: Int, down: Int) -> Int {
        var result = 0
        var x = 0
        var y = 0
        var pos = 0

        while y < rows && pos < input.count {
            x = x + right
            y = y + down

            if x >= cols { x = x % cols }

            pos = x + y * cols
            if pos >= input.count { break }
            result += input[pos] == "#" ? 1 : 0
        }
        return result
    }
}

public extension Day3Part2 {

    func solve() -> Int {
        var result = 1
        let slopes: [(right: Int, down: Int)] = [
            (right: 1, down: 1),
            (right: 3, down: 1),
            (right: 5, down: 1),
            (right: 7, down: 1),
            (right: 1, down: 2),
        ]

        for slope in slopes {
            let count = treesForSlope(right: slope.right, down: slope.down)
            result *= count
        }

        return result
    }
}
