//
//  Recipe.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import Foundation
import CoreData

@objc(Recipe)
public class Recipe: NSManagedObject, Codable {
    @NSManaged public var title: String
    @NSManaged public var ingredients: [String]
    @NSManaged public var instructions: String

    enum CodingKeys: String, CodingKey {
        case title
        case ingredients
        case instructions
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: managedObjectContext) else {
            fatalError("Failed to decode Recipe")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        ingredients = try container.decode([String].self, forKey: .ingredients)
        instructions = try container.decode(String.self, forKey: .instructions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(instructions, forKey: .instructions)
    }
}
