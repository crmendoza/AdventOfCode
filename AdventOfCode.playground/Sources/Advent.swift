import Foundation

class Advent {
    
    static func firstDayApplyFrequencies() -> Int {
        return fetchDataSet("filename").compactMap { Int($0) }.reduce(0, +)
    }
    
    static func firstDayDuplicateFrequency() -> Int {
        var resultingFrequencies: Set = [0]
        var currentValue: Int = 0
        var duplicateValue: Int!
        let changeArray = fetchDataSet("input").compactMap { Int($0) }
        while duplicateValue == nil {
            for val in changeArray {
                currentValue = currentValue + val
                if resultingFrequencies.contains(currentValue) {
                    duplicateValue = currentValue
                    break
                }
                resultingFrequencies.insert(currentValue)
            }
        }
        
        return duplicateValue
    }
    
    static func secondDayHashCode() -> Int {
        let codes: [String] = fetchDataSet("codes")
        
        var match2LetterRule: Int = 0
        var match3LetterRule: Int = 0
        
        for code in codes {
            var letterCounts: [Character: Int] = [:]
            for letter in code {
                letterCounts[letter, default: 0] += 1
            }
            
            if letterCounts.values.contains(2) {
                match2LetterRule += 1
            }
            
            if letterCounts.values.contains(3) {
                match3LetterRule += 1
            }
        }
        
        return match2LetterRule * match3LetterRule
    }
    
    static func secondDayCommonBoxCode() -> String {
        let codes: [String] = fetchDataSet("codes")
        
        for i in 0..<codes.count {
            for j in i+1..<codes.count {
                let zipped = zip(codes[i], codes[j])
                let difference = zipped.filter { $0 !=  $1 }
                if difference.count ==  1 {
                    let filtered: [String] = zipped.filter { $0 ==  $1 }.compactMap { String($0.0) }
                    return filtered.joined()
                }
            }
        }
        
        return ""
    }
    
    static func thirdDayFabricArea() -> Int {
        let claims = fetchDataSet("pattern").compactMap { $0.components(separatedBy: CharacterSet(charactersIn: "#@:,x ")).filter { !$0.isEmpty }.compactMap { Int($0) } }
        var fabric = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
        for square in claims {
            for x in square[1]..<(square[1]+square[3]) {
                for y in square[2]..<(square[2]+square[4]) {
                    fabric[x][y] += 1
                }
            }
        }
        
        return fabric.joined().filter { $0 > 1}.count
    }
    
    static func thirdDayFabricNoOverlap() -> Int {
        let claims = fetchDataSet("pattern").compactMap { $0.components(separatedBy: CharacterSet(charactersIn: "#@:,x ")).filter { !$0.isEmpty }.compactMap { Int($0) } }
        var ids = Set(claims.compactMap { $0[0] })
        
        for i in 0..<claims.count {
            for j in i+1..<claims.count {
                let claim1 = claims[i]
                let claim2 = claims[j]
                let areaOfIntersection = max(0,
                                             min(claim1[1] + claim1[3], claim2[1]+claim2[3]) - max(claim1[1], claim2[1])) *
                    max(0,
                        min(claim1[2] + claim1[4], claim2[2]+claim2[4]) - max(claim1[2], claim2[2]))
                
                if areaOfIntersection > 0 {
                    ids.remove(claim1[0])
                    ids.remove(claim2[0])
                }
            }
        }
        
        return ids.first ?? 0
    }
    
    static func fourthDay() -> (firstStrategy: Int, secondStrategy: Int) {
        let inputs = fetchDataSet("schedule").sorted()
        
        var schedules: [String: [Int]] = [:]
        var currentGuard: String!
        var i = 0
        
        while i < inputs.count {
            let currentEntry = inputs[i]
            if currentEntry.contains("Guard") {
                currentGuard = getGuardId(currentEntry)
                i += 1
            } else {
                guard i+1 < inputs.count else { break }
                let nextEntry = inputs[i+1]
                var shift = schedules[currentGuard] ?? Array(repeating: 0, count: 60)
                for j in getSeconds(currentEntry)..<getSeconds(nextEntry) {
                    shift[j] += 1
                }
                schedules[currentGuard] = shift
                i += 2
            }
        }
        
        var firstResult: Int = 0
        var  secondResult: Int = 0
        
        if let combo = (schedules.map { (id: $0, totalTime: $1.reduce(0, +)) }.max { $0.1 < $1.1 }), let schedule = schedules[combo.id] {
            firstResult = Int(combo.id)! * schedule.firstIndex(of: schedule.max()!)!
        }
        
        let mappedValues = schedules.mapValues { (timeArray: [Int]) -> (minute: Int, frequency: Int) in
            let max = timeArray.max()!
            let index = timeArray.firstIndex(of: max)!
            return (minute: index, frequency: max)
        }
        
        if let newCombo = (mappedValues.max { $0.1.frequency < $1.1.frequency }), let id = Int(newCombo.key) {
            secondResult = id * newCombo.value.minute
        }
        
        return (firstStrategy: firstResult, secondStrategy: secondResult)
    }
    
    private static func getGuardId(_ input: String) -> String {
        let guardRegex = try? NSRegularExpression(pattern: "#[0-9]+", options: .caseInsensitive)
        let string = input as NSString
        return guardRegex?.matches(in: input, options: [], range: NSRange(location: 0, length: string.length))
            .map { string.substring(with: $0.range).replacingOccurrences(of: "#", with: "") }
            .compactMap { $0 }.first ?? ""
    }
    
    private static func getSeconds(_ input: String) -> Int {
        let secondRegex = try? NSRegularExpression(pattern: ":[0-9]{2}", options: .caseInsensitive)
        let string = input as NSString
        let match = secondRegex?.matches(in: input, options: [], range: NSRange(location: 0, length: string.length)).compactMap { string.substring(with: $0.range).replacingOccurrences(of: ":", with: "") }
        return Int(match?.first ?? "0") ?? 0
    }
    
    private static func fetchDataSet(_ filename: String) -> [String] {
        let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt")
        do {
            let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n").filter { !$0.isEmpty }
        } catch {
            return []
        }
    }
}
