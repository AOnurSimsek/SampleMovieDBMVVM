//
//  MainScreenViewController.swift
//  MovieDB
//
//  Created by Abdullah Onur Şimşek on 13.02.2022.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let emptyView : UIView = {
        let view = UIView()
        view.frame = CGRect(x: (UIScreen.main.bounds.width/2)-150, y: (UIScreen.main.bounds.height/2)-200, width:300, height: 400)
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.borderGray.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let label = UILabel()
        label.frame = CGRect(x: 20, y: (view.frame.height/2)-20, width: view.frame.height-40, height: 30)
        label.textColor = .textWhite
        label.textAlignment = .center
        label.text = "No movies were found matching your search criteria."
        label.numberOfLines = 0
        label.backgroundColor = .clear
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "")
        imageView.frame = CGRect(x: view.frame.width-40, y: label.frame.minY - 100, width: 80, height: 80)
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        view.isHidden = true
        return UIView()
    }()
    
    var viewModel = MainScreenViewModel()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setTableView()
        setSearchBar()
        initViewModel()
        viewModel.getUpcomingMovies(page: 1)
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Inits
    
    func initUI(){
        self.navigationController?.navigationBar.tintColor = .movieDBGreen
        self.navigationController?.navigationBar.barTintColor = .movieDBGreen
        self.title = "MovieDB"
        
        self.view.addSubview(emptyView)
        self.view.backgroundColor = .movieDBNavy
        
        titleLabel.textColor = .textWhite
        titleLabel.font = .systemFont(ofSize: 28, weight: .semibold)
    }
    
    func initViewModel(){
        viewModel.reloadTableView = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.titleLabel.isHidden = false
                self.emptyView.isHidden = true
                self.tableView.isHidden = false
            }
        }
        viewModel.showError = {
            self.showAlert(self.viewModel.errorMessage ?? "Something went terribly wrong.")
        }
        viewModel.showLoading = {
            LoadingView.shared.startLoadingView(vc: self)
        }
        viewModel.hideLoading = {
            LoadingView.shared.stopLoadingView()
        }
        viewModel.changeViewtoUpcoming = {
            self.titleLabel.text = "Upcoming Movies"
        }
        viewModel.changeViewtoSearch = {
            self.titleLabel.text = "Search Results"
        }
        viewModel.showEmptyView = {
            self.tableView.isHidden = true
            self.emptyView.isHidden = false
        }
    }

}

//MARK: - TableView

extension MainScreenViewController : UITableViewDelegate, UITableViewDataSource {
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MainScreenTableViewCell", bundle: nil), forCellReuseIdentifier: MainScreenTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.separatorColor = .movieDBBlue
        tableView.bounces = false
        tableView.backgroundColor = .movieDBNavy
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainScreenTableViewCell.identifier, for: indexPath) as! MainScreenTableViewCell
        if indexPath.row == viewModel.getNumberOfCells()-1 {
            viewModel.getNextPage()
        }
        cell.model = viewModel.getCellData(index: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailScreenViewController") as! DetailScreenViewController
        nextVC.id = viewModel.getCellData(index: indexPath.row)?.id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
}

//MARK: - SearchBar

extension MainScreenViewController : UISearchBarDelegate {
    func setSearchBar(){
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .movieDBGreen
        searchBar.backgroundColor = .movieDBNavy
        searchBar.barTintColor = .movieDBGreen
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.placeholder = "Search a movie"
        textFieldInsideSearchBar?.textColor = .movieDBGreen
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.tableView.isHidden = true
        self.titleLabel.isHidden = true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let unwrappedText = searchBar.text {
            searchBar.resignFirstResponder()
            self.viewModel.searchMovie(page: 1, searchText: unwrappedText)
        }
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        if searchBar.text == "" || searchBar.text == " " {
            view.endEditing(true)
            viewModel.searchBarClosed()
        }
    }
}

