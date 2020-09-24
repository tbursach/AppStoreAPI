//
//  ItemSearchTableViewController.swift
//  AppleSearch
//
//  Created by Trevor Bursach on 9/24/20.
//

import UIKit

class ItemSearchTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var entitySearchBar: UISearchBar!
    @IBOutlet weak var entitySegmentedControl: UISegmentedControl!
    
    //MARK: - Properties
    var musicItems: [MusicTrack] = []
    var appItems: [AppItem] = []

    //MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        entitySearchBar.delegate = self

    }
    
    
    //MARK: - Actions
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        search()
        
    }
    
    //MARK: - Helper Functions and Methods
    
    func search() {
        guard let searchTerm = entitySearchBar.text, !searchTerm.isEmpty else { return }
        
        if entitySegmentedControl.selectedSegmentIndex == 0 {
            
            AppleStoreItemController.fetchMusicItems(searchTerm: searchTerm) { (result) in
                switch result {
                
                case .success(let musicTracks):
                    self.musicItems = musicTracks
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            AppleStoreItemController.fetchAppItems(searchTerm: searchTerm) { (result) in
                switch result {
                
                case .success(let apps):
                    self.appItems = apps
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch entitySegmentedControl.selectedSegmentIndex {
        
        case 0:
            return self.musicItems.count
            
        case 1:
            return self.appItems.count
        
        default:
        return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entityCell", for: indexPath) as? EntityTableViewCell else { return UITableViewCell() }
        
        switch entitySegmentedControl.selectedSegmentIndex {
        case 0:
            let track = musicItems[indexPath.row]
            cell.musicTrack = track
            cell.appItem = nil
        case 1:
            let app = appItems[indexPath.row]
            cell.appItem = app
            cell.musicTrack = nil
        default:
            break
        }
        
        cell.updateViews()

        return cell
    }

} // END OF CLASS

//MARK: - Extensions

extension ItemSearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
}
