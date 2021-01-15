
import UIKit

@IBDesignable
class FeedCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var btnBookMark: UIButton!
    @IBOutlet weak var idNews: UILabel!
    
    private var viewModel: HotNewsViewModel!
    var delegate: FeedViewDelegate?
    
    //MARK: - Public Methods
    func setup(hotNewsViewModel: HotNewsViewModel, and delegate: FeedViewDelegate) {
        authorLabel.text = hotNewsViewModel.author
        createdAtLabel.text = hotNewsViewModel.createdAt
        thumbnailImageView.image = hotNewsViewModel.image
        titleLabel.text = hotNewsViewModel.title
        commentsLabel.text = hotNewsViewModel.comments
        scoreLabel.text = hotNewsViewModel.score
        idNews.text = hotNewsViewModel.id
        
        if hotNewsViewModel.isFavorite {
            btnBookMark.isSelected.toggle()
        }
        
        self.viewModel = hotNewsViewModel
        self.delegate = delegate
    }
    
    func setup(viewModel: TypeProtocol) {
        guard let hotNewsViewModel = viewModel as? HotNewsViewModel else { return }
        authorLabel.text = hotNewsViewModel.author
        createdAtLabel.text = hotNewsViewModel.createdAt
        thumbnailImageView.image = hotNewsViewModel.image
        titleLabel.text = hotNewsViewModel.title
        commentsLabel.text = hotNewsViewModel.comments
        scoreLabel.text = hotNewsViewModel.score
    }
    
    @IBAction func setBookMark(_ sender: UIButton) {
        
        btnBookMark.isSelected.toggle()
        
        //        if btnBookMark.isSelected {
        
        delegate?.setBookMark(favoriteNews: viewModel, isFavorite: btnBookMark.isSelected)
        viewModel.isFavorite = btnBookMark.isSelected
        
        //        } else {
        //            print("notSelected")
        //        }
        
        
        
    }
    
}
