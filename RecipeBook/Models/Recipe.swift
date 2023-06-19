import Foundation

struct Recipe: Identifiable {
    let id: String? // Add an `id` property of type `String`
    let title: String
    let ingredients: [String]
    let instructions: String
    let imageURL: URL?
}
