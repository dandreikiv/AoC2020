import Foundation

public class Day18Part2 {

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

public extension Day18Part2 {

    // I used algorithm to convert infix to postfix
    // http://faculty.cs.niu.edu/~hutchins/csci241/eval.htm
    func solve() -> Int {
        let calc = Calculator()
        var sum = 0
        for expression in input {
            let strippedSpaces = expression.replacingOccurrences(of: " ", with: "").map(Character.init)
            sum += calc.calculate(expression: strippedSpaces)
        }
        return sum
    }
}

public class Calculator {
    enum Math: CustomDebugStringConvertible {
        case add
        case subtract
        case multiply
        case divide

        var debugDescription: String {
            switch self {
                case .add:
                    return "+"
                case .subtract:
                    return "-"
                case .multiply:
                    return "*"
                case .divide:
                    return "/"
            }
        }

        var precedence: Int {
            switch self {
                case .add:
                    return 2
                default:
                    return 1
            }
        }
    }

    enum Ops: Equatable, CustomDebugStringConvertible {
        case number(Int)
        case operation(Math)
        case leftParenthesis
        case rightParenthesis

        var debugDescription: String {
            switch self {
                case .number(let number):
                    return "\(number)"
                case .operation(let op):
                    return op.debugDescription
                case .leftParenthesis:
                    return "("
                case .rightParenthesis:
                    return ")"
            }
        }
    }

    func parse(expression: [Character]) -> [Ops] {
        var result: [Ops] = []
        var numberStack: [Int] = []

        for ch in expression {
            if let n = Int("\(ch)") {
                numberStack.append(n)
            } else {
                if numberStack.isEmpty == false {
                    let number = numberStack.reduce(0) { $0 * 10 + $1 }
                    result.append(.number(number))
                    numberStack = []
                }
                if ch == "+" { result.append(.operation(.add)) }
                if ch == "-" { result.append(.operation(.subtract)) }
                if ch == "*" { result.append(.operation(.multiply)) }
                if ch == "/" { result.append(.operation(.divide)) }
                if ch == "(" { result.append(.leftParenthesis) }
                if ch == ")" { result.append(.rightParenthesis) }
            }
        }

        if numberStack.isEmpty == false {
            let number = numberStack.reduce(0) { $0 * 10 + $1 }
            result.append(.number(number))
            numberStack = []
        }

        return result
    }

    func calculate(expression: [Character]) -> Int {
        let opsArr = parse(expression: expression)
        let postfix = convertToPostfix(ops: opsArr)

        return calculatePostfix(postfix)
    }

    func convertToPostfix(ops: [Ops]) -> [Ops] {
        var result: [Ops] = []
        var stack: [Ops] = []
        for op in ops {
            if case .number(_) = op {
                result.append(op)
            }
            if case .leftParenthesis = op {
                stack.insert(.leftParenthesis, at: 0)
            }
            if case .rightParenthesis = op {
                while stack.isEmpty == false && (stack[0] != .leftParenthesis) {
                    let element = stack.removeFirst()
                    result.append(element)
                }
                _ = stack.removeFirst()
            }
            if case .operation(let m) = op {
                if stack.isEmpty || (stack[0] == .leftParenthesis) {
                    stack.insert(op, at: 0)
                } else {
                    while stack.isEmpty == false && stack[0] != .leftParenthesis {
                        if case .operation(let m1) = stack[0], m.precedence > m1.precedence {
                            break
                        }
                        let element = stack.removeFirst()
                        result.append(element)
                    }
                    stack.insert(op, at: 0)
                }
            }
        }

        while stack.isEmpty == false {
            let element = stack.removeFirst()
            result.append(element)
        }
        
        return result
    }

    func calculatePostfix(_ ops: [Ops]) -> Int {
        var stack: [Ops] = []
        for op in ops {
            if case .number(_) = op {
                stack.insert(op, at: 0)
            }
            if case .operation(let math) = op {
                if case .number(let left) = stack.removeFirst(),
                   case .number(let right) = stack.removeFirst()
                {
                    let value = performOperation(math, left: left, right: right)
                    stack.insert(.number(value), at: 0)
                }
            }
        }
        if case .number(let result) = stack[0] {
            return result
        }
        return -1
    }

    func performOperation(_ op: Math, left: Int, right: Int) -> Int {
        switch op {
            case .add:
                return left + right
            case .subtract:
                return left - right
            case .multiply:
                return left * right
            case .divide:
                return left / right
        }
    }
}
