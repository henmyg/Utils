// Henrik Top Mygind, 18/06/2022

import Foundation

public extension Double {
    var inMili: Double { self * 1_000.0}
    var inMicro: Double { self * 1_000_000.0}
    var inNano: Double { self * 1_000_000_000.0}
}
