//
//  NewsTableViewController.swift
//  SidebarMenu
//
//  Created by ts on 2016/11/24.
//  Copyright (c) 2016 ts. All rights reserved.
//

import UIKit

class CityListTableViewController2: UITableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!

    var cityList = [City("北京","-3/9°C"), City("上海","-2/7°C"), City("牡丹江","-13/-25°C")]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // Return the number of sections.
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return cityList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CityListTableViewCell

        
        let city = cityList[indexPath.row]
        // Configure the cell...
//        if let photoData = city?.tempratureImage {
//            cell.whetherImageView.image = UIImage(data: photoData)
//        } else {
//            cell.whetherImageView.image = UIImage(named:"photoalbum")
//        }
        cell.whetherImageView.image = UIImage(named: "0")
        cell.cityLabel.text = city?.cityName
        cell.tempretureLabel.text = city?.temprature
        
        
        // Configure the cell...
//        if indexPath.row == 0 {
//            cell.cityLabel.text = "北京"
//            cell.whetherImageView.image = UIImage(named: "0")
//            cell.tempretureLabel.text = "-3/9°C"
//
//        } else if indexPath.row == 1 {
//            cell.cityLabel.text = "上海"
//            cell.whetherImageView.image = UIImage(named: "3")
//            cell.tempretureLabel.text = "-2/7°C"
        
//            cell.locationImageView.isHidden = true
//        } else {
//            cell.cityLabel.text = "牡丹江"
//            cell.whetherImageView.image = UIImage(named: "9")
//            cell.tempretureLabel.text = "-13/-25°C"
//            cell.locationImageView.isHidden = true
//            
//        }

        return cell
    }
    
    @IBAction func cancelCityList(_ sender: UIBarButtonItem) {
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            acqList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
 
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
//        performSegue(withIdentifier: "showWhether", sender: self)
        if segue.identifier == "showWeather", let destVC = segue.destination as? WeatherMainViewController,
            let indexPath = tableView.indexPathForSelectedRow{
//            let person = acqList[indexPath.row]
//            destVC.person = person
            print("press "+"\(indexPath)")
            destVC.cityName = "change?"
        }
    }
 

    @IBAction func unwindToCityList(segue:UIStoryboardSegue){//退出函数
        if segue.identifier == "addCityExit" {//添加城市
            print("AddSuccessful")
        }else if segue.identifier == "editCityExit"{//编辑城市
            print("EditSuccessful")
        }
    }
    
    @IBAction func cancelToCityList(segue:UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelShowCity(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
    }
}
