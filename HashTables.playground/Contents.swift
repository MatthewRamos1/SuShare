import UIKit

var str = "Hello, playground"

var buckets = Array(repeating: 0, count: 4)

let index = abs("Alex".hashValue % buckets.count)

print(index)
