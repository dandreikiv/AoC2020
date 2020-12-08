import Foundation

public class Day8Part2 {
    public enum ExitCode {
        case loop(acc: Int)
        case completed(acc: Int)
        case unknown
    }

    public struct Instruction: CustomDebugStringConvertible {
        enum Operation: String {
            case nop
            case jmp
            case acc
        }
        let type: Operation
        let offset: Int

        public var debugDescription: String {
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

public extension Day8Part2 {

    func solve() -> Int {
        var program = input
        var updated = false

        for i in 0...(program.count - 1) {
            let command = program[i]

            if program[i].type == .nop {
                program[i] = .init(type: .jmp, offset: command.offset)
                updated = true
            } else if program[i].type == .jmp {
                program[i] = .init(type: .nop, offset: command.offset)
                updated = true
            }

            if updated {
                let result = executeProgram(commands: program)
                switch result {
                    case .completed(let acc):
                        return acc
                    case .loop:
                        updated = false
                        program = input
                    case .unknown:
                        break
                }
            }
        }

        return -1
    }

    func executeProgram(commands: [Instruction]) -> ExitCode {
        var executedCommands: [Int] = []
        var acc = 0
        var pointer = 0
        var command = commands[pointer]
        var result: ExitCode = .unknown
        while true {
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
            if pointer >= commands.count {
                result = .completed(acc: acc)
                break
            }
            if executedCommands.contains(pointer) {
                result = .loop(acc: acc)
                break
            }
            command = commands[pointer]
        }
        return result
    }
}
