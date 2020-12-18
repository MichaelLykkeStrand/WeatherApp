//
//  WeatherLookupViewController.swift
//  WeatherApp
//
//  Created by Michael Strand on 08/11/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import UIKit
import GooglePlaces

class WeatherLookupViewController: UIViewController, UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var SearchBar: UINavigationItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    let cellReuseIdentifier = "cell"
    
    var locationManager: CLLocationManager?
    var savedLocations: [LocationModel]?
    var selectedLocation: LocationModel?

    override func awakeFromNib() {
        splitViewController?.delegate = self
        savedLocations = StorageService.json.JSONToForecastArray(Filename: "locations")
        if savedLocations == nil {
            savedLocations = [LocationModel]()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        if locationManager != nil {
            locationManager!.requestAlwaysAuthorization()
        }
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        cell.textLabel?.text = self.savedLocations?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLocation = savedLocations?[indexPath.row]
        if selectedLocation != nil {
            self.performSegue(withIdentifier: "ShowWeatherDetail", sender: self)
        } else {
            print("no location was selected")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete item from source
            savedLocations?.remove(at: indexPath.row)
            // delete item from tableview
            tableView.deleteRows(at: [indexPath], with: .fade)
            // save changes to disk
            guard let l = savedLocations else { return }
            StorageService.json.forecastArrayToJSON(Forecasts: l, Filename: "locations")
        }
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    
    @IBAction func addButtonAction(_ sender: Any) {
        autoComplete()
    }
    
    func autoComplete(){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWeatherDetail" {
            if let destVC = segue.destination as? ViewController {
                //move this
                //savedLocations?.append(selectedLocation!)
                guard let l = selectedLocation else { return }
                destVC.updateWeather(forecastmodel: l)
            }
        }
    }
}
var searchPlace : GMSPlace? = nil

extension WeatherLookupViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.name.rawValue))
        
        let placesClient : GMSPlacesClient? = GMSPlacesClient()
        
        placesClient?.fetchPlace(fromPlaceID: place.placeID!, placeFields: fields, sessionToken: nil, callback: {
          (place: GMSPlace?, error: Error?) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            return
          }
          if let searchedPlace = place {
            searchPlace = place
            let newLocation = LocationModel(name: searchedPlace.name, lat: searchedPlace.coordinate.latitude, lon: searchedPlace.coordinate.longitude)
            self.savedLocations?.append(newLocation)
            guard let l = self.savedLocations else { return }
            StorageService.json.forecastArrayToJSON(Forecasts: l, Filename: "locations")
            //dispatch refreshing the view with new data to async thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
          }
        })
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //print("Error: ", error.localizedDescription)
        }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
