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
    //var image: Data
    var ref: DatabaseReference?
    var users: [String]
    
    init (name: String, descr: String, users: [String]) {
        self.name = name
        self.descr = descr
        //self.image = image
        self.users = users
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        name = snapshotValue["name"] as! String
        descr = snapshotValue["descr"] as! String
        //image = snapshotValue["image"] as! Data
        users = snapshotValue["users"] as! [String]
        ref = snapshot.ref
    }
    
    

}
