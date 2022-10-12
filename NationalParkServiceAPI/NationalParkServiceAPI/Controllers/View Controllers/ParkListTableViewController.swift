//
//  ParkListTableViewController.swift
//  NationalParkServiceAPI
//
//  Created by Esther on 10/6/22.
//

import UIKit

class ParkListTableViewController: UITableViewController {
    
   
    // Placeholder property
    var topLevel: TopLevelDictionary?
    var parksArray: [ParkData] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkController.fetchParks { [weak self]
            result in
            switch result {
            case .success(let topLevel):
                self?.topLevel = topLevel
                self?.parksArray = topLevel.data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("There was an error!", error.errorDescription!)
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parksArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "parkCell", for: indexPath) as? ParkTableViewCell else {return UITableViewCell()}
        let park = parksArray[indexPath.row]
        cell.updateViews()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetailVC",
              let destinationVC = segue.destination as? ParkDetailViewController,
              let selectedRow = tableView.indexPathForSelectedRow?.row else {return}
        // This is where we get the Park the user tapped on
        let parkToSend = parks[selectedRow]
        // Fetch individual park
        NetworkController.fetchSinglePark(for: parkToSend.parkCode) { result in
            switch result {
            case .success(let park):
                DispatchQueue.main.async {
                    destinationVC.parkData = park
                }
            case .failure(let error):
                print("There was an error!", error.errorDescription!)
            }
        }
    }

} // End of Class
