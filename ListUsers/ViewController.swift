//
//  ViewController.swift
//  ListUsers
//
//  Created by Italo Stuardo on 3/4/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var idArray = [Int64]()
    var nameArray = [String]()
    var emailArray = [String]()
    var selectedId = Int64()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    func loadData(){
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            } else {
                if data != nil {
                    do {
                        let jsonResults = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [[String: Any]]
                        for json in jsonResults {
                            if let id = json["id"] as? Int64 {
                                self.idArray.append(id)
                            }
                            
                            if let name = json["name"] as? String {
                                self.nameArray.append(name)
                            }
                            
                            if let email = json["email"] as? String {
                                self.emailArray.append(email)
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = nameArray[indexPath.row]
        content.secondaryText = emailArray[indexPath.row]
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedId = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.userId = selectedId
        }
    }
}

