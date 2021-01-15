
import Foundation

struct HotNews: Codable {
    var id: String?
    var title: String?
    var preview: Preview?
    var url: String?
    var created: Int?
    var ups: Int?
    var downs: Int?
    var score: Int?
    var authorFullname: String?
    var numComments: Int?
    var after: String?
    
    var isFavorite: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id, title, preview, url, created, ups, downs, score, after
        case authorFullname = "author_fullname"
        case numComments = "num_comments"
    }
}
