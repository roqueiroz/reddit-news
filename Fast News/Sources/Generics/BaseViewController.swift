
import UIKit
import SystemConfiguration
import CoreData

class BaseViewController: UIViewController {
    
    //MARK: - Private Properties
    private var fetchedResultCtrl: NSFetchedResultsController<FavoriteNews>!
    private var favoriteNews: FavoriteNews!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func isConnectedNetwork() -> Bool {
        
        var baseNetWorkAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        baseNetWorkAddress.sin_len = UInt8(MemoryLayout.size(ofValue: baseNetWorkAddress))
        baseNetWorkAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &baseNetWorkAddress) {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                sockAddres in
                SCNetworkReachabilityCreateWithAddress(nil, sockAddres)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
    
    func loadDataBase() {
        
        let sortDescriptor = NSSortDescriptor(key: "bookMarkDate", ascending: true)
        
        let fetchRequest: NSFetchRequest<FavoriteNews> = FavoriteNews.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultCtrl = NSFetchedResultsController (
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultCtrl.delegate = self
        
        do {
            try fetchedResultCtrl.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadfavoriteNews() -> [HotNewsViewModel] {
        
        var hotNewsArray: [HotNewsViewModel] = [HotNewsViewModel]()
                
        if let dataSource = fetchedResultCtrl.fetchedObjects {
            
            for item in dataSource {
            
                var viewModel = HotNewsViewModel()
                viewModel.id = item.id!
                viewModel.author = item.author!
                viewModel.comments = item.comments!
                viewModel.createdAt = item.createdAt!
                viewModel.image = item.image! as! UIImage
                viewModel.score = item.score!
                viewModel.isFavorite = true
                hotNewsArray.append(viewModel)
                
            }
            
        }
        
        return hotNewsArray
    }
    
    func delFavoriteNews(_ id: String) {
        
        let fetchRequest: NSFetchRequest<FavoriteNews> = FavoriteNews.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        let favoriteNews = try! context.fetch(fetchRequest)
    
        for obj in favoriteNews {
            context.delete(obj)
        }
    
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func saveFavoriteNews(_ news: HotNewsViewModel) {
        
        if favoriteNews == nil {
            favoriteNews = FavoriteNews(context: context)
        }
        
        favoriteNews.id = news.id
        favoriteNews.author = news.author
        favoriteNews.comments = news.comments
        favoriteNews.createdAt = news.createdAt
        favoriteNews.score = news.score
        favoriteNews.title = news.title
        favoriteNews.image = news.image
        favoriteNews.bookMarkDate = Date()
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}


extension UIViewController {
    
    var context: NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
}

extension BaseViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {

        case .delete:
            break

        default:
//            tableView.reloadData()
            break
        }

    }

}

