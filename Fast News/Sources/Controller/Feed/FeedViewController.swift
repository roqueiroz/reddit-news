
import Foundation
import UIKit

class FeedViewController: BaseViewController {
    
    //MARK: - Constants
    let kToDetails: String = "toDetails"
    
    //MARK: - Properties
    var hotNews: [HotNews] = [HotNews]() {
        
        didSet {
            
            var viewModels: [HotNewsViewModel] = [HotNewsViewModel]()
            
            _ = hotNews.map {
                
                (news) in
                
                viewModels.append(HotNewsViewModel(hotNews: news))
            }
            
            self.mainView.setup(with: viewModels, and: self)
        }
        
    }
    
    var mainView: FeedView {
        
        guard let view = self.view as? FeedView else {
            fatalError("View is not of type FeedView!")
        }
        
        return view
    }
    
    //MARK: Override`s
    override func viewDidLoad() {
        
        super.viewDidLoad()
        super.loadDataBase()
        
        navigationItem.title = "Fast News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if isConnectedNetwork() {
            
            HotNewsProvider.shared.hotNews("") {
                
                (completion) in
                
                do {
                    
                    let hotNews = try completion()
                    
                    self.hotNews = hotNews
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        } else {
            
            self.mainView.setup(with: self.loadfavoriteNews(), and: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let hotNewsViewModel = sender as? HotNewsViewModel else { return }
        guard let detailViewController = segue.destination as? FeedDetailsViewController else { return }
        
        detailViewController.hotNewsViewModel = hotNewsViewModel
    }
}

extension FeedViewController: FeedViewDelegate {
    
    func setBookMark(favoriteNews: HotNewsViewModel, isFavorite: Bool) {
        
        if isFavorite {
            self.saveFavoriteNews(favoriteNews)
        } else {
            self.delFavoriteNews(favoriteNews.id)
        }
       
    }

    func didTouch(cell: FeedCell, indexPath: IndexPath) {
        self.performSegue(withIdentifier: kToDetails, sender: self.mainView.viewModels[indexPath.row])
    }
    
    func getNextPage(afert: String) {
        
        if self.isConnectedNetwork() {
            
            guard !HotNewsProvider.shared.isPaginating else {
                return
            }
            
            self.mainView.loading(show: true)
            
            HotNewsProvider.shared.hotNews(afert) {
                
                (completion) in
                
                do {
                    
                    let nextNews = try completion()
                    
                    self.hotNews.append(contentsOf: nextNews)
                    self.mainView.loading(show: false)
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
        }
        
    }
}
