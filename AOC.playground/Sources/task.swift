import Foundation

public class Day11Part2 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    // Layout 0 - floor, 1 - Empty, 2 - Occupied
    private var input: [[Character]] = []
    private var rows = 0
    private var cols = 0
    private var occupiedSeats: [(Int, Int)] = []
    private var emptySeats: [(Int, Int)] = []

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        let lines = str.split(separator: "\n").map(String.init)
        rows = lines.count
        for l in lines {
            let a = l.map(Character.init)
            cols = a.count
            input.append(a)
        }
    }
}

public extension Day11Part2 {

    func solve() -> Int {
        var layout = input
        var seatsChanged = 0

        repeat {
            seatsChanged = 0
            let a = layout
            for i in 0..<rows {
                for j in 0..<cols {
                    let num = numberOfAdjacentSeatsAt(row: i, col: j, in: a)
                    if a[i][j] == "#" && num >= 5 {
                        layout[i][j] = "L"
                        seatsChanged += 1
                    }
                    else if a[i][j] == "L" && num == 0 {
                        layout[i][j] = "#"
                        seatsChanged += 1
                    }
                }
            }
        } while seatsChanged > 0

        return countOccupiedSeatsIn(a: layout)
    }

    func traceSeatAt(row: Int, col: Int) -> Int {
        return 0
    }

    func countOccupiedSeatsIn(a: [[Character]]) -> Int {
        var count = 0
        for i in 0..<rows {
            for j in 0..<cols {
                if a[i][j] == "#" { count += 1 }
            }
        }
        return count
    }

    func numberOfAdjacentSeatsAt(row: Int, col: Int, in a: [[Character]]) -> Int {
        var count = 0

        count += traceUp(row: row, col: col, in: a) ? 1 : 0
        count += traceDown(row: row, col: col, in: a) ? 1 : 0
        count += traceLeft(row: row, col: col, in: a) ? 1 : 0
        count += traceRight(row: row, col: col, in: a) ? 1 : 0
        count += traceUpLeft(row: row, col: col, in: a) ? 1 : 0
        count += traceUpRight(row: row, col: col, in: a) ? 1 : 0
        count += traceDownLeft(row: row, col: col, in: a) ? 1 : 0
        count += traceDownRight(row: row, col: col, in: a) ? 1 : 0

        return count
    }

    func traceUp(row: Int, col: Int, in a: [[Character]]) -> Bool {
        var i = 1
        while row - i >= 0 {
            if a[row - i][col] == "L" { return false }
            if a[row - i][col] == "#" { return true }
            i = i + 1
        }
        return false
    }

    func traceDown(row: Int, col: Int, in a: [[Character]]) -> Bool {
        var i = 1
        while row + i < rows {
            if a[row + i][col] == "L" { return false }
            if a[row + i][col] == "#" { return true }
            i = i + 1
        }
        return false
    }

    func traceLeft(row: Int, col: Int, in a: [[Character]]) -> Bool {
        var i = 1
        while col - i >= 0 {
            if a[row][col - i] == "L" { return false }
            if a[row][col - i] == "#" { return true }
            i = i + 1
        }
        return false
    }

    func traceRight(row: Int, col: Int, in a: [[Character]]) -> Bool {
        var i = 1
        while col + i < cols {
            if a[row][col + i] == "L" { return false }
            if a[row][col + i] == "#" { return true }
            i = i + 1
        }
        return false
    }

    func traceUpLeft(row: Int, col: Int, in a: [[Character]]) -> Bool {
        var i = 1
        while row - i >= 0, col - i >= 0 {
            if a[row - i][col - i] == "L" { return false }
            if a[row - i][col - i] == "#" { return true }
            i = i + 1
        }
        return false
    }

    func traceUpRight(row: Int, col: Int, in a: [[Character]]) -> Bool {
        var i = 1
        while row - i >= 0, col + i < cols {
            if a[row - i][col + i] == "L" { return false }
            if a[row - i][col + i] == "#" { return true }
            i = i + 1
        }
        return false
    }

    func traceDownLeft(row: Int, col: Int, in a: [[Character]]) -> Bool {
        var i = 1
        while row + i < rows, col - i >= 0 {
            if a[row + i][col - i] == "L" { return false }
            if a[row + i][col - i] == "#" { return true }
            i = i + 1
        }
        return false
    }

    func traceDownRight(row: Int, col: Int, in a: [[Character]]) -> Bool {
        var i = 1
        while row + i < rows, col + i < cols {
            if a[row + i][col + i] == "L" { return false }
            if a[row + i][col + i] == "#" { return true }
            i = i + 1
        }
        return false
    }
}
