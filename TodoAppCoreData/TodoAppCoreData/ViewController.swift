//
//  ViewController.swift
//  TodoAppCoreData
//
//  Created by e2phus on 2022/12/23.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var todoList = [ToDoList]()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "TodoCell")
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        self.fetchData()
        self.tableView.reloadData()
    }

    // MARK: - API
    func fetchData() {
        let fetchRequest = ToDoList.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            todoList = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Actions
    @objc func createTodo() {
        let controller = DetailViewController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    func configureNavigation() {
        self.navigationItem.title = "To Do List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createTodo))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        cell.topTitle.text = todoList[indexPath.row].title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd hh:mm:ss"
        
        if let todoDate = todoList[indexPath.row].date {
            cell.bottomDate.text = formatter.string(from: todoDate)
        }
        
        let savedLevel = todoList[indexPath.row].priorityLevel
        let level = PriorityLevel(rawValue: savedLevel)
        cell.priorityLevel.backgroundColor = level?.color
        
        return cell
    }  
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailViewController()
        controller.todoItem = todoList[indexPath.row]
        self.present(controller, animated: true)
    }
}

extension ViewController: DetailViewControllerDelegate {
    func didFinishSave() {
        self.fetchData()
        self.tableView.reloadData()
    }
}
