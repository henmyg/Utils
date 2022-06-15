// Henrik Top Mygind, 09/06/2022

import Foundation

public struct Weak<TValue: AnyObject> {
    public init(_ value: TValue) {
        self.value = value
    }
    
    public weak var value: TValue?
}
