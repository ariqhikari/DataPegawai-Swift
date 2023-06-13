//
//  DetailViewController.swift
//  DataPegawai
//
//  Created by Ariq Hikari on 12/06/23.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

  @IBOutlet weak var imageDetail: UIImageView!
  @IBOutlet weak var firstName: UILabel!
  @IBOutlet weak var lastName: UILabel!
  @IBOutlet weak var email: UILabel!
  @IBOutlet weak var birthDate: UILabel!
  
  var employeesID = 0
  
  // deklarasi dari core data appdelegate
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
  func setupView() {
    let editButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(edit))
    let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteAction))
    self.navigationItem.rightBarButtonItems = [editButton, deleteButton]
  }
  
  @objc func edit() {
    let controller = self.storyboard?.instantiateViewController(withIdentifier: "addFormViewController") as! AddFormViewController
    controller.employeesID = employeesID
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func deleteAction () {
    let alertController = UIAlertController(title: "Warning", message: "Are you sure to delete this item?", preferredStyle: .actionSheet)
    let alertActionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
      let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
      employeesFetch.fetchLimit = 1
      // kondisi dengan predicate
      employeesFetch.predicate = NSPredicate(format: "id == \(self.employeesID)")
      
      // run
      let result = try! self.context.fetch(employeesFetch)
      let employeesToDelete = result.first as! NSManagedObject
      self.context.delete(employeesToDelete)
      
      do {
        try self.context.save()
      } catch {
        print(error.localizedDescription)
      }
      self.navigationController?.popViewController(animated: true )
    }
    let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel)
    alertController.addAction(alertActionYes)
    alertController.addAction(alertActionCancel)
    self.present(alertController, animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
    employeesFetch.fetchLimit = 1
    // kondisi dengan predicate
    employeesFetch.predicate = NSPredicate(format: "id == \(employeesID)")
    
    // run
    let result = try! context.fetch(employeesFetch)
    let employees: Employees = result.first as! Employees
    firstName.text = employees.firstName
    lastName.text = employees.lastName
    email.text = employees.email
    birthDate.text = employees.birthDate
   
    if let imageData = employees.image {
      imageDetail.image = UIImage(data: imageData as Data)
      imageDetail.layer.cornerRadius = imageDetail.frame.height / 2
      imageDetail.clipsToBounds = true
    }
    
    self.navigationItem.title = "\(employees.firstName!) \(employees.lastName!)"
  }

}
