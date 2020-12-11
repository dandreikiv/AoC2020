import Foundation

public class Day11Part1 {
    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    // Layout 0 - floor, 1 - Empty, 2 - Occupied
    private var input: [[Character]] = []
    private var rows = 0
    private var cols = 0

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

public extension Day11Part1 {

    func solve() -> Int {
        var layout = input
        var seatsChanged = 0
        repeat {
            seatsChanged = 0
            let a = layout
            for i in 0..<rows {
                for j in 0..<cols {
                    let num = numberOfAdjacentSeatsAt(row: i, col: j, in: a)
                    if a[i][j] == "#" && num >= 4 {
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
        // Up
        if row - 1 >= 0, a[row - 1][col] == "#" { count += 1 }
        // Down
        if row + 1 < rows, a[row + 1][col] == "#" { count += 1 }
        // Left
        if col - 1 >= 0, a[row][col - 1] == "#" { count += 1 }
        // Right
        if col + 1 < cols, a[row][col + 1] == "#" { count += 1 }
        // Diagonal up-left
        if row - 1 >= 0, col - 1 >= 0, a[row - 1][col - 1] == "#" { count += 1 }
        // Diagonal up-right
        if row - 1 >= 0, col + 1 < cols, a[row - 1][col + 1] == "#" { count += 1 }
        // Diagonal down-left
        if row + 1 < rows, col - 1 >= 0, a[row + 1][col - 1] == "#" { count += 1 }
        // Diagonal down-right
        if row + 1 < rows, col + 1 < cols, a[row + 1][col + 1] == "#" { count += 1 }

        return count
    }
}
