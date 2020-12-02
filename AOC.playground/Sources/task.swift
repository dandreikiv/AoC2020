import Foundation

public struct Range {
    let min: Int
    let max: Int
}

public struct PassPolicy {
    let range: Range
    let char: Character
    let password: String
}

public class Day2Part1 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [PassPolicy] = []

    public init() {}
}

public extension Day2Part1 {

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        let lines = str.split(separator: "\n")
        input = lines.compactMap { line in
            let components = line.split(separator: " ").map { s in
                s.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            assert(components.count == 3, "wrong input")

            guard let range = parseRange(string: components[0]) else {
                assertionFailure("Couldn't parse range")
                return nil
            }

            guard let char = parseChar(string: components[1]) else {
                assertionFailure("Couldn't parse char")
                return nil
            }

            let password = components[2]

            return PassPolicy(range: range, char: char, password: password)
        }
    }

    func parseRange(string: String) -> Range? {
        let r = string.split(separator: "-")
        assert(r.count == 2, "wrong range format")

        guard let min = Int(r[0]), let max = Int(r[1]) else { return nil }
        return Range(min: min, max: max)
    }

    func parseChar(string: String) -> Character? {
        return string.map(Character.init).first
    }

    func solve() -> Int {
        var count = 0
        for p in input {
            if validate(password: p) {
                count += 1
            }
        }
        return count
    }

    func validate(password: PassPolicy) -> Bool {
        var charsMap: [Character: Int] = [:]

        for char in password.password {
            let count = charsMap[char] ?? 0
            charsMap[char] = count + 1
        }

        guard let count = charsMap[password.char] else { return false }

        return count >= password.range.min && count <= password.range.max
    }
}
