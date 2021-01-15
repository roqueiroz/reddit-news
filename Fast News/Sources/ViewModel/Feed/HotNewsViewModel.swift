
import Foundation
import UIKit

struct HotNewsViewModel {
    
    //MARK: - Properties
    
    var id: String
    var author: String
    var createdAt: String
    var title: String
    var comments: String
    var score: String
    var url: String
    var image: UIImage
    var isFavorite: Bool = false
    var after: String
    
    init(hotNews: HotNews) {
        id = hotNews.id ?? ""
        author = hotNews.authorFullname ?? ""
        createdAt = hotNews.created?.createdAt ?? ""
        title = hotNews.title ?? ""
        comments = hotNews.numComments?.toString ?? ""
        score = hotNews.score?.toString ?? ""
        url = hotNews.url ?? ""
        image = UIImage()
        after = hotNews.after ?? ""
        
        // preview url
        let previewUrl = hotNews.preview?.images?.first?.source?.url?.htmlDecoded ?? ""
        guard let url = URL(string: previewUrl) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        image = UIImage(data: data) ?? UIImage()
    }
    
    init() {
        
        id = ""
        author = ""
        createdAt = ""
        title = ""
        comments = ""
        score = ""
        url = ""
        image = UIImage()
        after = ""
        
    }
}

extension HotNewsViewModel: TypeProtocol {
    var type: Type { return .hotNews }
}
