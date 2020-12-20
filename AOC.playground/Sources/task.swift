import Foundation

public class Day14Part2 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var data: [String] = []
    private var memory: [UInt: UInt] = [:]
    private let const: UInt = 68719476735 // 2 ^ 36 - 1

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        data = str.split(separator: "\n").map(String.init)
    }
}

public extension Day14Part2 {

    func solve() -> UInt {
        var mask: [Character] = []
        for ins in data {
            if ins.contains("mask") {
                mask = ins.split(separator: "=").map(String.init)[1].trimmingCharacters(in: .whitespacesAndNewlines).map(Character.init)
            } else if ins.contains("mem") {
                let parts = ins.split(separator: "=").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                let value = UInt(parts[1])!
                let adrs = UInt(parts[0].replacingOccurrences(of: "mem[", with: "").replacingOccurrences(of: "]", with: ""))!
                let addresses = calculateAddresses(for: adrs, using: mask)
                for a in addresses {
                    memory[a] = value
                }
            }
        }

        return memory.map { $0.1 }.reduce(0, +)
    }

    func calculateAddresses(for address: UInt, using mask: [Character]) -> [UInt] {
        var result: [UInt] = []
        var flexIdx: [UInt] = []
        var value = address
        var idx = 0
        for (i, c) in mask.enumerated().reversed() {
            if c == "X" {
                flexIdx.append(35 - UInt(i))
                value |= (1 << idx)
            } else if c == "1" {
                value |= (1 << idx)
            }
            idx += 1
        }

        result = [value]

        for i in flexIdx {
            var t: [UInt] = []
            for addr in result {
                t.append(addr & (const - (1 << i))) // X with 0
                t.append(addr | (1 << i)) // X with 1
            }
            result = t
        }

        return result
    }
}
