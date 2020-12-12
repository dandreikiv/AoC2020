import Foundation

public class Day12Part2 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [String] = []

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        input = str.split(separator: "\n").map(String.init)
    }
}

public extension Day12Part2 {

    func solve() -> Int {
        var wx = 10, wy = 1
        var sx = 0, sy = 0
        for d in input {
            let ins = d.first!
            let value = Int(d.replacingOccurrences(of: String(ins), with: ""))!

            if ins == "F" {
                sx = sx + wx * value
                sy = sy + wy * value
            }
            else if ins == "R" {
                if value == 90 { let t = wx; wx = wy; wy = -t }
                else if value == 180 { wx = -wx; wy = -wy }
                else if value == 270 { let t = wx; wx = -wy; wy = t }
            }
            else if ins == "L" {
                if value == 90 { let t = wx; wx = -wy; wy = t }
                else if value == 180 { wx = -wx; wy = -wy }
                else if value == 270 { let t = wx; wx = wy; wy = -t }
            }
            else if ins == "S" { wy = wy - value }
            else if ins == "N" { wy = wy + value }
            else if ins == "E" { wx = wx + value }
            else if ins == "W" { wx = wx - value }
        }

        return abs(sx) + abs(sy)
    }
}
