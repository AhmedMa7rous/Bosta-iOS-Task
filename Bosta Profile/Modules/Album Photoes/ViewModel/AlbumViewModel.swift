//
//  AlbumViewModel.swift
//  Bosta Profile
//
//  Created by Ma7rous on 07/02/2023.
//

import UIKit
import Moya
import RxSwift
import RxRelay
import RxCocoa



class AlbumViewModel {
    //MARK: Properties
    private let provider = MoyaProvider<JSONPlaceholder>()
    private(set) var photos = BehaviorSubject(value: [Photo]())
    var searchValue: String = ""
    let album: Album
    var disposeBag: DisposeBag = DisposeBag()
    var onSuccess: PublishSubject<Void> = PublishSubject<Void>()
    var onError: PublishSubject<String> = PublishSubject<String>()
    var showLoader: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    
    //search bar inputs
    var filteredItems = BehaviorSubject(value: [Photo]())
    lazy var items: Observable<[Photo]> = self.photos.asObservable()
    lazy var filteredItemsObservable: Observable<[Photo]> = self.filteredItems.asObservable()
    private let searchSubject = PublishSubject<String>()
    var searchObserver: AnyObserver<String> {
        return searchSubject.asObserver()
    }
    //search bar outputs
    private let loadingSubject = PublishSubject<Bool>()
    var isLoading: Driver<Bool> {
        return loadingSubject.asDriver(onErrorJustReturn: false)
    }
    
    
    
    
/*============================================================*/
    //MARK: - Intializer
    fileprivate func searchOnValue() {
        searchSubject.subscribe { [weak self] (value) in
            guard let self = self else { return }
            guard let element = value.element else { return }
            print("the value recieved: \(value)")
            self.items.map({ $0.filter({
                if element.isEmpty { return true }
                return $0.title.lowercased().contains(element.lowercased())
            })
            }).bind(to: self.filteredItems)
                .disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
    
    init(album: Album) {
        self.album = album
        JSONPlaceholder.albumId = album.id
        searchOnValue()
    }
/*============================================================*/
    //MARK: - Intents
    func fetchData() {
        provider.request(.photos) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    self.photos.on(.next(try response.map([Photo].self)))
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
