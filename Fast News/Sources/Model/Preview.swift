
import Foundation

struct Preview: Codable {
    var images: [Image]?
    
    private enum CodingKeys: String, CodingKey {
        case images
    }
}
