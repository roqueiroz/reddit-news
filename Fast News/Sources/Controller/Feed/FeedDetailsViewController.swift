
import UIKit

class FeedDetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    var hotNewsViewModel: HotNewsViewModel?
    
    var comments: [Comment] = [Comment]() {
        didSet {
            var viewModels: [TypeProtocol] = [TypeProtocol]()
            
            if let hotNews = hotNewsViewModel {
                viewModels.append(hotNews)
            }
            
            _ = comments.map { (comment) in
                viewModels.append(CommentViewModel(comment: comment))
            }
            
            self.mainView.setup(with: viewModels, and: self)
        }
    }
    
    var mainView: FeedDetailsView {
        guard let view = self.view as? FeedDetailsView else {
            fatalError("View is not of type FeedDetailsView!")
        }
        return view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        HotNewsProvider.shared.hotNewsComments(id: hotNewsViewModel?.id ?? "") { (completion) in
            do {
                let comments = try completion()
                
                self.comments = comments
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension FeedDetailsViewController: FeedViewDelegate {
    
    func setBookMark(favoriteNews: HotNewsViewModel, isFavorite: Bool) {

    }

    func getNextPage(afert: String) {
        
    }

    func didTouch(cell: FeedCell, indexPath: IndexPath) {
        guard self.mainView.viewModels[indexPath.row].type == .hotNews,
            let viewModel = self.mainView.viewModels[indexPath.row] as? HotNewsViewModel else {
                return
        }
        
        if let url = URL(string: viewModel.url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    
}
