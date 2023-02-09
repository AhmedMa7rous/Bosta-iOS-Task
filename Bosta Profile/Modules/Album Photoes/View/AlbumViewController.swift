//
//  AlbumViewController.swift
//  Bosta Profile
//
//  Created by Ma7rous on 07/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumViewController: UIViewController {
    //MARK: - Outlet Connections
    @IBOutlet weak var photosSearchBar: UISearchBar!
    @IBOutlet weak private var viewMessage: UIView!
    @IBOutlet weak private var lblMessage: UILabel!
    @IBOutlet weak private var imgMeessage: UIImageView!
    @IBOutlet weak private var albumCollectionView: UICollectionView!
    
/*=======================================================*/
    //MARK: - Properties
    var viewModel: AlbumViewModel
    
/*=======================================================*/
    //MARK: - Lifecycle
    init(album: Album) {
        self.viewModel = AlbumViewModel(album: album)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        updateUI()
        bindCollectionView()
        startsearch()
    }
 
/*=======================================================*/
    //MARK: - Services Functions
    fileprivate func setupIntialView() {
        //Set Intial state
        albumCollectionView.isHidden = true
        navigationItem.title = ""
        viewMessage.isHidden = false
        lblMessage.text = "Getting Photos..."
        imgMeessage.image = #imageLiteral(resourceName: "Loading")
    }
    
    fileprivate func setupTableView() {
        //Register albumCell
        albumCollectionView.register(AlbumCollectionViewCell.nib, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        //Set albumCollectionView UI
        albumCollectionView.layer.borderWidth = 0.5
        albumCollectionView.layer.cornerRadius = 5
    }
    
    fileprivate func setupObservables() {
        //Set success state
        viewModel.onSuccess.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.viewMessage.isHidden = true
            self.navigationItem.title = self.viewModel.album.title
            self.albumCollectionView.isHidden = false
        }.disposed(by: viewModel.disposeBag)
        
        //Set error state
        viewModel.onError.subscribe { [weak self] error in
            guard let self = self else { return }
            self.albumCollectionView.isHidden = true
            self.navigationItem.title = ""
            self.viewMessage.isHidden = false
            self.lblMessage.text = error.debugDescription
            self.imgMeessage.image = #imageLiteral(resourceName: "Error")
        }.disposed(by: viewModel.disposeBag)
    }
    
    func updateUI() {
        setupTableView()
        setupIntialView()
        setupObservables()
    }
    
    func bindCollectionView() {
        albumCollectionView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
        viewModel.filteredItems.bind(to: albumCollectionView.rx.items(cellIdentifier: AlbumCollectionViewCell.identifier, cellType: AlbumCollectionViewCell.self)) { (row, item, cell) in
            cell.configure(photo: item)
            
        } .disposed(by: viewModel.disposeBag)
        
        albumCollectionView.rx.modelSelected(Photo.self).subscribe { [weak self] photo in
            guard let self = self else { return }
            guard let photo = photo.element else { return }
            let vc = PhotoDetailsViewController(photo: photo)
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: viewModel.disposeBag)

    }
    
    func startsearch() {
        photosSearchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .debug()
            .bind(to: viewModel.searchObserver)
            .disposed(by: viewModel.disposeBag)
    }
}
/*=================================================*/
extension AlbumViewController: UICollectionViewDelegate, UISearchBarDelegate {
    
}
