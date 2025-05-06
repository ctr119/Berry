import Foundation
import SwiftData

enum DatabaseContainerFactory {
    static func make() -> ModelContainer {
        let schema = Schema([
            CategoryDTO.self
        ])
        let configuration = ModelConfiguration(schema: schema)
        
        do {
            return try ModelContainer(for: schema, configurations: configuration)
        } catch {
            fatalError("Couldn't create a container")
        }
    }
}
