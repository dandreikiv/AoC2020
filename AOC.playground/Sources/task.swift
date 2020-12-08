import Foundation

public class Day8Part1 {
    struct Instruction: CustomDebugStringConvertible {
        enum Operation: String {
            case nop
            case jmp
            case acc
        }
        let type: Operation
        let offset: Int

        var debugDescription: String {
            return "type: \(type.rawValue), offset: \(offset)"
        }
    }
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [Instruction] = []

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        input = str.split(separator: "\n").map { inst in
            let parts = inst.split(separator: " ").map(String.init)
            let operation = Instruction.Operation(rawValue: parts[0])!
            let offset = Int(parts[1])!
            return Instruction(type: operation, offset: offset)
        }
    }
}

public extension Day8Part1 {

    func solve() -> Int {
        var executedCommands: [Int] = []
        var acc = 0
        var pointer = 0
        var command = input[pointer]
        while executedCommands.contains(pointer) == false {
            switch command.type {
                case .nop:
                    pointer += 1
                case .jmp:
                    executedCommands.append(pointer)
                    pointer += command.offset
                case .acc:
                    executedCommands.append(pointer)
                    acc += command.offset
                    pointer += 1
            }
            command = input[pointer]
        }
        return acc
    }
}
