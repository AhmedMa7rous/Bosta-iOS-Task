//
//  ProfileViewController.swift
//  Bosta Profile
//
//  Created by Ma7rous on 06/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    //MARK: - Outlet Connections
    @IBOutlet weak var profileTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var myAlbumsLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak private var viewMessage: UIView!
    @IBOutlet weak private var lblMessage: UILabel!
    @IBOutlet weak private var imgMeessage: UIImageView!
    
/*===============================================*/
    //MARK: - Properties
    var viewModel: ProfileViewModel
    
/*===============================================*/
    //MARK: - LifeCycle
    init(user: User) {
        self.viewModel = ProfileViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        updateUI()
        bindTableView()
    }


/*=================================================*/
    //MARK: Support Functions
    fileprivate func setupUserInfo() {
        //Set user data
        profileTitleLabel.text = " Profile"
        nameLabel.text = " \(viewModel.user.name)"
        infoLabel.text = " \(viewModel.user.address.street), \(viewModel.user.address.suite), \(viewModel.user.address.city), \(viewModel.user.address.zipcode)"
        myAlbumsLabel.text = " My Albums"
    }
    
    fileprivate func setupIntialView() {
        //Set Intial state
        profileTableView.isHidden = true
        profileTitleLabel.isHidden = true
        nameLabel.isHidden = true
        infoLabel.isHidden = true
        myAlbumsLabel.isHidden = true
        viewMessage.isHidden = false
        lblMessage.text = "Getting Albums..."
        imgMeessage.image = #imageLiteral(resourceName: "Loading")
    }
    
    fileprivate func setupTableView() {
        //Register UsersCell
        profileTableView.register(ProfileTableViewCell.nib, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        //Set usersTableView UI
        profileTableView.layer.borderWidth = 2
        profileTableView.layer.cornerRadius = 15
    }
    fileprivate func setupObservables() {
        //Set success state
        viewModel.onSuccess.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.viewMessage.isHidden = true
            self.profileTableView.isHidden = false
            self.profileTitleLabel.isHidden = false
            self.nameLabel.isHidden = false
            self.infoLabel.isHidden = false
            self.myAlbumsLabel.isHidden = false
        }.disposed(by: viewModel.disposeBag)
        
        //Set error state
        viewModel.onError.subscribe { [weak self] error in
            guard let self = self else { return }
            self.profileTableView.isHidden = true
            self.profileTitleLabel.isHidden = true
            self.nameLabel.isHidden = true
            self.infoLabel.isHidden = true
            self.myAlbumsLabel.isHidden = true
            self.viewMessage.isHidden = false
            self.lblMessage.text = error.debugDescription
            self.imgMeessage.image = #imageLiteral(resourceName: "Error")
        }.disposed(by: viewModel.disposeBag)
    }
    
    func updateUI() {
        setupUserInfo()
        setupTableView()
        setupIntialView()
        setupObservables()
    }
    
    func bindTableView() {
        profileTableView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
        viewModel.albums.bind(to: profileTableView.rx.items(cellIdentifier: ProfileTableViewCell.identifier, cellType: ProfileTableViewCell.self)) { (row, item, cell) in
            cell.configure(album: item)
            
        } .disposed(by: viewModel.disposeBag)
        
        profileTableView.rx.modelSelected(Album.self).subscribe { [weak self] album in
            guard let self = self else { return }
            guard let album = album.element else { return }
            let vc = AlbumViewController(album: album)
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: viewModel.disposeBag)

    }
}

/*=================================================*/
extension ProfileViewController: UITableViewDelegate {
    
}
