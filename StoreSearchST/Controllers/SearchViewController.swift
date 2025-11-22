//
//  ViewController.swift
//  StoreSearchST
//
//  Created by khamzaev on 06.11.2025.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let headerView = UIView()
    private let searchBar = UISearchBar()
    private let segmentedControl = UISegmentedControl(items: ["All", "Music", "Software", "E-Books"])
    private let tableView = UITableView()
    private let viewModel = SearchViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeader()
        setupSearchBar()
        setupSegmentedControl()
        setupTableView()
        setupDismissKeyboardGesture()
        viewModel.onStateChanged = { [weak self] state in
            self?.updateUI(for: state)
        }
    }
    
    private func updateUI(for state: SearchViewModel.State) {
        DispatchQueue.main.async {
            switch state {
            case .notSearchedYet:
                self.tableView.reloadData()

            case .loading:
                self.tableView.reloadData()
                self.animatedTableAppearance()

            case .noResults:
                self.tableView.reloadData()
                self.animatedTableAppearance()

            case .results:
                self.tableView.reloadData()
                self.animatedTableAppearance()
            }
        }
    }
    
    private func setupHeader() {
        headerView.backgroundColor = UIColor(red: 0.17, green: 0.42, blue: 0.34, alpha: 1.0)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "App name, artist, song, album, e-book..."
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let tf = searchBar.searchTextField
        tf.backgroundColor = UIColor(white: 1, alpha: 0.15)
        tf.textColor = .white
        tf.leftView?.tintColor = .white
        tf.attributedPlaceholder = NSAttributedString(
            string: "App name,  artist, song, album, e-book...",
            attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)]
        )
        tf.font = .systemFont(ofSize: 20, weight: .semibold)
        tf.layer.cornerRadius = 14
        tf.layer.masksToBounds = true
        
        headerView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -5),
            searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),
            tf.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        searchBar.delegate = self
    }
    
    private func setupDismissKeyboardGesture() {
        // создаём распознаватель касаний
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        // прячем клавиатуру у любого активного поля
        view.endEditing(true)
    }
    
    private func setupSegmentedControl() {
        let pill = UIView()
        pill.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0)
        pill.layer.cornerRadius = 14
        pill.layer.masksToBounds = true
        pill.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pill)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = UIColor(red: 0.17, green: 0.42, blue: 0.34, alpha: 1.0)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.backgroundColor = .clear
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        pill.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            pill.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            pill.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pill.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            segmentedControl.topAnchor.constraint(equalTo: pill.topAnchor, constant: 6),
            segmentedControl.leadingAnchor.constraint(equalTo: pill.leadingAnchor, constant: 6),
            segmentedControl.trailingAnchor.constraint(equalTo: pill.trailingAnchor, constant: -6),
            segmentedControl.bottomAnchor.constraint(equalTo: pill.bottomAnchor, constant: -6),
            segmentedControl.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.reuseID)
        tableView.register(NothingFoundCell.self, forCellReuseIdentifier: NothingFoundCell.reuseID)
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
    }
    
    private func animatedTableAppearance() {
        tableView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.tableView.alpha = 1
        }
    }
    
    private func currentCategory() -> Category {
        switch segmentedControl.selectedSegmentIndex {
        case 1: return .music
        case 2: return .software
        case 3: return .ebook
        default: return .all
        }
    }
    
    @objc private func segmentChanged() {
        guard let text = searchBar.text, !text.isEmpty else { return }
        viewModel.performSearch(text: text, category: currentCategory())
    }
    
    
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state {
        case .notSearchedYet:
            return 0
        case .loading, .noResults:
            return 1
        case .results(let list):
            return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.contentInset = .zero
        
        switch viewModel.state {
        case .notSearchedYet:
            fatalError("Не должно вызвываться - таблица пустая")
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseID) as? LoadingCell
            ?? LoadingCell(style: .default,reuseIdentifier: LoadingCell.reuseID)
            return cell
        case .noResults:
            let cell = tableView.dequeueReusableCell(withIdentifier: NothingFoundCell.reuseID) as? NothingFoundCell
            ?? NothingFoundCell(style: .default, reuseIdentifier: NothingFoundCell.reuseID)
            tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
            return cell
        case .results(let list):
            let result = list[indexPath.row]
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultCell.reuseID
            ) as? SearchResultCell ?? SearchResultCell(style: .default, reuseIdentifier: SearchResultCell.reuseID)
            
            cell.configure(with: result)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch viewModel.state {
        case .results(let list):
            let result = list[indexPath.row]
            
            let detailVC = DetailViewController()
            detailVC.viewModel = DetailViewModel(item: result.item)
            detailVC.modalPresentationStyle = .overFullScreen
            detailVC.modalTransitionStyle = .crossDissolve
            
            detailVC.configure()
            
            present(detailVC, animated: true)
            
        default:
            return
        }
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let text = searchBar.text, !text.isEmpty else { return }
        viewModel.performSearch(text: text, category: currentCategory())
    }
}
