//
//  AddFormViewController.swift
//  DataPegawai
//
//  Created by Ariq Hikari on 08/06/23.
//

import UIKit
import CoreData

class AddFormViewController: UIViewController {

  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var imageEmployees: UIImageView!
  
  var employeesID = 0
  let imagePicker = UIImagePickerController()
  
  // deklarasi dari core data appdelegate
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  func setupView() {
    self.navigationItem.title = "Add Form Employees"
    
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    imagePicker.sourceType = .photoLibrary
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if employeesID != 0 {
      let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
      employeesFetch.fetchLimit = 1
      // kondisi dengan predicate
      employeesFetch.predicate = NSPredicate(format: "id == \(employeesID)")
      
      // run
      let result = try! context.fetch(employeesFetch)
      let employees: Employees = result.first as! Employees
      firstNameTextField.text = employees.firstName
      lastNameTextField.text = employees.lastName
      emailTextField.text = employees.email
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let date = dateFormatter.date(from: employees.birthDate!)

      datePicker.date = date!
      imageEmployees.image = UIImage(data: employees.image!)
    }
  }
  

  @IBAction func buttonSave(_ sender: Any) {
    guard let firstName = firstNameTextField.text, firstName != "" else {
      let alertController = UIAlertController(title: "Warning", message: "First Name is required", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "Yes", style: .default)
      alertController.addAction(alertAction)
      self.present(alertController, animated: true)
      return
    }
    
    guard let lastName = lastNameTextField.text, lastName != "" else {
      let alertController = UIAlertController(title: "Warning", message: "Last Name is required", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "Yes", style: .default)
      alertController.addAction(alertAction)
      self.present(alertController, animated: true)
      return
    }

    guard let email = emailTextField.text, email != "" else {
      let alertController = UIAlertController(title: "Warning", message: "Email is required", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "Yes", style: .default)
      alertController.addAction(alertAction)
      self.present(alertController, animated: true)
      return
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let birthDate = dateFormatter.string(from: datePicker.date)
    
    // check dari halaman edit atau add
    if employeesID > 0 {
      let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
      employeesFetch.fetchLimit = 1
      // kondisi dengan predicate
      employeesFetch.predicate = NSPredicate(format: "id == \(employeesID)")

      // run
      let result = try! context.fetch(employeesFetch)
      let employees: Employees = result.first as! Employees

      employees.firstName = firstName
      employees.lastName = lastName
      employees.email = email
      employees.birthDate = birthDate

      if let img = imageEmployees.image {
        let data = img.pngData() as NSData?
        employees.image = data as Data?
      }

      // save ke coredata
      do {
        try context.save()
      } catch {
        print(error.localizedDescription)
      }

    } else {
      // add ke employees entity
      let employees = Employees(context: context)

      // auto increment
      let request: NSFetchRequest = Employees.fetchRequest()
      let sortDescriptors = NSSortDescriptor(key: "id", ascending: false)
      request.sortDescriptors = [sortDescriptors]
      request.fetchLimit = 1

      var maxID = 0
      do {
        let lastEmployees = try context.fetch(request)
        maxID = Int(lastEmployees.first?.id ?? 0)
      } catch {
        print(error.localizedDescription)
      }

      employees.id = Int32(maxID) + 1
      employees.firstName = firstName
      employees.lastName = lastName
      employees.email = email
      employees.birthDate = birthDate

      if let img = imageEmployees.image {
        let data = img.pngData() as NSData?
        employees.image = data as Data?
      }
      
      // save ke coredata
      do {
        try context.save()
      } catch {
        print(error.localizedDescription)
      }
    }

    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func takeAPicture(_ sender: Any) {
    self.selectPhotoFromLibrary()
  }
  
  func selectPhotoFromLibrary() {
    self.present(imagePicker, animated: true)
  }
}

extension AddFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      self.imageEmployees.contentMode = .scaleToFill
      self.imageEmployees.image = pickedImage
    }
    dismiss(animated: true)
  }
}
