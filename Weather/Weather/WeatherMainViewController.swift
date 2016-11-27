//
//  PhotoViewController.swift
//  SidebarMenu
//
//  Created by ts on 2016/11/24.
//  Copyright (c) 2016 ts. All rights reserved.
//

import UIKit

class WeatherMainViewController: UIViewController{
    @IBOutlet weak var menuButton:UIBarButtonItem!
    var cityName = "北京"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = cityName
        
        // 计算屏幕长宽
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height

        // 添加一个ScrollView
        let scrollview = UIScrollView()
        scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.view.addSubview(scrollview)
        
        // 背景图片
        let imageview = UIImageView(image:UIImage(named:"background.png"))
        imageview.frame = scrollview.bounds
        scrollview.addSubview(imageview)
        
        // 天气情况图标
//        let weatherImageIcon = UIImageView(image:UIImage(named:"3.png"))
//        let weatherImageIconX = screenWidth/2
//        let weatherImageIconY = screenHeight/2
//        weatherImageIcon.frame = CGRect(x: weatherImageIconX, y: weatherImageIconY, width: 90, height: 90)
//        scrollview.addSubview(weatherImageIcon)
        
        //设置ScrollView高度
        scrollview.contentSize = CGSize(width: screenWidth, height: screenHeight*3)
        
        //可以垂直滑动
        scrollview.showsVerticalScrollIndicator = true
//        scrollview.bounces=false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToWeatherMain(segue:UIStoryboardSegue){//退出函数
        // 查询显示北京天气
        if segue.identifier == "beijingExit", let detailVC = segue.source as? AddCityViewController{
            let cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
        }
        // 查询显示天津天气
        if segue.identifier == "tianjinExit", let detailVC = segue.source as? AddCityViewController{
        let cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
        }
        // 查询显示上海天气
        if segue.identifier == "shanghaiExit", let detailVC = segue.source as? AddCityViewController{
            let cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
        }
        // 查询显示广州天气
        if segue.identifier == "guangzhouExit", let detailVC = segue.source as? AddCityViewController{
            let cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
        }
        // 查询显示深圳天气
        if segue.identifier == "shenzhenExit", let detailVC = segue.source as? AddCityViewController{
            let cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
        }
        
        if segue.identifier == "showWhetherFromCityList", let detailVC = segue.source as? CityListTableViewController{
            let cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
        }
    }
}
