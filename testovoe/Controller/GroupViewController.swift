//
//  GroupViewController.swift
//  testovoe
//
//  Created by Anastasia on 23.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import RealmSwift

class GroupViewController: UIViewController {
    
    var groupTable: UITableView!
    
    var groups: Results<Group>!
    
    let refresh = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groups = realm.objects(Group.self)
        
        
        
        
        title = "Группы"
        
        setupTable()
        updateTable()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewGroup))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateTable))
        
        refresh.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        groupTable.refreshControl = refresh
    }
    
    
    @objc func updateTable() {
        groupTable.reloadData()
        refresh.endRefreshing()
    }
    
    func setupTable() {
        groupTable = UITableView(frame: view.bounds, style: .plain)
        groupTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
        cell.imageGroup.image = UIImage(data: group.image!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: - Send data to GroupVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newGroupVC = NewGroupViewController()
        newGroupVC.currentName = groups[indexPath.row].name
        
        navigationController?.pushViewController(newGroupVC, animated: true)
    }
    //MARK: - Delete groups
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            let group = groups[indexPath.row]
            StorageManager.deleteObject(group)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            groupTable.reloadData()
        }
    }
    
}


