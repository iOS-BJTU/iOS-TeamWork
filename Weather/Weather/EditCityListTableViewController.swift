//
//  EditCityListTableViewController.swift
//  WhetherProject
//
//  Created by ts on 2016/11/25.
//  Copyright © 2016年 ts. All rights reserved.
//

import UIKit

class EditCityListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func saveEdit(_ sender: UIBarButtonItem) {
//        guard let name =
//            nameTextField.text, !name.isEmpty
//            else{
//                let alertController = UIAlertController(title: "error", message: "NAME cannot be empty", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "ok", style:.default, handler: nil)
//                alertController.addAction(okAction)
//                
//                present(alertController,animated:true,completion:nil)
//                
//                return
//        }
        
        print("ahahahahahahah")
//        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "editCityExit", sender: self)//退出视窗
        print("why????????????")
//        if presentingViewController is UINavigationController{
//            dismiss(animated: true, completion: nil)
//        }else{
//            navigationController!.popViewController(animated: (animated:true))
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditCityCell", for: indexPath) as! EditCityListTableViewCell     
        
        // Configure the cell...
        if indexPath.row == 0 {
            cell.cityLabel.text = "北京"
            cell.whetherImageView.image = UIImage(named: "0")
            cell.tempretureLabel.text = "-3/9°C"
            
        } else if indexPath.row == 1 {
            cell.cityLabel.text = "上海"
            cell.whetherImageView.image = UIImage(named: "3")
            cell.tempretureLabel.text = "-2/7°C"
            cell.locationImageView.isHidden = true
        } else {
            cell.cityLabel.text = "牡丹江"
            cell.whetherImageView.image = UIImage(named: "9")
            cell.tempretureLabel.text = "-13/-25°C"
            cell.locationImageView.isHidden = true
            
        }
        
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
 /*   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            acqList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }*/
    

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }

}
