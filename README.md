# DeepObservatory

Effortlessly propagate ObservableObject changes within a published list.

Works transparently in the background and avoids dirty workarounds like `ObservableArray` that require large refactorings afterwards.

## Installation

Add the following repository using Swift Package Manager:
```
https://github.com/Quintschaf/DeepObservatory.git
```

## Usage

```swift
import DeepObservatory

class World: ObservableObject {
    @Published var people: [Person] = [] {
        didSet { self.observe(people) } // magic
    }
}

class Person: ObservableObject, Identifiable {
    @Published var id = UUID()
    @Published var name: String
    @Published var age: Int
}
```

Usually, changes to a `Person` in `people` would not trigger an update on either `people` or  `World`.<br>
DeepObservatory takes care of observing and propagating these changes with minimal effort.

### Restrictions
DeepObservatory can only observe lists of objects implementing `ObservableObject & Identifiable`.
