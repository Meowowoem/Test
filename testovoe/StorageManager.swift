////
////  StorageManager.swift
////  testovoe
////
////  Created by Anastasia on 22.12.2019.
////  Copyright © 2019 Anastasia. All rights reserved.
////
//
//import RealmSwift
//
//let realm = try! Realm()
//
//
//class StorageManager {
//    
//    var users: Results<User>!
//    var groups: Results<Group>!
//    
//    static func saveObject(_ user: User) {
//        try! realm.write {
//            realm.add(user)
//        }
//    }
//    
//    static func saveObjectGroup(_ group: Group) {
//        try! realm.write {
//            realm.add(group)
//        }
//    }
//    
//    static func getDataUsers(_ login: String) -> User {
//        var users: Results<User>!
//        users = realm.objects(User.self)
//        let request = users.filter("login ='\(login)'")
//        if request.isEmpty {
//            return User()
//        } else {
//            return request[0]
//        }
//    }
//    
//    static func getDataGroups(_ name: String) -> Group {
//        var groups: Results<Group>!
//        groups = realm.objects(Group.self)
//        let request = groups.filter("name ='\(name)'")
//        return request[0]
//    }
//    
//    static func deleteObject(_ name: Group) {
//        try! realm.write {
//            realm.delete(name)
//        }
//    }
//}
