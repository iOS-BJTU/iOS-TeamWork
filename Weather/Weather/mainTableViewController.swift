//
//  mainTableViewController.swift
//  Weather
//
//  Created by ts on 2016/11/27.
//  Copyright © 2016年 ts. All rights reserved.
//

import UIKit
import SwiftyJSON
import Charts


let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let AutoSizeScaleY = (SCREEN_HEIGHT-64)/(667-64)

class mainTableViewController: UITableViewController{
    @IBOutlet weak var lineChartViewHigh: LineChartView!
    @IBOutlet weak var lineChartViewLow: LineChartView!
    @IBOutlet weak var hourScrollView: UIScrollView!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var nowTextLabel: UILabel!
    @IBOutlet weak var nowTempratureLabel: UILabel!
    @IBOutlet weak var windScaleLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var nowAirLabel: UILabel!
    @IBOutlet weak var airLevelLabel: UILabel!
    @IBOutlet weak var airImage: UIImageView!
    @IBOutlet weak var lifeView: UIView!    
    @IBOutlet weak var lifeViewBackground: UIImageView!
//    var city: CityCD?
    var locationAddress = "北京"
    var cityName = ""
    var cityTemperature = "0°C"
    var cityImageCode = "0"
    var days = [String]()
    var highDegree = [Int]()
    var lowDegree = [Int]()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var cityNames = ["牡丹江"]
    var citiesList = [CityCD]()
    var now: Now?
    var hour: Hour?
    var air: Air?
    var daily: Daily?
    var life: Life?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            if !FileManager().fileExists(atPath:CityCD.StoreURL.path) {
                for name in cityNames {
                    let city = appDelegate.addToContext(city_name: name, image_code: "0", temperature: "0")
                    citiesList.append(city)
                }
                cityName = citiesList[0].city_name!
            } else {
                if let fetchedList = appDelegate.fetchContext() {
                    citiesList += fetchedList
                }
                cityName = citiesList[0].city_name!
            }
        }
        
        self.navigationItem.title = cityName
        loadWeather(cityInfo: cityName)
