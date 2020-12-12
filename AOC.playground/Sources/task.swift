import Foundation

public class Day12Part1 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [String] = []
    private var directions: [Character: Int] = ["E": 0, "S": 0, "W": 0, "N": 0]
    private var angle = 0

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

public extension Day12Part1 {

    func solve() -> Int {
        for d in input {
            let instruction = d.first!
            let value = Int(d.replacingOccurrences(of: String(instruction), with: ""))!
            switch instruction {
                case "L":
                    angle = angle - value
                case "R":
                    angle = angle + value
                case "F":
                    if let d = directionForAngle(angle: angle) {
                        let acc = directions[d] ?? 0
                        directions[d] = value + acc
                    }
                default:
                    let acc = directions[instruction] ?? 0
                    directions[instruction] = value + acc
            }

        }
        let verticalDistance = abs(directions["S"]! - directions["N"]!)
        let horizontalDistance = abs(directions["E"]! - directions["W"]!)
        return verticalDistance + horizontalDistance
    }

    func directionForAngle(angle: Int) -> Character? {
        var a = angle % 360
        if a < 0 { a = a + 360 }

        if a == 0 { return "E" }
        if a == 90 { return "S" }
        if a == 180 { return "W" }
        if a == 270 { return "N" }
        return nil
    }
}
