//
//  GroupViewController.swift
//  testovoe
//
//  Created by Anastasia on 23.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import Firebase

class GroupViewController: UIViewController {
    
    var groupTable: UITableView!
    
    let refresh = UIRefreshControl()
    
    var user: Person!
    var ref: DatabaseReference!
    var groups = Array<Group>()
    
    override func viewDidAppear(_ animated: Bool) {
        groupTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        ref.removeAllObservers()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Группы"
        
        setupTable()

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewGroup))
        
        refresh.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        groupTable.refreshControl = refresh
    }
    
    func getData() {
        ref = Database.database().reference(withPath: "groups")
        
        ref.observe(.value) { [weak self] (snapshot) in
            var _groups = Array<Group>()
            for item in snapshot.children {
                let group = Group(snapshot: item as! DataSnapshot)
                _groups.append(group)
            }
            self?.groups = _groups
            self?.groupTable.reloadData()
        }
    }
    
    
    @objc func updateTable() {
        groupTable.reloadData()
        refresh.endRefreshing()
    }
    
    func setupTable() {
        groupTable = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(groupTable)
        groupTable.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        groupTable.delegate = self
        groupTable.dataSource = self
        groupTable.register(GroupTableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    @objc func addNewGroup() {
        let newGroupVC = NewGroupViewController()
        navigationController?.pushViewController(newGroupVC, animated: true)
    }
    
    
    
}

//MARK: - Table view datasource
extension GroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupTableViewCell
        
        let group = groups[indexPath.row]
        cell.nameLabel.text = group.name
        cell.descriptionLabel.text = group.descr
        
        let url = URL(string: group.image!)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageGroup.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: - Send data to GroupVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newGroupVC = NewGroupViewController()
        newGroupVC.currentId = groups[indexPath.row].id
        
        navigationController?.pushViewController(newGroupVC, animated: true)
    }
    //MARK: - Delete groups
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            let name = groups[indexPath.row].id
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            groupTable.reloadData()
            
            ref.child(name!).removeValue()
        }
    }
    
}


