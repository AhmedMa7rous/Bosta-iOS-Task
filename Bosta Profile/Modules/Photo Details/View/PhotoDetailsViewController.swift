//
//  PhotoDetailsViewController.swift
//  Bosta Profile
//
//  Created by Ma7rous on 07/02/2023.
//

import UIKit
import SDWebImage

class PhotoDetailsViewController: UIViewController {
/*=======================================================*/
    //MARK: - Outlet Connections
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak private var progressBar: UIProgressView!
    @IBOutlet weak private var viewUpload: UIView!
    @IBOutlet weak private var btnShare: UIButton!
/*=======================================================*/
    //MARK: - Properties
    private var viewModel: PhotoViewModel
    private var image = UIImage()
/*=======================================================*/
    //MARK: - Lifecycle
    init(photo: Photo) {
        self.viewModel = PhotoViewModel(photo: photo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
/*=======================================================*/
    //MARK: - Action Connections
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) {
          self.viewUpload.alpha = 1.0
          self.btnShare.alpha = 0.0
        }
        progressBar.progress = 0.0
        viewModel.fetchData(image: self.snapCard())
        setupObservables()
    }
    
/*=======================================================*/
    //MARK: - Services Functions
    
    fileprivate func setupIntialView() {
        //Set Intial state
        let imgUrl = URL(string: viewModel.photo.url)
        photoImageView.sd_setImage(with: imgUrl, completed: nil)
        self.navigationItem.title = viewModel.photo.title
        guard let image = self.photoImageView.image else { return }
        self.image = image
    }
    
    fileprivate func setupObservables() {
        //Set success state
        viewModel.onSuccess.subscribe { [weak self] _ in
            guard let self = self else { return }
            guard let url =  self.viewModel.uploadResult?.link else { return }
            self.progressBar.setProgress(0.9, animated: true)
            UIView.animate(withDuration: 0.15) {
              self.viewUpload.alpha = 0.0
              self.btnShare.alpha = 0.0
            }
            self.presentShare(image: self.image, url: url)
        }.disposed(by: viewModel.disposeBag)
        
        //Set error state
        viewModel.onError.subscribe { [weak self] error in
            guard let self = self else { return }
            self.presentError()
        }.disposed(by: viewModel.disposeBag)
    }
    
    func updateUI() {
        setupIntialView()
    }

    
    private func presentShare(image: UIImage, url: URL) {
      let alert = UIAlertController(title: "Your card is ready!", message: nil, preferredStyle: .actionSheet)

      let openAction = UIAlertAction(title: "Open in Imgur", style: .default) { _ in
        UIApplication.shared.open(url)
      }

      let shareAction = UIAlertAction(title: "Share", style: .default) { [weak self] _ in
        let share = UIActivityViewController(activityItems: ["Check out my card!", url, image],
                                             applicationActivities: nil)
        share.excludedActivityTypes = [.airDrop, .addToReadingList]
        self?.present(share, animated: true, completion: nil)
      }

      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

      alert.addAction(openAction)
      alert.addAction(shareAction)
      alert.addAction(cancelAction)

      present(alert, animated: true, completion: nil)
    }

    private func presentError() {
      let alert = UIAlertController(title: "Uh oh", message: "Something went wrong. Try again later.",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

      present(alert, animated: true, completion: nil)
    }
    
    private func snapCard() -> UIImage {
      UIGraphicsBeginImageContextWithOptions(photoImageView.bounds.size, true, UIScreen.main.scale)
        photoImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
      guard let image = UIGraphicsGetImageFromCurrentImageContext() else { fatalError("Failed snapping card") }
      UIGraphicsEndImageContext()

      return image
    }
    
}
