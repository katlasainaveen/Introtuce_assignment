//
//  Users_ViewController.swift
//  ios_assignment
//
//  Created by Sai Naveen Katla on 16/02/21.
//

import UIKit
import Firebase

let DEFAULT_IMAGE = "https://www.google.co.in/url?sa=i&url=https%3A%2F%2Fin.pinterest.com%2Fpin%2F346777240058194395%2F&psig=AOvVaw18dEYXWfmRNOXjDWVTwoWh&ust=1613561393724000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCOidu-em7u4CFQAAAAAdAAAAABAD"

class Users_ViewController: UIViewController {

    @IBOutlet weak var table_view: UITableView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var users_array: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table_view.delegate = self
        self.table_view.dataSource = self
        
        self.getDataFromFirebase()
        
        self.activity.startAnimating()
    }
    
    func getDataFromFirebase() {
        Firestore.firestore().collection("Users").order(by: "timestamp", descending: true).addSnapshotListener({ [weak self] (snapshot, error) in
            if error == nil {
                guard let docs = snapshot?.documents else {
                    return
                }
                
                self?.users_array.removeAll()
                
                for doc in docs {
                    self?.users_array.append(User(name: doc["name"] as? String ?? "name",
                                            image_url: doc["image_url"] as? String ?? DEFAULT_IMAGE,
                                            gender: doc["gender"] as? String ?? "gender",
                                            age: doc["age"] as? String ?? "2000-02-02",
                                            place: doc["place"] as? String ?? "place",
                                            docId: doc.documentID))
                }
                self?.table_view.reloadData()
            }
        })
        
        
    }
    

}

extension Users_ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table_view.dequeueReusableCell(withIdentifier: "users_cell", for: indexPath) as! Users_TableViewCell
        
        let data = users_array[indexPath.row]
        
        cell.profile_imag.loadImageCacheWithUrlString(urlString: data.image_url)
        cell.name.text = data.name.capitalized
        
        cell.docId = data.docId
        cell.delegate = self
        
        let details = "\(data.gender.capitalized) | \(calculateAge(string: data.age)) | \(data.place.capitalized)"
        cell.details.text = details
        
        return cell
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    func calculateAge(string: String) -> Int {
        let comp = Calendar.current.dateComponents([.year], from: dateFormatter.date(from: string) ?? Date(), to: Date())
        return comp.year!
    }
    
    
}

extension Users_ViewController: UsersTableViewCellDelegate {
    
    func didTapButton(at docId: String) {
        self.activity.alpha = 1
        
        Firestore.firestore().collection("Users").document(docId).delete { [weak self] (error) in
            if error == nil {
                self?.Alert(title: "Success", message: "Data Deleted")
                self?.activity.alpha = 0
            }
            else {
                self?.Alert(title: "Error", message: "\(error!.localizedDescription)")
                self?.activity.alpha = 0
            }
        }
        
    }
    
}
