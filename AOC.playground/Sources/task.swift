import Foundation

public class Day1Part2 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [Int] = []

    public init() {}
}

public extension Day1Part2 {

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        input = str.split(separator: "\n").compactMap { str in Int(str) }
    }

    func solve() -> Int? {
        let s = Set(input)

        for i in 0...input.count - 2 {
            for j in (i + 1)...input.count - 1 {
                let n = 2020 - input[i] - input[j]
                if s.contains(n) {
                    return input[i] * input[j] * n
                }
            }
        }

        return nil
    }
}
