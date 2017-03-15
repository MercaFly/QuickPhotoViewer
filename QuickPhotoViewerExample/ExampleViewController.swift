//
//  ExampleViewController.swift
//  QuickPhotoViewerExample
//
//  Created by 洪鑫 on 2017/3/15.
//  Copyright © 2017年 Teambition. All rights reserved.
//

import UIKit
import Kingfisher
import QuickPhotoViewer

let kExamplePhotos = ["http://192.168.0.21:10077/static/plangroups/backgroups/raw/01.png",
                      "http://192.168.0.21:10077/static/plangroups/backgroups/raw/02.png",
                      "http://192.168.0.21:10077/static/plangroups/backgroups/raw/03.png",
                      "http://192.168.0.21:10077/static/plangroups/backgroups/raw/04.png",
                      "http://192.168.0.21:10077/static/plangroups/backgroups/raw/05.png",
                      "http://192.168.0.21:10077/static/plangroups/backgroups/raw/06.png",
                      "http://192.168.0.21:10077/static/plangroups/backgroups/raw/07.png",
                      "http://192.168.0.21:10077/static/plangroups/backgroups/raw/08.png",
                      "http://192.168.0.21:10077/static/plangroups/backgroups/raw/09.png",
                      "http://192.168.0.21:10077/static/plangroups/backgroups/raw/10.png"]

class ExampleViewController: UICollectionViewController {
    fileprivate lazy var topToolbar: ExampleTopToolbar = {
        let topToolbar = ExampleTopToolbar()
        return topToolbar
    }()
    fileprivate var photoViewer: QuickPhotoViewer?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
        coordinator.animate(alongsideTransition: { (context) -> Void in

            }) { (context) -> Void in

        }
    }

    // MARK: - Helpers
    fileprivate func setupUI() {
        collectionView?.register(ExamplePhotoCell.self, forCellWithReuseIdentifier: kExamplePhotoCellID)
        topToolbar.closeHandler = {
            self.photoViewer?.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - UICollectionViewDataSource & UICollectionViewDelegate
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return view.bounds.width < view.bounds.height ? 9 : 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kExamplePhotoCellID, for: indexPath) as! ExamplePhotoCell
        let photoUrl = kExamplePhotos[indexPath.row]
        cell.imageView.kf.setImage(with: URL(string: photoUrl), placeholder: UIColor(white: 221 / 255, alpha: 1).toImage())
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoUrl = kExamplePhotos[indexPath.row]
        let photo = QPhoto(url: URL(string: photoUrl)!, thumbnailUrl: nil)
        photoViewer = QuickPhotoViewer()
        photoViewer?.topToolbar = topToolbar
        photoViewer?.photos = [photo]
        present(photoViewer!, animated: true, completion: nil)
    }
}

extension ExampleViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout
    fileprivate func calculateItemSize() -> CGSize {
        let horizontalItemsCount: CGFloat = view.bounds.width < view.bounds.height ? 3 : 5
        let width = floor((view.bounds.width -  kExamplePhotoSpacing * CGFloat(horizontalItemsCount + 1)) / horizontalItemsCount)
        return CGSize(width: width, height: width)
    }

    fileprivate func calculateVerticalPadding() -> CGFloat {
        let verticalItemsCount: CGFloat = view.bounds.width < view.bounds.height ? 3 : 2
        let verticalPadding = floor((view.bounds.height - kExamplePhotoSpacing * CGFloat(verticalItemsCount - 1) - calculateItemSize().height * CGFloat(verticalItemsCount)) / 2)
        return verticalPadding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateItemSize()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: calculateVerticalPadding(), left: kExamplePhotoSpacing, bottom: 0, right: kExamplePhotoSpacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kExamplePhotoSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kExamplePhotoSpacing
    }
}
