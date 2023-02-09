//
//  PhotoViewModel.swift
//  Bosta Profile
//
//  Created by Ma7rous on 07/02/2023.
//

import UIKit
import Moya
import RxSwift
import RxRelay
import RxCocoa



class PhotoViewModel {
    //MARK: Properties
    private let provider = MoyaProvider<Imgur>()
    var uploadResult: UploadResult?
    var photo: Photo
    var disposeBag: DisposeBag = DisposeBag()
    var onSuccess: PublishSubject<Void> = PublishSubject<Void>()
    var onError: PublishSubject<String> = PublishSubject<String>()
    var showLoader: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
/*============================================================*/
    //MARK: - Intializer
    init(photo: Photo) {
        self.photo = photo
        
    }
/*============================================================*/
    //MARK: - Intents
    func fetchData(image: UIImage) {
        provider.request(.upload(image), callbackQueue: DispatchQueue.main, progress: nil, completion: { [weak self] response in
            guard let self = self else { return }
            switch response {
                case .success(let result):
                    do {
                        let upload = try result.map(ImgurResponse<UploadResult>.self)
                        self.uploadResult = upload.data
                        self.onSuccess.onNext(())
                    } catch {
                        print(error.localizedDescription)
                        self.onError.onNext(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.onError.onNext(error.localizedDescription)
            }
        })
    }
}
