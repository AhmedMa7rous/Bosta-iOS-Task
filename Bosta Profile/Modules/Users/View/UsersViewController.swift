//
//  UsersViewController.swift
//  Bosta Profile
//
//  Created by Ma7rous on 07/02/2023.
//

import UIKit
import RxSwift
import RxCocoa


class UsersViewController: UIViewController {
    
    //MARK: Outlet Connections
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak private var viewMessage: UIView!
    @IBOutlet weak private var lblMessage: UILabel!
    @IBOutlet weak private var imgMeessage: UIImageView!
    
/*=================================================*/
    //MARK: Properties
    private var viewModel = UsersViewModel()
    

    
/*=================================================*/
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        updateUI()
        bindTableView()
    }
    
    
/*=================================================*/
    //MARK: Support Functions
    fileprivate func setupIntialView() {
        //Set Intial state
        usersTableView.isHidden = true
        titleLabel.isHidden = true
        viewMessage.isHidden = false
        lblMessage.text = "Getting users..."
        imgMeessage.image = #imageLiteral(resourceName: "Loading")
    }
    
    fileprivate func setupTableView() {
        //Register UsersCell
        usersTableView.register(UsersTableViewCell.nib, forCellReuseIdentifier: UsersTableViewCell.identifier)
        //Set usersTableView UI
        usersTableView.layer.borderWidth = 2
        usersTableView.layer.cornerRadius = 15
    }
    
    fileprivate func setupObservables() {
        //Set success state
        viewModel.onSuccess.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.viewMessage.isHidden = true
            self.titleLabel.isHidden = false
            self.usersTableView.isHidden = false
        }.disposed(by: viewModel.disposeBag)
        
        //Set error state
        viewModel.onError.subscribe { [weak self] error in
            guard let self = self else { return }
            self.usersTableView.isHidden = true
            self.titleLabel.isHidden = true
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
    
    func bindTableView() {
        usersTableView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
        viewModel.users.bind(to: usersTableView.rx.items(cellIdentifier: UsersTableViewCell.identifier, cellType: UsersTableViewCell.self)) { (row, item, cell) in
            cell.configure(user: item)
            
        } .disposed(by: viewModel.disposeBag)
        
        usersTableView.rx.modelSelected(User.self).subscribe { [weak self] user in
            guard let self = self else { return }
            guard let user = user.element else { return }
            let vc = ProfileViewController(user: user)
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: viewModel.disposeBag)

    }
}

/*=================================================*/
extension UsersViewController: UITableViewDelegate {
    
}
