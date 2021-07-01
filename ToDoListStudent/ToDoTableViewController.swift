//
//  ToDoTableViewController.swift
//  ToDoListStudent
//
//  Created by Danya on 01.07.2021.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        
        let alertControler = UIAlertController(title: "Новая задача", message: "Пожалуйста, введите новую задачу", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { action in
            let textField = alertControler.textFields?.first
            if let newTask = textField?.text {
                self.tasks.insert(newTask, at: 0)
                self.tableView.reloadData()
            }
        }
        
        alertControler.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { action in }
        
        alertControler.addAction(saveAction)
        alertControler.addAction(cancelAction)
        
        present(alertControler, animated: true, completion: nil)
        
    }
    
    
    var  tasks: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = tasks[indexPath.row]

        return cell
    }
    

    
}