//        loadWeather(cityInfo: "北京")
        // 计算屏幕长宽
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height        
        
        self.edgesForExtendedLayout = .bottom
        
        tableView.estimatedRowHeight = screenHeight

        //下拉刷新
        automaticallyAdjustsScrollViewInsets = false
        tableView.addExRefresh {
            print("cityName=?="+self.cityName)
            self.loadWeather(cityInfo: self.cityName)
            self.perform(#selector(self.afterMethod), with: nil, afterDelay: 3, inModes: [RunLoopMode.commonModes])
        }
        
    }
    
    func afterMethod() {
//        self.navigationItem.title = "刷新成功"
        tableView.header?.endRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChartHigh(dataPoints: [String], values: [Int]) {
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(values:dataEntries, label: nil)
        let chartData = LineChartData(dataSet: chartDataSet)
        lineChartViewHigh.data = chartData
        // 自定义颜色
        lineChartViewHigh.backgroundColor = .clear
        
        chartDataSet.drawCirclesEnabled = true//画外环
        
        chartDataSet.drawCircleHoleEnabled = false //不画内环
        
        chartDataSet.circleRadius = 2//外环直径像素
        
        //chartDataSet.circleHoleRadius = 2//内环直径
        
        chartDataSet.setCircleColor(UIColor.white)//环的颜色设置
        
        chartDataSet.valueTextColor = .white //环上字体颜色
        
        chartDataSet.drawValuesEnabled = true //展示环上的值
        
        chartDataSet.mode = LineChartDataSet.Mode.cubicBezier
        
        chartDataSet.colors = [UIColor.yellow]
        
        lineChartViewHigh.leftAxis.drawGridLinesEnabled = false //多个横轴
        
        lineChartViewHigh.rightAxis.drawGridLinesEnabled = false //多个横轴(left, right同时false才能不展示横轴)
        lineChartViewHigh.rightAxis.drawAxisLineEnabled = false //不展示右侧Y轴
        
        lineChartViewHigh.leftAxis.drawAxisLineEnabled = false
        
        lineChartViewHigh.xAxis.drawGridLinesEnabled = false //多个纵轴
        
        lineChartViewHigh.xAxis.drawAxisLineEnabled = false
        
        lineChartViewHigh.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        lineChartViewHigh.xAxis.labelPosition = .top //只显示底部的X轴
        
        lineChartViewHigh.rightAxis.enabled = false //不展示右侧Y轴数据
        
        lineChartViewHigh.leftAxis.enabled = false
        
        lineChartViewHigh.chartDescription?.text = ""
        
        lineChartViewHigh.xAxis.labelTextColor = .white
        
        lineChartViewHigh.legend.formSize = 0
        
        lineChartViewHigh.dragEnabled = false
        
        lineChartViewHigh.doubleTapToZoomEnabled = false
        
    }
    func setChartLow(dataPoints: [String], values: [Int]) {
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(values:dataEntries, label: nil)
        let chartData = LineChartData(dataSet: chartDataSet)
        lineChartViewLow.data = chartData
        // 自定义颜色
        lineChartViewLow.backgroundColor = .clear
        
        chartDataSet.drawCirclesEnabled = true//画外环
        
        chartDataSet.drawCircleHoleEnabled = false //不画内环
        
        chartDataSet.circleRadius = 2//外环直径像素
        
        //chartDataSet.circleHoleRadius = 2//内环直径
        
        chartDataSet.setCircleColor(UIColor.white)//环的颜色设置
        
        chartDataSet.valueTextColor = .white //环上字体颜色
        
        chartDataSet.drawValuesEnabled = true //展示环上的值
        
        chartDataSet.mode = LineChartDataSet.Mode.cubicBezier
        
        lineChartViewLow.leftAxis.drawGridLinesEnabled = false //多个横轴
        
        lineChartViewLow.rightAxis.drawGridLinesEnabled = false //多个横轴(left, right同时false才能不展示横轴)
        lineChartViewLow.rightAxis.drawAxisLineEnabled = false //不展示右侧Y轴
        
        lineChartViewLow.leftAxis.drawAxisLineEnabled = false
        
        lineChartViewLow.xAxis.drawGridLinesEnabled = false //多个纵轴
        
        lineChartViewLow.xAxis.drawAxisLineEnabled = false
        
        lineChartViewLow.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        lineChartViewLow.xAxis.labelPosition = .bottom //只显示底部的X轴
        
        lineChartViewLow.rightAxis.enabled = false //不展示右侧Y轴数据
        
        lineChartViewLow.leftAxis.enabled = false
        
        lineChartViewLow.chartDescription?.text = ""
        
        lineChartViewLow.xAxis.labelTextColor = .white
        
        lineChartViewLow.legend.formSize = 0
        
        lineChartViewLow.dragEnabled = false
        
        lineChartViewLow.doubleTapToZoomEnabled = false
        
    }

    func loadWeather(cityInfo: String){
        let cityname = cityInfo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        now = Now("now","https://api.thinkpage.cn/v3/weather/now.json?key=stgqeqzd7smkfdzn&location=\(cityname)&language=zh-Hans&unit=c")
        now?.jsondata
        hour = Hour("hour","https://api.thinkpage.cn/v3/weather/hourly.json?key=stgqeqzd7smkfdzn&location=\(cityname)&language=zh-Hans&unit=c&start=0&hours=24")
        hour?.jsondata
        air = Air("air","https://api.thinkpage.cn/v3/air/now.json?key=stgqeqzd7smkfdzn&location=\(cityname)&language=zh-Hans&scope=city")
        air?.jsondata
        daily = Daily("daily","https://api.thinkpage.cn/v3/weather/daily.json?key=stgqeqzd7smkfdzn&location=\(cityname)&language=zh-Hans&unit=c&start=0&days=7")
        daily?.jsondata
        life = Life("life","https://api.thinkpage.cn/v3/life/suggestion.json?key=stgqeqzd7smkfdzn&location=\(cityname)&language=zh-Hans")
        life?.jsondata
        
        NotificationCenter.default.addObserver(self, selector: #selector(getNow), name: NSNotification.Name("GetNow"), object: now)
        NotificationCenter.default.addObserver(self, selector: #selector(getHour), name: NSNotification.Name("GetHour"), object: hour)
        NotificationCenter.default.addObserver(self, selector: #selector(getAir), name: NSNotification.Name("GetAir"), object: air)
        NotificationCenter.default.addObserver(self, selector: #selector(getDaily), name: NSNotification.Name("GetDaily"), object: daily)
        NotificationCenter.default.addObserver(self, selector: #selector(getLife), name: NSNotification.Name("GetLife"), object: life)
        
        var cityList = [CityCD]()
        if let fetchedList = appDelegate?.fetchContext() {
            cityList = fetchedList
        }
        for index in 1...cityList.count {
            print("\(cityList.count)"+"cityNameHere~"+cityList[index-1].city_name! + "///"+cityName)
            if self.cityName == cityList[index-1].city_name {// 已有城市，更新
                print("Updating city information ...")
                let city = appDelegate?.updateToContext(city: cityList[index-1], city_name: cityName, image_code: cityImageCode, temperature: cityTemperature)
                return
            }else{// 新加城市，添加。
                if index == cityList.count {
                    print("Adding city information ...")
                    let city = appDelegate?.addToContext(city_name: cityName, image_code: cityImageCode, temperature: cityTemperature)
                }
            }
        }
    }
    
    func getNow(notification: Notification) {
        let nowJson = JSON(data: (now?.jsondata)! as Data)
        self.setMainData(weatherJson: nowJson)
    }
    
    func getHour(notification: Notification) {
        let hourJson = JSON(data: (hour?.jsondata)! as Data)
        let subViews = self.hourScrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        self.createHourWeatherView(hourJson: hourJson)
    }
    
    func getAir(notification: Notification) {
        let airJson = JSON(data: (air?.jsondata)! as Data)
        self.setAirData(airJson: airJson)
    }
    
    func getDaily(notification: Notification) {
        let dailyJson = JSON(data: (daily?.jsondata)! as Data)
        self.setDailyWeatherData(dailyJson: dailyJson)
    }
    
    func getLife(notification: Notification) {
        let lifeJson = JSON(data: (life?.jsondata)! as Data)
        let subViews = self.lifeView.subviews
        for subview in subViews{
            if subview == lifeViewBackground{
        
            }else{
                subview.removeFromSuperview()
            }
        }
        self.createLifeView(lifeJson: lifeJson)
        tableView.reloadData()
    }
    
    func setMainData (weatherJson : JSON) {
        tempratureLabel.text = NSString.init(format: "%@°C", weatherJson["results"][0]["now"]["temperature"].rawString()!) as String
        nowTextLabel.text = weatherJson["results"][0]["now"]["text"].rawString()
        windScaleLabel.text = weatherJson["results"][0]["now"]["wind_scale"].rawString()
        humidityLabel.text = weatherJson["results"][0]["now"]["humidity"].rawString()
        weatherImage.image = UIImage.init(named: weatherJson["results"][0]["now"]["code"].rawString()!)
        
        cityImageCode = weatherJson["results"][0]["now"]["code"].rawString()!
    }
    
    func setAirData (airJson : JSON) {
        let pm25 = airJson["results"][0]["air"]["city"]["pm25"].rawString()
        let quality = airJson["results"][0]["air"]["city"]["quality"].rawString()
        nowAirLabel.text = pm25! + " " + quality!
        let level = Int(pm25!)
        if level! < 50{
            airImage.image = UIImage.init(named: "colorBar1")
            airLevelLabel.textColor = UIColor(red: 131/255, green: 192/255, blue: 92/255, alpha: 1.0)
        }else if level! >= 50, level! < 100 {
            airImage.image = UIImage.init(named: "colorBar2")
            airLevelLabel.textColor = UIColor(red: 232/255, green: 190/255, blue: 81/255, alpha: 1.0)
        }else if level! >= 100, level! < 150 {
            airImage.image = UIImage.init(named: "colorBar3")
            airLevelLabel.textColor = UIColor(red: 236/255, green: 159/255, blue: 98/255, alpha: 1.0)
        }else if level! >= 150, level! < 200 {
            airImage.image = UIImage.init(named: "colorBar4")
            airLevelLabel.textColor = UIColor(red: 222/255, green: 125/255, blue: 87/255, alpha: 1.0)
        }else if level! >= 200, level! < 300 {
            airImage.image = UIImage.init(named: "colorBar5")
            airLevelLabel.textColor = UIColor(red: 156/255, green: 70/255, blue: 89/255, alpha: 1.0)
        }else if level! >= 300, level! < 500 {
            airImage.image = UIImage.init(named: "colorBar6")
            airLevelLabel.textColor = UIColor(red: 120/255, green: 47/255, blue: 67/255, alpha: 1.0)
        }else{
            airImage.image = UIImage.init(named: "colorBar7")
            airLevelLabel.textColor = UIColor(red: 80/255, green: 20/255, blue: 63/255, alpha: 1.0)
        }
        airLevelLabel.text = quality! + " " + pm25!
        
    }
    
    func setDailyWeatherData (dailyJson : JSON) {
        let todayHigh = dailyJson["results"][0]["daily"][0]["high"].rawString()
        let todayLow = dailyJson["results"][0]["daily"][0]["low"].rawString()
        nowTempratureLabel.text = todayLow! + "/" + todayHigh! + "°C"
        cityTemperature = todayLow! + "/" + todayHigh! + "°C"
        lowDegree.removeAll()
        highDegree.removeAll()
        days.removeAll()
        for var i in 0..<dailyJson["results"][0]["daily"].count{
            if i == 0 {
                days.append("今天")
            }else if i == 1{
                days.append("明天")
            }else if i == 2{
                days.append("后天")
            }else{
                let date = dailyJson["results"][0]["daily"][i]["date"].rawString()?.index((dailyJson["results"][0]["daily"][i]["date"].rawString()?.endIndex)!, offsetBy: -5)
                days.append((dailyJson["results"][0]["daily"][i]["date"].rawString()?.substring(from: date!))!)
            }
            lowDegree.append(Int(dailyJson["results"][0]["daily"][i]["low"].rawString()!)!)
            highDegree.append(Int(dailyJson["results"][0]["daily"][i]["high"].rawString()!)!)
            i += 1
        }
        setChartHigh(dataPoints: days, values: highDegree)
        setChartLow(dataPoints: days, values: lowDegree)
    }
    
    func createHourWeatherView (hourJson : JSON) {
        //        let width : CGFloat = SCREEN_WIDTH / 7.5
        for (index,subJson):(String, JSON) in hourJson["results"][0]["hourly"]
        {
            let dateLabel = UILabel.init(frame: CGRect.init(x: 60 * Int(index)!, y: 5, width: 60, height: 20));
            dateLabel.font = UIFont.systemFont(ofSize: 16)
            dateLabel.textColor = UIColor.lightGray
            dateLabel.textAlignment = NSTextAlignment.center
            let time = subJson["time"].stringValue
            let range = time.range(of: "T")
            let range2 = time.range(of: ":")
            let hour = time.substring(with: (range?.upperBound)!..<(range2?.lowerBound)!)
            
            
            let range3 = time.range(of: "-")
            let range4 = time.range(of: "T")
            let date = time.substring(with: (range3?.upperBound)!..<(range4?.lowerBound)!)

            if hour == "00" {
                dateLabel.text = date
            }
            if Int(index) == 0 {
                dateLabel.text = date
            }
            
            hourScrollView.addSubview(dateLabel)
            
            let hourLabel = UILabel.init(frame: CGRect.init(x: 60 * Int(index)!, y: Int(dateLabel.frame.maxY + 10), width: 60, height: 20));
            hourLabel.font = UIFont.systemFont(ofSize: 15)
            hourLabel.textColor = UIColor.white
            hourLabel.textAlignment = NSTextAlignment.center
//            let time = subJson["time"].stringValue
//            let range = time.range(of: "T")
//            let range2 = time.range(of: ":")
//            let hour = time.substring(with: (range?.upperBound)!..<(range2?.lowerBound)!)
            hourLabel.text = NSString.init(format: "%@时", hour) as String
            hourScrollView.addSubview(hourLabel)
            
            let hourImageView = UIImageView.init(frame: CGRect.init(x: 60 * Int(index)! + 5, y: Int(hourLabel.frame.maxY + 10), width: 40, height: 40));
            hourImageView.image = UIImage.init(named: subJson["code"].rawString()!)
            hourScrollView.addSubview(hourImageView)
            
            let hourWeatherLabel = UILabel.init(frame: CGRect.init(x: 60 * Int(index)!, y: Int(hourImageView.frame.maxY + 5), width: 60, height: 20));
            hourWeatherLabel.font = UIFont.systemFont(ofSize: 15)
            hourWeatherLabel.textColor = UIColor.white
            hourWeatherLabel.textAlignment = NSTextAlignment.center
            hourWeatherLabel.text = NSString.init(format: "%@°C", subJson["temperature"].rawString()!) as String
            hourScrollView.addSubview(hourWeatherLabel)
            
            //            hourScrollView.contentSize = CGSize.init(width: 60 * Int(index)!, height: 0)
            print("\(index)：\(subJson)")
        }
        hourScrollView.contentSize = CGSize.init(width: 60 * (hourJson["results"][0]["hourly"].array?.count)!, height: 0)
    }
    
    func createLifeView (lifeJson : JSON) {
        lifeViewBackground.image = UIImage.init(named: "background")
        
        let width : CGFloat = SCREEN_WIDTH / 4.0
        let height : CGFloat = width * 0.9
        var y : CGFloat = 5.0
        
        for index in 0..<8 {
            let bgView = UIView.init(frame: CGRect.init(x: SCREEN_WIDTH / 4.0 * CGFloat(index % 4), y: y, width: width, height: height))
            lifeView .addSubview(bgView)
            
            let titleImageView = UIImageView.init(frame: CGRect.init(x: (width - 32) / 2.0, y: AutoSizeY(size: 10), width: 30, height: 30));
            bgView.addSubview(titleImageView)
            
            let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: titleImageView.frame.maxY + AutoSizeY(size: 10), width: width, height: 16))
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.font = UIFont.systemFont(ofSize: 13)
            titleLabel.textColor = UIColor.white
            bgView .addSubview(titleLabel)
            
            switch index {
            case 0:
                titleImageView.image = UIImage.init(named: "icon_clothes")
                titleLabel.text = NSString.init(format: "天气%@", lifeJson["results"][0]["suggestion"]["dressing"]["brief"].rawString()!) as String
            case 1:
                titleImageView.image = UIImage.init(named: "icon_umbrella")
                titleLabel.text = lifeJson["results"][0]["suggestion"]["umbrella"]["brief"].rawString()
            case 2:
                titleImageView.image = UIImage.init(named: "icon_getcold")
                titleLabel.text = NSString.init(format: "%@感冒", lifeJson["results"][0]["suggestion"]["flu"]["brief"].rawString()!) as String
            case 3:
                titleImageView.image = UIImage.init(named: "icon_guomin")
                titleLabel.text = NSString.init(format: "%@过敏", lifeJson["results"][0]["suggestion"]["allergy"]["brief"].rawString()!) as String
            case 4:
                titleImageView.image = UIImage.init(named: "icon_exercise")
                titleLabel.text = NSString.init(format: "%@晨练", lifeJson["results"][0]["suggestion"]["morning_sport"]["brief"].rawString()!) as String
            case 5:
                titleImageView.image = UIImage.init(named: "icon_ultra")
                titleLabel.text = NSString.init(format: "紫外线%@", lifeJson["results"][0]["suggestion"]["uv"]["brief"].rawString()!) as String
            case 6:
                titleImageView.image = UIImage.init(named: "icon_shai")
                titleLabel.text = NSString.init(format: "%@晾晒", lifeJson["results"][0]["suggestion"]["airing"]["brief"].rawString()!) as String
            case 7:
                titleImageView.image = UIImage.init(named: "icon_car")
                titleLabel.text = NSString.init(format: "%@洗车", lifeJson["results"][0]["suggestion"]["car_washing"]["brief"].rawString()!) as String
            default:
                print("default")
            }
            
            if index == 3 {
                y = height
            }
            print("\(index) times 5 is \(index * 5)")
        }
    }
// MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backToMain(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToWeatherMain(segue:UIStoryboardSegue){//退出函数
        // 查询显示北京天气
        if segue.identifier == "beijingExit", let detailVC = segue.source as? AddCityViewController{
            cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
            loadWeather(cityInfo: "北京")
        }
        // 查询显示天津天气
        if segue.identifier == "tianjinExit", let detailVC = segue.source as? AddCityViewController{
            self.cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
            loadWeather(cityInfo: "天津")
        }
        // 查询显示上海天气
        if segue.identifier == "shanghaiExit", let detailVC = segue.source as? AddCityViewController{
            self.cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
            loadWeather(cityInfo: "上海")
        }
        // 查询显示广州天气
        if segue.identifier == "guangzhouExit", let detailVC = segue.source as? AddCityViewController{
            self.cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
            loadWeather(cityInfo: "广州")
        }
        // 查询显示深圳天气
        if segue.identifier == "shenzhenExit", let detailVC = segue.source as? AddCityViewController{
            self.cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
            loadWeather(cityInfo: "深圳")
        }
        
        if segue.identifier == "showWhetherFromCityList", let detailVC = segue.source as? CityListTableViewController{
            self.cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
            loadWeather(cityInfo: cityName)
        }
        
        if segue.identifier == "searchCity", let detailVC = segue.source as? AddCityViewController{
            self.cityName = detailVC.cityName
            print("cityName=="+cityName)
            self.navigationItem.title = cityName
            loadWeather(cityInfo: cityName)
        }
        
        if segue.identifier == "locateSuccess", let detailVC = segue.source as? AddCityViewController
            {
            let location = detailVC.locationAddress
            self.self.cityName = location
            print("locationAddress0=="+cityName)
            self.navigationItem.title = cityName
            loadWeather(cityInfo: cityName)
        }

    }

    func AutoSizeY (size:CGFloat) -> CGFloat { return CGFloat (AutoSizeScaleY * size)}

}
