//
//  File.swift
//  testovoe
//
//  Created by Anastasia on 23.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import Firebase


class Group {
    
    var name: String
    var descr: String
    var image: String?
    var ref: DatabaseReference?
    var users: [String: Any]?
    var id: String?
    
    init (name: String, descr: String) {
        self.name = name
        self.descr = descr
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        name = snapshotValue["name"] as! String
        descr = snapshotValue["descr"] as! String
        image = snapshotValue["groupImage"] as? String
        users = snapshotValue["users"] as? [String: Any]
        ref = snapshot.ref
        id = snapshotValue["id"] as? String
    }
    
    init(snap: DataSnapshot) {
        let snapshotValue = snap.value as! [String: Any]
        name = snapshotValue["name"] as! String
        descr = snapshotValue["descr"] as! String
        image = snapshotValue["groupImage"] as? String
        users = snapshotValue["users"] as? [String: Any]
        ref = snap.ref
        id = snapshotValue["id"] as? String
    }
    
    init(name: String, descr: String, image: String, users: [String: Any], id: String) {
        self.name = name
        self.descr = descr
        self.image = image
        self.users = users
        self.id = id
    }
    

}
