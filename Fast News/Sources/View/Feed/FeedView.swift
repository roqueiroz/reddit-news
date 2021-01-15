
import UIKit

protocol FeedViewDelegate {
    
    func didTouch(cell: FeedCell, indexPath: IndexPath)
    
    func setBookMark(favoriteNews: HotNewsViewModel, isFavorite: Bool)
    
    func getNextPage(afert: String)
}

class FeedView: UIView, UIScrollViewDelegate {
    
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var viewModels: [HotNewsViewModel] = [HotNewsViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var delegate: FeedViewDelegate?
    
    //MARK: - Public Methods
    func setup(with viewModels: [HotNewsViewModel], and delegate: FeedViewDelegate) {
        
        tableView.register(UINib(nibName: "FeedCell", bundle: Bundle.main), forCellReuseIdentifier: "FeedCell")
        
        self.delegate = delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        self.viewModels = viewModels
    }
    
    func loading(show: Bool) {
        
        if show {
            
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 100))
            
            let spinner = UIActivityIndicatorView()
            spinner.center = footer.center
            
            footer.addSubview(spinner)
            
            spinner.startAnimating()
            
            self.tableView.tableFooterView = footer
            
        } else {
            self.tableView.tableFooterView = nil
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.viewModels.count > 0 {
            
            let position = scrollView.contentOffset.y
            let tableViewHeight = tableView.contentSize.height
            let scrollViewHeight = scrollView.frame.size.height
            
            if position > ((tableViewHeight - 100) - scrollViewHeight) {
                delegate?.getNextPage(afert: self.viewModels.last!.after)
            }
        }
        
    }
}

extension FeedView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let label = UILabel()
        label.text = "Não foi possivel carregar os feeds"
        label.textAlignment = .center
        
        tableView.backgroundView = viewModels.count == 0 ? label : nil
        
        return viewModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else { fatalError("Cell is not of type FeedCell!") }
        
        cell.setup(hotNewsViewModel: viewModels[indexPath.row], and: delegate as! FeedViewDelegate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedCell else { fatalError("Cell is not of type FeedCell!") }
        
        delegate?.didTouch(cell: cell, indexPath: indexPath)
    }
}
