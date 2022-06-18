// Henrik Top Mygind, 17/06/2022

import Foundation
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
    
    func async(timeout: DispatchQueue.SchedulerTimeType.Stride) async -> Output? {
        var subscriptions = Set<AnyCancellable>()
        return await withCheckedContinuation { continuation in

            // SUCCESS
            self.sink{ value in
                continuation.resume(with: .success(value))
                for s in subscriptions { s.cancel() }
            }.store(in: &subscriptions)
            
            // TIMEOUT
            Just<Void>(())
                .delay(for: timeout, scheduler: DispatchQueue.main)
                .sink { _ in
                    continuation.resume(with: .success(nil))
                    for s in subscriptions { s.cancel() }
                }
                .store(in: &subscriptions)
        }
    }
}
