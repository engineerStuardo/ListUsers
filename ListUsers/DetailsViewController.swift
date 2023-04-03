//
//  DetailsViewController.swift
//  ListUsers
//
//  Created by Italo Stuardo on 3/4/23.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    var userId: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if userId != 0 {
            let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(userId)")
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: url!) { data, response, error in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } else {
                    if data != nil {
                        do {
                            let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                            DispatchQueue.main.async {
                                if let name = jsonResponse["name"] as? String {
                                    self.nameLabel.text = "Name: \(name)"
                                }
                                
                                if let email = jsonResponse["email"] as? String {
                                    self.emailLabel.text = "Email: \(email)"
                                }
                                
                                if let website = jsonResponse["website"] as? String {
                                    self.websiteLabel.text = "Website: \(website)"
                                }
                                
                                if let phone = jsonResponse["phone"] as? String {
                                    self.phoneLabel.text = "Phone: \(phone)"
                                }
                                
                                if let company = jsonResponse["company"] as? [String: Any] {
                                    if let name = company["name"] as? String {
                                        self.companyLabel.text = "Company: \(name)"
                                    }
                                }
                                
                                if let address = jsonResponse["address"] as? [String: Any] {
                                    if let city = address["city"] as? String {
                                        self.cityLabel.text = "City: \(city)"
                                    }
                                    
                                    if let zip = address["zipcode"] as? String {
                                        self.zipLabel.text = "Zip: \(zip)"
                                    }
                                }
                            }
                        } catch {
                            print("Error")
                        }
                    }
                }
            }
            
            dataTask.resume()
        }
    }
}
