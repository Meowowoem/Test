//
//  GroupUsersViewController.swift
//  testovoe
//
//  Created by Anastasia on 29.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import Firebase

class GroupUsersViewController: UIViewController {
    
    var groupUsers = ["DSadasd"]
    var tableUsers: UITableView!
    var currentId: String?
    let ref = Database.database().reference(withPath: "groups")
    
    override func viewDidDisappear(_ animated: Bool) {
        saveUsers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTable()
        getUsers()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMember))
        
        
        
    }
    
    func setupTable() {
        tableUsers = UITableView(frame: view.bounds, style: .plain)
        tableUsers.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableUsers)
        tableUsers.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableUsers.delegate = self
        tableUsers.dataSource = self
    }
    
    func getUsers() {
        ref.child(currentId!).observeSingleEvent(of: .value) { [weak self] snapshot in
            
            let value = snapshot.value as? NSDictionary
            let name = value?["users"] as? String ?? ""
            let newName = name.components(separatedBy: ", ")
            self?.groupUsers = newName
            self?.tableUsers.reloadData()
        }
    }
    
    func saveUsers() {
        var string = ""
        for i in groupUsers {
            string.append(i + ", ")
        }
        if string.isEmpty == false {
            string.removeLast()
            string.removeLast()
        }
        print(string)
        
        
        ref.child(currentId!).updateChildValues(["users": string])
    }
    
    @objc func addNewMember() {
        let alert = UIAlertController(title: "Введите никнейм", message: nil , preferredStyle: .alert)
        
        alert.addTextField {  textField in
        }
        let save = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            let text = alert.textFields?.first!
            if text?.text != "" {
                self!.groupUsers.append((alert.textFields?.first!.text)!)
                self!.tableUsers.reloadData()
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    
    
}

extension GroupUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = groupUsers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            groupUsers.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableUsers.reloadData()
        }
    }
}
