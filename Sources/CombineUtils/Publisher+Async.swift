// Henrik Top Mygind, 17/06/2022

import Combine

public extension Publisher where Failure == Never {
    func async() async -> Output {
        var subscription: AnyCancellable?
        return await withCheckedContinuation { continuation in
            subscription = self.sink { value in
                continuation.resume(with: .success(value))
                subscription?.cancel()
            }
        }
    }
}
