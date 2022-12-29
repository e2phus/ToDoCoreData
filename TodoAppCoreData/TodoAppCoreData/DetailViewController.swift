//
//  DetailViewController.swift
//  TodoAppCoreData
//
//  Created by e2phus on 2022/12/27.
//

import UIKit
import CoreData

enum PriorityLevel: Int16 {
    case level1
    case level2
    case level3
}

extension PriorityLevel {
    var color: UIColor {
        switch self {
        case .level1:
            return .green
        case .level2:
            return .orange
        case .level3:
            return .red
        }
    }
    
    var title: String {
        switch self {
        case .level1:
            return "Low"
        case .level2:
            return "Normal"
        case .level3:
            return "High"
        }
    }
}

protocol DetailViewControllerDelegate {
    func didFinishSave()
}

class DetailViewController: UIViewController {

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isPickerOpen = true
    var priorityLevel = PriorityLevel.level1
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var delegate: DetailViewControllerDelegate?
    var todoItem: ToDoList?
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var openCloseButton: UIButton!
    @IBOutlet weak var priorityLevel1: UIButton! {
        didSet {
            priorityLevel1.layer.cornerRadius = 20
            priorityLevel1.setTitle(PriorityLevel.level1.title, for: .normal)
        }
    }
    @IBOutlet weak var priorityLevel2: UIButton! {
        didSet {
            priorityLevel2.layer.cornerRadius = 20
            priorityLevel2.setTitle(PriorityLevel.level2.title, for: .normal)
        }
    }
    @IBOutlet weak var priorityLevel3: UIButton! {
        didSet {
            priorityLevel3.layer.cornerRadius = 20
            priorityLevel3.setTitle(PriorityLevel.level3.title, for: .normal)
        }
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openCloseButton.setTitle("Close", for: .normal)
        
        if let todoItem = todoItem {
            titleTextField.text = todoItem.title
            datePicker.date = todoItem.date ?? Date()
            
            let level = PriorityLevel(rawValue: todoItem.priorityLevel)
            priorityLevel = level ?? .level1
            
            priorityLevel1.backgroundColor = .clear
            priorityLevel2.backgroundColor = .clear
            priorityLevel3.backgroundColor = .clear
            
            switch level {
            case .level1:
                priorityLevel1.backgroundColor = level?.color
            case .level2:
                priorityLevel2.backgroundColor = level?.color
            case .level3:
                priorityLevel3.backgroundColor = level?.color
            default:
                break
            }
        } else {
            deleteButton.isHidden = true
        }
    }


    @IBAction func pickerOpenOrClose(_ sender: UIButton) {
        
        isPickerOpen.toggle()
        UIView.animate(withDuration: 0.25) {
            if self.isPickerOpen {
                self.datePickerHeight.priority = UILayoutPriority(240)
                self.openCloseButton.setTitle("Close", for: .normal)
            } else {
                self.datePickerHeight.priority = UILayoutPriority(900)
                self.openCloseButton.setTitle("Open", for: .normal)
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func selectLevel(_ sender: UIButton) {
        
        priorityLevel1.backgroundColor = .clear
        priorityLevel2.backgroundColor = .clear
        priorityLevel3.backgroundColor = .clear
        
        if sender.currentTitle == PriorityLevel.level1.title {
            sender.backgroundColor = PriorityLevel.level1.color
            priorityLevel = .level1
        } else if sender.currentTitle == PriorityLevel.level2.title {
            sender.backgroundColor = PriorityLevel.level2.color
            priorityLevel = .level2
        } else if sender.currentTitle == PriorityLevel.level3.title {
            sender.backgroundColor = PriorityLevel.level3.color
            priorityLevel = .level3
        }
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        
        if let todoItem = todoItem {
            // Update
            saveButton.setTitle("Update", for: .normal)
            todoItem.title = titleTextField.text
            todoItem.priorityLevel = priorityLevel.rawValue
            todoItem.date = datePicker.date
            
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            appDelegate.saveContext()
            
            delegate?.didFinishSave()
            self.dismiss(animated: true, completion: nil)
            return
        }
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "ToDoList", in: context) else { return }
        
        guard let managedObject = NSManagedObject(entity: entityDescription, insertInto: context) as? ToDoList else { return }
        
        managedObject.title = titleTextField.text
        managedObject.priorityLevel = priorityLevel.rawValue
        managedObject.date = datePicker.date
        managedObject.id = UUID()
        
        appDelegate.saveContext()
        
        delegate?.didFinishSave()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if let todoItem = todoItem {
            context.delete(todoItem)
            appDelegate.saveContext()
            
            delegate?.didFinishSave()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
