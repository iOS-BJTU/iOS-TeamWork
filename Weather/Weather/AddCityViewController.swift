//
//  AddCityViewController.swift
//  WhetherProject
//
//  Created by ts on 2016/11/24.
//  Copyright © 2016年 ts. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {
    var cityName = "??"
    @IBOutlet weak var cityTextField: UITextField!
    @IBAction func closeAddCity(_ sender: UIButton) {
        performSegue(withIdentifier: "addCityExit", sender: self)//退出视窗
    }
    
    @IBAction func searchCity(_ sender: UIButton) {
        if (cityTextField.text?.isEmpty)!{
            let alertController = UIAlertController(title: "这样可不行哟～", message: "请输入城市名", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的吧", style:.default, handler: nil)
            alertController.addAction(okAction)
            present(alertController,animated:true,completion:nil)
        }else{
            print("input "+cityTextField.text!)
        }
    }

    @IBAction func locationBtn(_ sender: UIButton) {//定位-然后应该定位然后在下面显示他的位置？
    }
    
    @IBAction func beijingBtn(_ sender: UIButton) {// 查北京的天气然后回主页显示
    }
    
    @IBAction func tianjinBtn(_ sender: UIButton) {// 查天津的天气然后回主页显示
//        performSegue(withIdentifier: "tianjinWeatherSegue", sender: self)
    }
    
    @IBAction func shanghaiBtn(_ sender: UIButton) {// 查上海的天气然后回主页显示
    }
    
    @IBAction func guangzhouBtn(_ sender: UIButton) {// 查广州的天气然后回主页显示
    }
    
    @IBAction func shenzhenBtn(_ sender: UIButton) {// 查深圳的天气然后回主页显示
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        var theSegue = segue.destinationViewController as WeatherMainViewController
//        theSegue.text = "Pass"
        
//        if segue.identifier == "tianjinWeatherSegue", let destVC = segue.destination as?
        if segue.identifier == "beijingExit", let destVC = segue.destination as? WeatherMainViewController{
            cityName = "北京"
            destVC.cityName = "北京"
        }
        if segue.identifier == "tianjinExit", let destVC = segue.destination as? WeatherMainViewController{
            cityName = "天津"
            destVC.cityName = "天津"
        }
        if segue.identifier == "shanghaiExit", let destVC = segue.destination as? WeatherMainViewController{
            cityName = "上海"
            destVC.cityName = "上海"
        }
        if segue.identifier == "guangzhouExit", let destVC = segue.destination as? WeatherMainViewController{
            cityName = "广州"
            destVC.cityName = "广州"
        }
        if segue.identifier == "shenzhenExit", let destVC = segue.destination as? WeatherMainViewController{
            cityName = "深圳"
            destVC.cityName = "深圳"
        }
    }
 

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cityTextField.resignFirstResponder()
    }
    
    @IBAction func cancelAddCity(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addCityExit(segue:UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
}