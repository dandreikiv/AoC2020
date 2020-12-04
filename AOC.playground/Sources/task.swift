import Foundation

public class Day4Part1 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var input: [String] = []

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        let lines = str
            .replacingOccurrences(of: "\n\n", with: "#empty_line#")
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "#empty_line#", with: "\n")
            .split(separator: "\n")
        input = lines.map(String.init)
    }
}

public extension Day4Part1 {

    func solve() -> Int {
        var count = 0
        let requiredFields = Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"])
        for line in input {
            let fields = line.split(separator: " ").compactMap { field in
                field.split(separator: ":").map(String.init).first
            }
            let fieldsSet = Set(fields)
            let sub = requiredFields.subtracting(fieldsSet)
            if sub.count == 0 {
                count += 1
            } else if sub.count == 1 && sub.contains("cid") {
                count += 1
            }
        }
        return count
    }
}
