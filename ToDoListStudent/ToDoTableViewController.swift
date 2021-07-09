//
//  ToDoTableViewController.swift
//  ToDoListStudent
//
//  Created by Danya on 01.07.2021.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    //сохранение задачи в coreData
    func saveTask(withTitle title: String) {
        
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else { return }
        
        let taskObject = Tasks(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
            tasks.append(taskObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    private func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        return cell
    }
    //MARK: - IBACTION saveTask and remove
    
    @IBAction func newCellTasks(_ sender: UIBarButtonItem) {
        
        let alertControler = UIAlertController(title: "Новая задача", message: "Пожалуйста, введите новую задачу", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { action in
            let textField = alertControler.textFields?.first
            if let newTask = textField?.text {
                self.saveTask(withTitle: newTask)
                self.tableView.reloadData()
            }
        }
        
        alertControler.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { action in }
        
        alertControler.addAction(saveAction)
        alertControler.addAction(cancelAction)
        
        present(alertControler, animated: true, completion: nil)
        
    }
    
    @IBAction func removeAction(_ sender: UIBarButtonItem) {
        
        let alertControler = UIAlertController(title: "Удалить все записи?", message: "действие не возможно отменить", preferredStyle: .alert)
        let alertCancel = UIAlertAction(title: "Отмена", style: .default)
        
        let alertRemove = UIAlertAction(title: "Ок", style: .default) { action in
            let context = self.getContext()
            let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
            if let objects = try? context.fetch(fetchRequest) {
                for object in objects {
                    context.delete(object)
                }
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            tasks.removeAll(keepingCapacity: false)
            self.tableView.reloadData()
        }
        
        alertControler.addAction(alertRemove)
        alertControler.addAction(alertCancel)
        
        present(alertControler, animated: true)
    }
}




