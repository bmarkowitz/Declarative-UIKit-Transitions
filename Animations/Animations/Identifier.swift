import UIKit

// An object that allows us to keep track of views involved in a transition
struct Identifier: Equatable {
    var view: UIView
    var sharedView: UIView? // Only present for a shared element transition
    var transitionIdentifier: String
}

// An object that represents the results of a diff of 2 identifier hierarchies
struct IdentifierDiff {
    var shared: [Identifier] = []
    var removed: [Identifier] = []
    var inserted: [Identifier] = []
}

extension Array where Element == Identifier {
    func diffed(with source: [Element]) -> IdentifierDiff {
        var identifierDiff = IdentifierDiff()

        for identifier in source {
            if let destinationIdentifier = self.first(where: { $0.transitionIdentifier == identifier.transitionIdentifier }) {
                // Exists in source & destination -> shared element
                var sharedIdentifier = identifier

                // Create a new Identifier, in order to store the shared view
                // Which is the view as it exists in the destination
                sharedIdentifier.sharedView = destinationIdentifier.view
                identifierDiff.shared.append(sharedIdentifier)
            }
            else {
                // DNE in destination -> removal
                identifierDiff.removed.append(identifier)
            }
        }

        for identifier in self {
            guard source.contains(where: { $0.transitionIdentifier == identifier.transitionIdentifier }) == false
            else { continue }

            // DNE in source -> insertion
            identifierDiff.inserted.append(identifier)
        }

        return identifierDiff
    }
}
