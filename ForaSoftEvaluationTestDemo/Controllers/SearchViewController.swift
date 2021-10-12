//
//  ViewController.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/7/21.
//

import UIKit

protocol AlbumDataUserProtocol: class {
    var dataSource: AlbumsDataSource? { set get }
}

class SearchViewController: UIViewController, AlbumDataUserProtocol {
    
    private struct Constants {
        static let cellIdentifier = "AlbumCell"
    }
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var errorMessageView: MessageView!
    
    var dataSource: AlbumsDataSource?
    
    var albums: [Album]?
    {
        willSet {
            DispatchQueue.main.async { [weak self] in
                self?.albumCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupAlbumCollectionView()
        searchBar.delegate = self
    }
    
    func loadAlbums(for group: String) {
        errorMessageView.isHidden = true
        activityIndicator.startAnimating()
        dataSource?.loadAlbums(for: group) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.errorMessageView.isHidden = false
                    switch error {
                    case .serverError(_):
                        self?.errorMessageView.configure(with: "No data from server. Please try again.")
                    case .missingData:
                        self?.errorMessageView.configure(with: "No data from server for this request :(. Please try another one.")
                    default:
                        self?.errorMessageView.configure(with: "No data. Please check internet connection. Error: \(error.localizedDescription)")
                    }
                }
            case .success(let albums):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.albums = albums
                    self?.albumCollectionView.reloadData()
                }
            }
        }
    }
    
    private func setupAlbumCollectionView() {
        albumCollectionView.backgroundView = errorMessageView
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return albums?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let albums = albums, let albomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? AlbumCollectionViewCell
        {
            let album = albums[indexPath.row]
            albomCollectionViewCell.configureCellWith(data: album)
            cell = albomCollectionViewCell
        }
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.07, height: collectionView.frame.width / 2 * 1.3)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let album = albums?[indexPath.row], let detailDataSource = dataSource as? DetailDataSource else { return }
        let detailViewController = DetailViewController(album: album, dataController: detailDataSource)
        
        present(detailViewController, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.albums?.removeAll()
        guard let searchGroup = searchBar.text?.lowercased(), !searchGroup.isEmpty else {
            let alert = UIAlertAction(title: "Ok", style: .default, handler: nil)
            let alertController = UIAlertController(title: "Error", message: "Enter the artist name", preferredStyle: .alert)
            alertController.addAction(alert)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        loadAlbums(for: searchGroup)
    }
}

extension SearchViewController: DataUserDelegate {    
    func dataEndLoading() {
        albumCollectionView.reloadData()
    }
}
