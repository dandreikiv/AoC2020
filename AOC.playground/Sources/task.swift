import Foundation

public class Day15Part1 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var data: [Int] = []

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        data = str.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }.compactMap(Int.init)
    }
}

public extension Day15Part1 {

    func solve() -> Int {
        print(data)
        var turns: [Int: [Int]] = [:]
        for (i, d) in data.enumerated() {
            turns[d] = [i + 1]
        }
        var last = data[data.count - 1]
        var turn = data.count + 1
        while turn <= 30000000 {
            if let t = turns[last] {
                let newNumber = t.count >= 2 ? t[t.count - 1] - t[t.count - 2] : 0

                if let tn = turns[newNumber] {
                    turns[newNumber] = [tn.last!, turn]
                } else {
                    turns[newNumber] = [turn]
                }

                last = newNumber
            } else {
                last = 0
                turns[last] = [turn]
            }
            turn = turn + 1
        }

        return last
    }
}
