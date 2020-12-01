import Foundation

public class Day1Part1 {
    public let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    public var input: [Int] = []

    public init() {}

    public func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        input = str.split(separator: "\n").compactMap { str in Int(str) }
    }

    public func solve() -> Int? {
        let s = Set(input)
        for i in input {
            let n = 2020 - i
            if s.contains(n) {
                return (n * i)
            }
        }
        return nil
    }
}
