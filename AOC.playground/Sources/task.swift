import Foundation

public class Day9Part2 {
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

public extension Day9Part2 {

    func solve() -> Int {
        let invalidNumber = foundInvalidNumber(preambule: 25)

        var slices: [[Int]] = []
        for i in input {
            slices.append([i])
        }
        
        var resultSlice: [Int] = []
        var slicesCount = slices.count
        while slicesCount > 1 {
            var found = false
            for i in 1...(slicesCount - 1) {
                let nextSliseCount = slices[i].count
                let index = nextSliseCount - 1
                slices[i - 1].append(slices[i][index])
                if slices[i - 1].reduce(0, +) == invalidNumber {
                    resultSlice = slices[i - 1]
                    found = true
                    break
                }
            }
            if found { break }
            slicesCount = slicesCount - 1
        }

        resultSlice.sort()
        return resultSlice.min()! + resultSlice.max()!
    }

    func foundInvalidNumber(preambule length: Int) -> Int {
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
