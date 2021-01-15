
import Foundation

struct Image: Codable {
    var source: Source?
    
    private enum CodingKeys: String, CodingKey {
        case source
    }
}
