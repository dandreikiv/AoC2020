import Foundation

public class Day14Part1 {
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

public extension Day14Part1 {

    func solve() -> UInt {
        var mask: [Character] = []
        for ins in data {
            if ins.contains("mask") {
                mask = ins.split(separator: "=").map(String.init)[1].trimmingCharacters(in: .whitespacesAndNewlines).map(Character.init)
            } else if ins.contains("mem") {
                let parts = ins.split(separator: "=").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                let value = UInt(parts[1])!
                let address = UInt(parts[0].replacingOccurrences(of: "mem[", with: "").replacingOccurrences(of: "]", with: ""))!
                write(value: value, to: address , using: mask)
            }
        }

        for (k, v) in memory {
            print("mem[\(k)] = \(v)")
        }

        return memory.map { $0.1 }.reduce(0, +)
    }

    func write(value: UInt, to address: UInt, using mask: [Character]) {
        var r: UInt = value
        var t: UInt = 1
        for el in mask.reversed() {
            if el == "0" {
                r = r & (const - t)
            } else if el == "1" {
                r = r | t
            }
            t = t * 2
        }
        memory[address] = r
    }
}
