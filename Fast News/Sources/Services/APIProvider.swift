
import Alamofire

class APIProvider {
    
    //MARK: - Constants
    
    private let kBaseURL = "https://www.reddit.com"
    private let kTimeout = 30
    
    //MARK: - Properties
    
    let sessionManager: Alamofire.SessionManager
    
    //MARK: - Public Methods
    
    func baseURL() -> String {
        return kBaseURL
    }
    
    func baseHeader() -> HTTPHeaders {
        return [:]
    }
    
    //MARK: - Singleton
    
    static let shared = APIProvider()
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(kTimeout)
        configuration.timeoutIntervalForResource = TimeInterval(kTimeout)
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
}
