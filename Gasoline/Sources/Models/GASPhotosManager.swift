//
//  PhotosDataManager.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 1/30/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import AlamofireImage

import CoreML
import Vision


class GASPhotosManager: NSObject {

	static let shared = GASPhotosManager()
    let group = DispatchGroup()
    lazy var downloader = ImageDownloader(downloadPrioritization: .lifo)

    class func listAll() -> Results<GASPhoto> {
        let result = PersistenceManager.objects(objectType: GASPhoto.self)
        return result.filter("nsfw = 0")
    }
}

extension GASPhotosManager {

    func nsfwAll() {

        Log.i("NSFW rest: \(GASPhotosManager.listAll().count)")

        DispatchQueue.global(qos: .utility).async { //[weak self] in

            GASPhotosManager.listAll().forEach {

                self.group.enter()

                let photoID = $0.id
                guard let photo = GASPhoto.findById(id: photoID), let url = URL(string: photo.url) else {
                    return
                }

                let downloader = GASPhotosManager.shared.downloader
                downloader.download(URLRequest(url: url)) { response in
                    guard let image = response.value else {
                        return
                    }

                    GASPhoto.nsfw(photoID: photoID, image: image)
                    self.group.leave()
                }
            }

            self.group.wait()
        }
    }
}
