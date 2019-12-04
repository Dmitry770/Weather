//
//  LocationsTableViewController.swift
//  Weather
//
//  Created by Macintosh on 03/12/2019.
//  Copyright © 2019 Macintosh. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class LocationsTableViewController: UITableViewController {
    
    var locationsArray: [LocationInfo] = []
    var callBack:( (Double,Double)->()  )?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "Sky_Clouds_From_above_533131_800x1280")
        let imageView = UIImageView(image: image)
        tableView.backgroundView = imageView
        imageView.alpha = 0.2
        

        readCoreData()
        for loc in locationsArray{
            print(loc.name)
            print(loc.temp)
        }
    }

    func readCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationInfo")
        
        locationsArray = try! context.fetch(fetchRequest) as! [LocationInfo]
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationTableViewCell
        cell.locationLabel.text = locationsArray[indexPath.row].name
        cell.tempLabel.text = "\(locationsArray[indexPath.row].temp)"
       
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lon = locationsArray[indexPath.row].lon
        let lat = locationsArray[indexPath.row].lat
        
        callBack!(lon,lat)
        navigationController?.popViewController(animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
