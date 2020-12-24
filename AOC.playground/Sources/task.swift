import Foundation

public class Day17Part1 {

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
                cubes[[xi, yi, 0]] = (ch == "#") ? true : false
            }
            yi += 1
        }

        cubes.forEach { print($0) }
    }
}

public extension Day17Part1 {

    func solve() -> Int {
        var newSpace: [[Int]: Bool] = [:]
        for cycle in 1...6 {
            print("========================================")
            print("cycle: \(cycle)")
            print("========================================")
            var arrX: [Int] = []
            var arrY: [Int] = []
            var arrZ: [Int] = []

            for (cube,_) in cubes {
                arrX.append(cube[0])
                arrY.append(cube[1])
                arrZ.append(cube[2])
            }

            let minX = arrX.min() ?? 0
            let maxX = arrX.max() ?? 0

            let minY = arrY.min() ?? 0
            let maxY = arrY.max() ?? 0

            let minZ = arrZ.min() ?? 0
            let maxZ = arrZ.max() ?? 0

            for xi in (minX - 1)...(maxX + 1) {
                for yi in (minY - 1)...(maxY + 1) {
                    for zi in (minZ - 1)...(maxZ + 1) {
                        let c = [xi, yi, zi]
                        newSpace[c] = stateForCube(a: c)
                    }
                }
            }
            cubes = newSpace
            var count = 0

            let zArr = cubes.map { ($0.0[2] ) }
            let zMin = zArr.min() ?? 0
            let zMax = zArr.max() ?? 0
            for z in zMin...zMax {
                printLayer(z: z)
            }

            for (_, isActive) in cubes {
                if isActive {
                    count += 1
                }
            }

            print("cycle: \(cycle)", "count: \(count)")
        }

        return 0
    }

    func stateForCube(a: [Int]) -> Bool {
        let x = a[0]
        let y = a[1]
        let z = a[2]

        let isActive = cubes[a] ?? false
        var activeCount = 0
        for xi in (x - 1)...(x + 1) {
            for yi in (y - 1)...(y + 1) {
                for zi in (z - 1)...(z + 1) {
                    if x == xi, y == yi, z == zi { continue }
                    let v = cubes[ [xi, yi, zi] ] ?? false
                    activeCount += v ? 1 : 0
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

    func printLayer(z: Int) {
        print("========== layer z: \(z) ==========")
        let zminus1 = cubes.filter { (element) -> Bool in element.key[2] == z }
        let xArr = zminus1.map { $0.0[0] }.sorted()
        let yArr = zminus1.map { $0.0[1] }.sorted()
        let xMin = xArr.min() ?? 0
        let xMax = xArr.max() ?? 0
        let yMin = yArr.min() ?? 0
        let yMax = yArr.max() ?? 0
        for y in (yMin - 1)...(yMax + 1) {
            var s = ""
            for x in (xMin - 1)...(xMax + 1) {
                let cube = [x, y, z]
                let isActive = cubes[ cube ] ?? false
                s = s + (isActive ? "#" : "." )
            }
            print(s)
        }
    }
}
