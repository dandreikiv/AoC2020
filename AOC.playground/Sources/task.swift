import Foundation

public class Day10Part2 {
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
//        print(input)
    }
}

public extension Day10Part2 {

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

        var pathMem: [Int: Int] = [:]
        let dict = prepare(array: [0] + input)
        let count = traverse(dict: dict, start: 0, pathMem: &pathMem)
        print(count)

        return (stat[1] ?? 0) * (stat[3] ?? 0)
    }

    func prepare(array a: [Int]) -> [Int: [Int]] {
        print(a)
        var dict: [Int: [Int]] = [:]
        for i in 0...a.count - 2 {
            var j = i + 1
            var list: [Int] = []
            dict[a[i]] = list
            while j < a.count && a[j] - a[i] <= 3  {
                list.append(a[j])
                j = j + 1
            }
            dict[a[i]] = list
        }
        return dict
    }

    func traverse(dict: [Int: [Int]], start: Int, pathMem: inout [Int: Int]) -> Int {
        var count = 0

        if let pathCount = pathMem[start] { return pathCount }

        if let a = dict[start] {
            for key in a {
                count += traverse(dict: dict, start: key, pathMem: &pathMem)
            }
            pathMem[start] = count
        } else {
            return 1
        }
        return count
    }
}
