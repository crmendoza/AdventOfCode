import UIKit

var inputs: [String] = []
let fileURL = Bundle.main.url(forResource: "polymer", withExtension: "txt")
do {
    let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
    inputs = content.components(separatedBy: "\n").filter { !$0.isEmpty }
} catch {
}



//repeating character & alternating case

let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
let units = letters.map { $0+$0.uppercased() } + letters.map { $0.uppercased()+$0 }
if let polymer = inputs.first {
    var polymer = polymer
    var lastStringCount = -1
    while polymer.count != lastStringCount {
        lastStringCount = polymer.count
        for str in units {
            polymer = polymer.replacingOccurrences(of: str, with: "")
        }
    }
    print(polymer)
    print(polymer.count)
}


let smallUnits = letters.map { $0+$0 }
var resultingLength: [Int] = [0]

if let polymer = inputs.first {
    
    var polymer = polymer
    var lastStringCount = -1
    while polymer.count != lastStringCount {
        lastStringCount = polymer.count
        for str in units {
            polymer = polymer.replacingOccurrences(of: str, with: "")
        }
    }
}
