import UIKit

var inputs: [String] = []
let fileURL = Bundle.main.url(forResource: "points", withExtension: "txt")
do {
    let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
    inputs = content.components(separatedBy: "\n").filter { !$0.isEmpty }
} catch {
}

struct Point {
    let name: String
    let x: Int
    let y: Int
    
    func manhattanDistance(_ x: Int, _ y: Int) -> Int {
        return abs(self.x - x) + abs(self.y - y)
    }
}

struct Node {
    var name: String
    var weight: Int
}

 let letters = "Q,W,E,R,T,Y,U,I,O,P,A,S,D,F,G,H,J,K,L,Z,X,C,V,B,N,M,QQ,WW,EE,RR,TT,YY,UU,II,OO,PP,AA,SS,DD,FF,GG,HH,JJ,KK,LL,ZZ,XX,CC,VV,BB,NN,MM".components(separatedBy: ",")
 
 let points = zip(letters, inputs).compactMap { (letter, point) -> Point? in
 let elements = point.components(separatedBy: ", ")
 if let _ = elements.first, let first = Int(elements.first!), let _ = elements.last, let last = Int(elements.last!) {
 return Point(name: letter, x: first, y: last)
 }
 
 return nil
 }
 
 let minX = points.min { point1, point2 -> Bool in
 return point1.x < point2.x
 }?.x ?? 0
 let maxX = points.max { point1, point2 -> Bool in
 return point1.x < point2.x
 }?.x ?? 0
 let minY = points.min { point1, point2 -> Bool in
 return point1.y < point2.y
 }?.y ?? 0
 let maxY = points.max { point1, point2 -> Bool in
 return point1.y < point2.y
 }?.y ?? 0
 
 let yLimit = maxY-minY + 1
 let xLimit = maxX-minX + 1
 
 var map: [[Node]] = Array(repeating: Array(repeating: Node(name: "_", weight: 0), count: xLimit), count: yLimit)
 //        let increment = 1

 for point in points {
    var currentNode = map[point.y - minY][point.x - minX]
    currentNode.name = point.name
    print(currentNode)
    map[point.y - minY][point.x - minX] = currentNode
 }
 
 print(map)

//Advent.sixthDayFirst()

