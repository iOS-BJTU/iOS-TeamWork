//
//  CityListTableViewController.swift
//  Weather
//
//  Created by ts on 2016/11/26.
//  Copyright © 2016年 ts. All rights reserved.
//

import UIKit

class CityListTableViewController: UITableViewController {
//    var cityList = [City("北京","-3/9°C"), City("上海","-2/7°C"), City("牡丹江","-13/-25°C"), City("哈尔滨","-15/-28°C")]
    var cityName = "!!"
    var cityNames = ["牡丹江"]
    var citiesList = [CityCD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            if !FileManager().fileExists(atPath:CityCD.StoreURL.path) {
                for name in cityNames {
                    let city = appDelegate.addToContext(city_name: name, image_code: "0", temperature: "0!")
                    citiesList.append(city)
                }
            } else {
                if let fetchedList = appDelegate.fetchContext() {
                    citiesList += fetchedList
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return citiesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityListCell", for: indexPath) as! CityListTableViewCell

        // Configure the cell...
        let city = citiesList[indexPath.row]
        // Configure the cell...
        cell.whetherImageView.image = UIImage(named: city.image_code!)
        cell.cityLabel.text = city.city_name
        cell.tempretureLabel.text = city.temperature
        if city.city_name == "北京"{
            cell.locationImageView.isHidden = false
        }else{
            cell.locationImageView.isHidden = true
        }
        
        return cell
    }
 
    @IBAction func cancelCityList(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            citiesList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let city = citiesList[indexPath.row]
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                appDelegate.deleteFromContext(city: city)
                citiesList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showWhetherFromCityList", let destVC = segue.destination as? MainTableViewController,
            let indexPath = tableView.indexPathForSelectedRow{
            cityName = (citiesList[indexPath.row].city_name)!
            destVC.cityName = cityName
        }
    }
 
    @IBAction func cancelShowCity(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }

}
