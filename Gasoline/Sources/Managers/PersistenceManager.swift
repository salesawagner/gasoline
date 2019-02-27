//
//  PersistenceManager.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 28/02/17.
//  Copyright © 2017 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift

class PersistenceManager: NSObject {

	// MARK: - Properties

	static var realm: Realm? {
		do {
			let realm = try Realm()
			return realm
		} catch let error {
			Log.e(error.localizedDescription)
		}
		return nil
	}

	// MARK: - Public Methods

	class func add(_ object: Object) {
		guard let realm = PersistenceManager.realm else {
			return
		}
		realm.add(object, update: true)
	}
	class func add(_ objects: [GASTinder], completion: CompletionSuccess? = nil) {
		guard let realm = PersistenceManager.realm else {
			completion?(false)
			return
		}
		
		PersistenceManager.write {
			let tinders = List<GASTinder>()
			tinders.append(objectsIn: objects)
			tinders.setValue(Date(), forKey: "lastUpdate")
			realm.add(objects, update: true)
			completion?(true)
		}
	}
	class func write(block: () -> Void) {
		guard let realm = PersistenceManager.realm else {
			return
		}
		
		if realm.isInWriteTransaction {
			block()
		} else {
		
			realm.beginWrite()
			block()
			do {
				try realm.commitWrite()
			} catch let error {
				Log.e(error.localizedDescription)
			}
		}
	}

	class func objects<T: Object>(objectType: T.Type) -> Results<T> {
		var realm: Realm! // FIXME:
		if let persistence = PersistenceManager.realm {
			realm = persistence
		} else {
			do {
				realm = try Realm()
			} catch let error {
				Log.e(error.localizedDescription)
			}
		}
		return realm.objects(objectType)
	}
	
	class func delete(objects: Results<GASTinder>) {
		guard let realm = self.realm else { return }
		
		self.write {
			realm.delete(objects)
		}
	}

	class func delete(tinderID: String) {
		guard let realm = self.realm, let tinder = GASTinder.findById(id: tinderID) else { return }
		
		self.write {
			realm.delete(tinder)
		}
	}

	class func delete(photoID: String) {
		guard let realm = self.realm, let photo = GASPhoto.findById(id: photoID) else { return }
		
		self.write {
			realm.delete(photo)
		}
	}

	
	class func clear() {
		guard let realm = self.realm else { return }
		self.write {
			realm.deleteAll()
		}
	}
}
