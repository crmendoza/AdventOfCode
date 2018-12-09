import UIKit

var inputs: [String] = []
let fileURL = Bundle.main.url(forResource: "schedule", withExtension: "txt")
do {
    let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
    inputs = content.components(separatedBy: "\n").filter { !$0.isEmpty }
} catch {
}

//repeating character & alternating case

