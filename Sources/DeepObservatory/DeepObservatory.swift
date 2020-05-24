import Foundation
import Combine

extension ObservableObject {
    
    /// Observe list elements and propagate changes to `self`.
    public func observe<T>(_ items: [T]) where T: ObservableObject & Identifiable {
        DeepObservatory.observe(items, in: self)
    }
}

public class DeepObservatory {
    
    
    /// Mapping from `id` hashes of observed objects to cancellation tokens.
    /// These have to be kept in memory to avoid premature deallocation.
    internal static var observed: [AnyHashable : AnyCancellable] = [:]
    
    private static func observe<T, S> (
        _ item: T,
        in observable: S
    ) where T: ObservableObject & Identifiable, S: ObservableObject {
        let id = AnyHashable(item.id)
        if observed.keys.contains(id) { return }
        observed[id] = item.objectWillChange.sink { _ in
            (observable.objectWillChange as! ObservableObjectPublisher).send()
        }
    }
    
    public static func observe<T, S> (
        _ items: [T],
        in observable: S
    ) where T: ObservableObject & Identifiable, S: ObservableObject {
        items.forEach { self.observe($0, in: observable) }
    }
}
