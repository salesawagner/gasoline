//
//  TinderViewController.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 5/25/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift

class TinderViewController: GASViewController {

	// MARK: - Properties

	var viewModel: DetailTinderViewModel!
    override var canBecomeFirstResponder: Bool {
        return true
    }

	// MARK: - IBOutlets

//    @IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descriptionEffectView: UIVisualEffectView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var superLikeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!

        // MARK: - Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setups()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()
        self.collectionView.contentInsetAdjustmentBehavior = .never
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.complexShape()
    }

    override func setupNavigation() {
        super.setupNavigation()

        // Image
        let image = #imageLiteral(resourceName: "btn_more")

        // Frame
        let width = image.size.width
        let height = image.size.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)

        // Button
        let button = UIButton(frame: frame)
        button.setImage(image, for: UIControl.State())
        button.addTarget(self, action: #selector(self.moreButtonTapped), for: .touchUpInside)

        // Button Item
        let buttonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = buttonItem
    }

    override func setupUI() {
        super.setupUI()

        self.descriptionEffectView.layer.cornerRadius = 20
        self.descriptionEffectView.layer.masksToBounds = true

    }

    func setupButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.size.width/2
        button.layer.masksToBounds = true
    }

    func createPath() -> CGPath {

        self.setupButton(self.likeButton)
        self.setupButton(self.dislikeButton)
        self.setupButton(self.superLikeButton)

        let height: CGFloat = 47
        let path = UIBezierPath()
        let centerWidth = self.descriptionEffectView.frame.size.width/2

        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough

        // first curve down
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 40), y: 0),
                      controlPoint2: CGPoint(x: centerWidth - 45, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 45, y: height),
                      controlPoint2: CGPoint(x: (centerWidth + 40), y: 0))

        // complete the rect
        path.addLine(to: CGPoint(x: self.descriptionEffectView.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.descriptionEffectView.frame.width, y: self.descriptionEffectView.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.descriptionEffectView.frame.height))
        path.close()

        return path.cgPath
    }

    func complexShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = self.createPath()
        self.descriptionEffectView.layer.mask = shapeLayer
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.viewModel.favorite()
        }
    }

	// MARK: Private Methods

    private func setups() {
        self.setupViewModel()
        self.setupTinder()
        self.becomeFirstResponder()

        self.collectionView.contentInsetAdjustmentBehavior = .never
    }

	private func setupViewModel() {
		self.viewModel.completion = {
			self.setupTinder()
		}
		self.viewModel.load()
	}

    private func setupTinder() {
		self.title = self.viewModel.name
	}

    // MARK: Internal Methods

    func openUrl(_ urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @objc
    func moreButtonTapped() {

        let sheet = UIAlertController(title: nil, message: "Escolha a opção", preferredStyle: .actionSheet)

        if !self.viewModel.instagram.isEmpty {
            let title = String(format: "Instagram")
            sheet.addAction(UIAlertAction(title: title, style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let instagramHooks = String(format: "instagram://user?username=%@", self.viewModel.instagram)
                self.openUrl(instagramHooks)
            }))
        }

        if !self.viewModel.snapchat.isEmpty {
            let title = String(format: "snapchat")
            sheet.addAction(UIAlertAction(title: title, style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let snapHooks = String(format: "snapchat://add/%@", self.viewModel.snapchat.isEmpty)
                self.openUrl(snapHooks)
            }))
        }

        let title = String(format: "Delete")
        sheet.addAction(UIAlertAction(title: title, style: .default, handler: { (alert: UIAlertAction!) -> Void in
            guard let viewModel = self.viewModel else { return }
            PersistenceManager.delete(tinderID: viewModel.tinderID)
            self.pop()
        }))

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        }))

        self.present(sheet, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension TinderViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModel.photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let id: String = PhotoCollectionViewCell.identifier
		let collection: UICollectionView = collectionView
		let cell: UICollectionViewCell = collection.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)

		guard let photoCell = cell as? PhotoCollectionViewCell else {
			return UICollectionViewCell()
		}

		let photo = self.viewModel.photos[indexPath.row]
		let viewModel = PhotoViewModel(photoID: photo.id)
		photoCell.setup(viewModel: viewModel)

		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TinderViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
	}

	func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin: CGFloat = 0
		return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
	}

	func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}

	func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}


// FIXME:
extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(M_PI) / 180.0
    }
}
