import Foundation

public class Day17Part2 {

    private let url = Bundle.main.url(forResource: "input", withExtension: "txt")
    private var cubes: [[Int]: Bool] = [:]

    public init() {
        loadInput()
    }

    func loadInput() {
        guard let url = url, let str = try? String(contentsOf: url) else {
            fatalError("Couldn't load input")
        }
        let lines = str.split(separator: "\n").map(String.init)
        var yi = 0
        for line in lines {
            for (xi, ch) in line.enumerated() {
                cubes[[xi, yi, 0, 0]] = (ch == "#") ? true : false
            }
            yi += 1
        }
    }
}

public extension Day17Part2 {

    func solve() -> Int {
        var newSpace: [[Int]: Bool] = [:]
        for _ in 1...6 {
            var arrX: [Int] = []
            var arrY: [Int] = []
            var arrZ: [Int] = []
            var arrW: [Int] = []

            for (cube,_) in cubes {
                arrX.append(cube[0])
                arrY.append(cube[1])
                arrZ.append(cube[2])
                arrW.append(cube[3])
            }

            let minX = arrX.min() ?? 0
            let maxX = arrX.max() ?? 0

            let minY = arrY.min() ?? 0
            let maxY = arrY.max() ?? 0

            let minZ = arrZ.min() ?? 0
            let maxZ = arrZ.max() ?? 0

            let minW = arrW.min() ?? 0
            let maxW = arrW.max() ?? 0

            for xi in (minX - 1)...(maxX + 1) {
                for yi in (minY - 1)...(maxY + 1) {
                    for zi in (minZ - 1)...(maxZ + 1) {
                        for wi in (minW - 1)...(maxW + 1) {
                            let c = [xi, yi, zi, wi]
                            newSpace[c] = stateForCube(a: c)
                        }
                    }
                }
            }
            cubes = newSpace
        }

        return cubes.map { $0.1 ? 1 : 0 }.reduce(0, +)
    }

    func stateForCube(a: [Int]) -> Bool {
        let x = a[0]
        let y = a[1]
        let z = a[2]
        let w = a[3]

        let isActive = cubes[a] ?? false
        var activeCount = 0
        for xi in (x - 1)...(x + 1) {
            for yi in (y - 1)...(y + 1) {
                for zi in (z - 1)...(z + 1) {
                    for wi in (w - 1)...(w + 1) {
                        if x == xi, y == yi, z == zi, w == wi { continue }
                        let v = cubes[ [xi, yi, zi, wi] ] ?? false
                        activeCount += v ? 1 : 0
                    }
                }
            }
        }

        if isActive && (activeCount == 2 || activeCount == 3) {
            return true
        }

        if (isActive == false) && (activeCount == 3) {
            return true
        }

        return false
    }
}
