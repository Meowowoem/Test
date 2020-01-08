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
    
    let ref = Database.database()
    var groupUsers = Array<String>()
    var tableUsers: UITableView!
    var currentId: String?
    let group = DispatchGroup()
    var users = Array<Person>()
    var refresh = UIRefreshControl()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTable()
        getUsers()
        getAllUsers()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMember))
        
        refresh.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        tableUsers.refreshControl = refresh
        
    }
    
    @objc func updateTable() {
        tableUsers.reloadData()
        refresh.endRefreshing()
    }
    
    func setupTable() {
        tableUsers = UITableView(frame: view.bounds, style: .plain)
        tableUsers.register(GroupUsersTableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableUsers)
        tableUsers.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableUsers.delegate = self
        tableUsers.dataSource = self
    }
    
    func getUsers() {
        ref.reference(withPath: "groups").child(currentId!).child("users").observe(.value) { [weak self] snapshot in
            
            let value = snapshot.value as? NSDictionary
            
            let name = value?.allKeys as! [String]
            self?.groupUsers = name.sorted()
            self?.tableUsers.reloadData()
        }
        
    }
    
    func getAllUsers() {
        ref.reference(withPath: "users").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            var _users = Array<Person>()
            var array = Array<Person>()
            
            for item in snapshot.children {
                let user = Person(snapshot: item as! DataSnapshot)
                _users.append(user)
            }
            var i = 0
            for item in self!.groupUsers {
                while item != _users[i].nickname {
                    i += 1
                }
                
                array.append(_users[i])
                self?.users = array
                self?.tableUsers.reloadData()
                i = 0
            }
            
            
        }
    }
    
    @objc func addNewMember() {
        let alert = UIAlertController(title: "Введите никнейм", message: nil , preferredStyle: .alert)
        
        alert.addTextField {  textField in
        }
        let save = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            let text = (alert.textFields?.first!.text)?.capitalized
            
            if text != "" {
                
                var allUsers = [String]()
                self!.group.enter()
                self!.ref.reference(withPath: "users").observeSingleEvent(of: .value) { [weak self] snapshot in
                    let value = snapshot.value as? NSDictionary
                    for item in value! {
                        if let name = item.value as? [String: String] {
                            allUsers.append(name["nickname"]!)
                        }
                    }
                    self!.group.leave()
                }
                self!.group.notify(queue: DispatchQueue.main) {
                    if allUsers.contains(text!) {
                        if self!.groupUsers.contains(text!) {
                            self!.displayInfo(text: "Пользователь уже в группе!")
                        } else {
                            self!.ref.reference(withPath: "groups").child(self!.currentId!).child("users").child(text!).setValue(["role": "user"])
                            
                            self!.displayInfo(text: "Пользователь добавлен!")
                            self?.getAllUsers()
                            
                        }
                    } else {
                        self!.displayInfo(text: "Такого пользователя нет!")
                    }
                }
            } else {
                self!.displayInfo(text: "Поле не должно быть пустым!")
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(save)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    func displayInfo(text: String) {
        let alert = UIAlertController(title: "Внимание", message: text , preferredStyle: .alert)
        let action = UIAlertAction(title: "Хорошо", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}

extension GroupUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupUsersTableViewCell
        
        let user = users[indexPath.row]
        
        var isAdmin = false
        ref.reference(withPath: "groups").child(currentId!).child("users").child(users[indexPath.row].nickname!).observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? NSDictionary
            
            if value?["role"] as? String == "admin" {
                isAdmin = true
            }
            
            if isAdmin == true {
                cell.nameLabel.text = "[Админ] " + user.nickname!
            } else {
                cell.nameLabel.text = user.nickname
            }
            
        }
        
        cell.nameLabel.text = user.nickname
        
        let url = URL(string: user.image ?? "")
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            var isAdmin = false
            ref.reference(withPath: "groups").child(currentId!).child("users").child(users[indexPath.row].nickname!).observeSingleEvent(of: .value) { snapshot in
                let value = snapshot.value as? NSDictionary
                
                if value?["role"] as? String == "admin" {
                    isAdmin = true
                }
                
                if isAdmin == true {
                    self.displayInfo(text: "Нельзя удалить админа!")
                } else {
                    self.ref.reference(withPath: "groups").child(self.currentId!).child("users").child(self.users[indexPath.row].nickname!).removeValue()
                    self.users.remove(at: indexPath.row)
                    
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableUsers.reloadData()
                }
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailUserViewController()
        let user = users[indexPath.row]
//        print(users[indexPath.row].firstName)
//        print(users[indexPath.row].lastName)
//        print(users[indexPath.row].nickname)
//        print(users[indexPath.row].dateOfBirth)
        
//        detailVC.profileView.firstNameTextField.text? = user.firstName
//        detailVC.profileView.lastNameTextField.text? = user.lastName
//        detailVC.profileView.loginTextField.text? = user.nickname
//        detailVC.profileView.dateOfBirthTextField.text? = user.dateOfBirth
        
        detailVC.nickname = user.nickname
        detailVC.firstName = user.firstName
        detailVC.lastName = user.lastName
        detailVC.date = user.dateOfBirth

        guard let urlString = users[indexPath.row].image else {
            detailVC.profileView.photoImage.image = UIImage(named: "personPhoto")
            return
        }
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        detailVC.profileView.photoImage.image = image
                    }
                }
            }
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
