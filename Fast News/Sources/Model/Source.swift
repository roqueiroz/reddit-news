
import Foundation

struct Source: Codable {
    var url: String?
    
    private enum CodingKeys: String, CodingKey {
        case url
    }
}
