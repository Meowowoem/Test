//
//  TestViewController.swift
//  testovoe
//
//  Created by Anastasia on 12.01.2020.
//  Copyright © 2020 Anastasia. All rights reserved.
//

import UIKit
import Firebase


class TestViewController: UIViewController {

    var ref = Database.database().reference(withPath: "groups")
    var group = Array<Group>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in

            for item in snapshot.children {
                
                let snap = item as! DataSnapshot
                let snapshotValue = snap.value as! [String: Any]
               
                let _group = Group(name: snapshotValue["name"] as! String,
                                   descr: snapshotValue["descr"] as! String,
                                   image: snapshotValue["groupImage"] as! String,
                                   users: snapshotValue["users"] as! [String : Any],
                                   id: snapshotValue["id"] as! String)
                self?.group.append(_group)

            }
            print(self!.group[1].users!.keys)
        }
    }
    


}
