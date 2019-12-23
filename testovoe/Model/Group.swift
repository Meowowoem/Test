//
//  File.swift
//  testovoe
//
//  Created by Anastasia on 23.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//


import RealmSwift

class Group: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var descr = ""
    @objc dynamic var image: Data?
    
    convenience init (name: String, descr: String, image: Data?) {
        self.init()
        self.name = name
        self.descr = descr
        self.image = image
    }
    
    
    
//    func saveGroup() {
//
//        for group in allGroups {
//
//            let image = UIImage(named: group)
//            guard let imageData = image?.pngData() else { return }
//
//            let newGroup = Group()
//
//            newGroup.name = group
//            newGroup.descr = "Описание группы"
//            newGroup.image = imageData
//            StorageManager.saveObjectGroup(newGroup)
//        }
//    }
}
