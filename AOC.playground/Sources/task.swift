import Foundation

public class Day10Part1 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [Int] = []

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        input = str.split(separator: "\n").map(String.init).compactMap(Int.init)
        print(input)
    }
}

public extension Day10Part1 {

    func solve() -> Int {
        input.sort()
        if let maxJ = input.max() {
            input.append(maxJ + 3)
        }
        print(input)

        var tmp = 0
        var stat: [Int: Int] = [:]
        for i in 0...input.count - 1 {
            let diff = input[i] - tmp
            if diff <= 3 {
                stat[diff] = (stat[diff] ?? 0) + 1
                tmp = input[i]
            }
        }
        print(stat)
        return (stat[1] ?? 0) * (stat[3] ?? 0)
    }
}
