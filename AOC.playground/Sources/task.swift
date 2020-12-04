import Foundation

public class Day4Part2 {
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

public extension Day4Part2 {

    func solve() -> Int {
        var count = 0
        for line in input {
            var passportFields: [String: String] = [:]
            line.split(separator: " ").forEach { field in
                let values = field.split(separator: ":").map(String.init)
                passportFields[values[0]] = values[1]
            }

            if validatePassport(fields: passportFields) {
                count += 1
            }
        }
        return count
    }

    func validatePassport(fields: [String: String]) -> Bool {
        guard let yearValue = fields["byr"], let year = Int(yearValue) else { return false }
        if year < 1920 || year > 2002 { return false }

        guard let iyrValue = fields["iyr"], let iyr = Int(iyrValue) else { return false }
        if iyr < 2010 || iyr > 2020 { return false }

        guard let eyrValue = fields["eyr"], let eyr = Int(eyrValue) else { return false }
        if eyr < 2020 || eyr > 2030 { return false }

        guard let hgtValue = fields["hgt"] else { return false }
        if hgtValue.contains("cm") {
            guard let cmValue = Int(hgtValue.replacingOccurrences(of: "cm", with: "")) else { return false }
            if cmValue < 150 || cmValue > 193 { return false }
        } else if hgtValue.contains("in") {
            guard let inValue = Int(hgtValue.replacingOccurrences(of: "in", with: "")) else { return false }
            if inValue < 59 || inValue > 76 { return false }
        } else {
            return false
        }

        guard let hclValue = fields["hcl"] else { return false }
        if hclValue.range(of: #"^#[0-9a-z]{6}$"#, options: .regularExpression) == nil {
            return false
        }

        guard let eclValue = fields["ecl"] else { return false }
        let eclValidValues = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
        if eclValidValues.contains(eclValue) == false { return false }

        guard let pidValue = fields["pid"] else { return false }
        if pidValue.range(of: #"^[0-9]{9}$"#, options: .regularExpression) == nil {
            return false
        }

        return true
    }
}
