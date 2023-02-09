//
//  ProfileViewModel.swift
//  Bosta Profile
//
//  Created by Ma7rous on 07/02/2023.
//

import UIKit
import Moya
import RxSwift
import RxRelay


class ProfileViewModel {
    //MARK: Properties
    private let provider = MoyaProvider<JSONPlaceholder>()
    private(set) var albums = BehaviorSubject(value: [Album]())
    let user: User
    var disposeBag: DisposeBag = DisposeBag()
    var onSuccess: PublishSubject<Void> = PublishSubject<Void>()
    var onError: PublishSubject<String> = PublishSubject<String>()
    var showLoader: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
/*============================================================*/
    //MARK: - Intializer
    init(user: User) {
        self.user = user
        JSONPlaceholder.userId = user.id
    }
/*============================================================*/
    //MARK: - Intents
    func fetchData() {
        provider.request(.albums) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    self.albums.on(.next(try response.map([Album].self)))
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
