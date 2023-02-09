//
//  UsersViewModel.swift
//  Bosta Profile
//
//  Created by Ma7rous on 07/02/2023.
//

import UIKit
import Moya
import RxSwift
import RxRelay

class UsersViewModel {
    //MARK: Properties
    private let provider = MoyaProvider<JSONPlaceholder>()
    private(set) var users = BehaviorSubject(value: [User]())

    var disposeBag: DisposeBag = DisposeBag()
    var onSuccess: PublishSubject<Void> = PublishSubject<Void>()
    var onError: PublishSubject<String> = PublishSubject<String>()
    var showLoader: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    //MARK: - Intents
    
    func fetchData() {
        provider.request(.users) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    self.users.on(.next(try response.map([User].self)))
                    self.onSuccess.onNext(())
                } catch {
                    print(error.localizedDescription)
                    self.onError.onNext(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.onError.onNext(error.localizedDescription)
            }
        }
    }
    
     

}
