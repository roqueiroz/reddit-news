
import Foundation

enum Type {
    case hotNews, comment
}

protocol TypeProtocol {
    var type: Type { get }
}
