import Foundation

public class Day9Part1 {
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

public extension Day9Part1 {

    func solve() -> Int {
        let length = 25
        var result = 0

        for i in length..<input.count {
            let preambule = input[(i - length)..<i]
            var found = false
            for p in preambule {
                let diff = input[i] - p
                if preambule.contains(diff) {
                    found = true
                    break
                }
            }

            if found == false {
                result = input[i]
            }
        }

        return result
    }
}
