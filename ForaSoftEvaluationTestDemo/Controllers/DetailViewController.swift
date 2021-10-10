//
//  DetailView.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/10/21.
//

import UIKit


class DetailViewController: UIViewController {
    
    struct Constants {
        static let songCellIdentifier = "SongCell"
        static let songCellNibName = "SongCellView"
    }
    
    private var dataController: DetailDataSource
    private var album: Album
    private var songs: [Song]?

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()
    
    private var albumNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .medium)
        label.textAlignment = .center
        return label
    }()
 
    private var albumReleaseLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    private var songsListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(UINib(nibName: Constants.songCellNibName, bundle: nil), forCellReuseIdentifier: Constants.songCellIdentifier)
        return tableView
    }()
    
    required init(album: Album, dataController: DetailDataSource) {
        self.album = album
        self.dataController = dataController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        songsListTableView.dataSource = self
        songsListTableView.delegate = self
        view.backgroundColor = UIColor.systemBackground
        setupViewHierarchy()
        setupLayoutConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        dataController.fetchDetails(for: album) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error.errorDescription!)
            case .success(let details):
                self?.activityIndicator.stopAnimating()
                DispatchQueue.main.async {
                    self?.configure(with: details)
                    self?.songsListTableView.reloadData()
                }
            }
        }
    }
    
    func configure(with albumDetails: AlbumDetails) {
        if let imageData = albumDetails.album.imageData {
            imageView.image = UIImage(data: imageData) ?? UIImage(named: "photo")!
            albumNameLabel.text = albumDetails.album.albumName
            albumReleaseLabel.text = albumDetails.album.releaseDate.formate()
            songs = albumDetails.songsList
        }
    }
    
    private func setupViewHierarchy() {
        view.addSubview(imageView)
        view.addSubview(albumNameLabel)
        view.addSubview(albumReleaseLabel)
        view.addSubview(songsListTableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupLayoutConstraints() {
        for subview in view.subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let space: CGFloat = 24.0
        let spaceBetweenView: CGFloat = 8.0
        view.layoutMargins = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        let margins = view.layoutMarginsGuide
        
        imageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        albumNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spaceBetweenView).isActive = true
        pinHorizontally(view: albumNameLabel, to: margins)
        albumReleaseLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: spaceBetweenView).isActive = true
        pinHorizontally(view: albumReleaseLabel, to: margins)

        songsListTableView.topAnchor.constraint(equalTo: albumReleaseLabel.bottomAnchor).isActive = true
        pinHorizontally(view: songsListTableView, to: margins)
        songsListTableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true

        activityIndicator.centerXAnchor.constraint(equalTo: songsListTableView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: songsListTableView.centerYAnchor).isActive = true
    }
    
    func pinHorizontally(view: UIView, to margins: UILayoutGuide) {
        view.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let song = songs?[indexPath.row], let songCell = tableView.dequeueReusableCell(withIdentifier: Constants.songCellIdentifier, for: indexPath) as? SongCell {
            songCell.configure(with: song)
            cell = songCell
        } else {
            cell.textLabel?.text = "No data..."
        }
        
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
