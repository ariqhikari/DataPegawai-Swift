//
//  ViewController.swift
//  DataPegawai
//
//  Created by Ariq Hikari on 08/06/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  var employees:[Employees] = []
  var filteredEmployees:[Employees] = []
  let searchController = UISearchController(searchResultsController: nil)
  
  // deklarasi dari core data appdelegate
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    do {
      let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
      employees = try context.fetch(employeesFetch) as! [Employees]
    } catch {
      print(error.localizedDescription)
    }
    self.tableView.reloadData()
  }

  func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    searchController.searchBar.placeholder = "Find Employees"
    searchController.hidesNavigationBarDuringPresentation = true
    searchController.searchResultsUpdater = self
    
    tableView.tableHeaderView = searchController.searchBar
    
    self.navigationItem.title = "Employees"
  }
 
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.isActive && !((searchController.searchBar.text?.isEmpty)!) {
      return filteredEmployees.count
    }
    return employees.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var employee = employees[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    
    if searchController.isActive && !((searchController.searchBar.text?.isEmpty)!) {
      employee = filteredEmployees[indexPath.row]
    }
    
    cell.titleCell.text = employee.firstName
    cell.subtitleCell.text = employee.lastName
    if let imageData = employee.image {
      cell.imageCell.image = UIImage(data: imageData as Data)
      cell.imageCell.layer.cornerRadius = cell.imageCell.frame.height / 2
      cell.imageCell.clipsToBounds = true
    }
    
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = self.storyboard?.instantiateViewController(withIdentifier: "detailController") as! DetailViewController
    controller.employeesID = Int(employees[indexPath.row].id)
    self.navigationController?.pushViewController(controller, animated: true)
  }
}

extension ViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let keyword = searchController.searchBar.text!
    if keyword.count > 0 {
      print("kata kunci \(keyword)")
      
      let employeesSearch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
      
      let predicate1 = NSPredicate(format: "firstName CONTAINS[c] %@", keyword)
      let predicate2 = NSPredicate(format: "lastName CONTAINS[c] %@", keyword)
      
      let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates: [predicate1, predicate2])
      employeesSearch.predicate = predicateCompound
      
      // run query
      do {
        let employeesFilters = try context.fetch(employeesSearch) as! [NSManagedObject]
        filteredEmployees = employeesFilters as! [Employees]
      } catch {
        print(error)
      }
      self.tableView.reloadData()
    } else {
      self.tableView.reloadData()
    }
  }
}
