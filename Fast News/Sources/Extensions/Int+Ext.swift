
import Foundation

extension Int {
    
    //MARK: - Date Formatter
    
    var createdAt: String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        return date.elapsedInterval
    }
    
    var toString: String {
        return "\(self)"
    }
}
