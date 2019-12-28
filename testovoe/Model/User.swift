//
//  User.swift
//  testovoe
//
//  Created by Anastasia on 22.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import Firebase

class Person {
    var uid: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var nickname: String?
    var dateOfBirth: String?
    var ref: DatabaseReference?
    
    
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
    
    init(firstName: String, lastName: String, nickname: String, dateOfBirth: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.nickname = nickname
        self.dateOfBirth = dateOfBirth

    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        firstName = snapshotValue["firstName"] as? String
        lastName = snapshotValue["lastName"] as? String
        nickname = snapshotValue["nickname"] as? String
        dateOfBirth = snapshotValue["dateOfBirth"] as? String
        ref = snapshot.ref
    }
    
    
}
