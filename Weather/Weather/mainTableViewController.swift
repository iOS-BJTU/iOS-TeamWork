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

class mainTableViewController: UITableViewController{
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var tempratureLabel: UILabel!
    var hours = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        for i in 1..<8 {
            hours += ["\(i)时"]
        }
        let wendu = [-1,-2,-3,-4,-1,-2,-3]
        setChart(dataPoints: hours, values: wendu)
        
        tempratureLabel.text = "29??"
        loadWeather(city: "北京")
        
        tableView.estimatedRowHeight = UIScreen.main.bounds.size.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Int]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(values:dataEntries, label: nil)
        let chartData = LineChartData(dataSet: chartDataSet)
        lineChartView.data = chartData
        // 自定义颜色
        
        chartDataSet.drawCirclesEnabled = true//画外环
        
        chartDataSet.drawCircleHoleEnabled = false //不画内环
        
        chartDataSet.circleRadius = 2//外环直径像素
        
        //chartDataSet.circleHoleRadius = 2//内环直径
        
        chartDataSet.setCircleColor(UIColor.red)//环的颜色设置
        
        chartDataSet.valueTextColor = .red //环上字体颜色
        
        chartDataSet.drawValuesEnabled = true //展示环上的值
        
        chartDataSet.mode = LineChartDataSet.Mode.cubicBezier
        
        lineChartView.leftAxis.drawGridLinesEnabled = false //多个横轴
        
        lineChartView.rightAxis.drawGridLinesEnabled = false //多个横轴(left, right同时false才能不展示横轴)
        lineChartView.rightAxis.drawAxisLineEnabled = false //不展示右侧Y轴
        
        lineChartView.leftAxis.drawAxisLineEnabled = false
        
        lineChartView.xAxis.drawGridLinesEnabled = false //多个纵轴
        
        lineChartView.xAxis.drawAxisLineEnabled = false
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        ///lineChartView.xAxis.granularity = 1.0
        
        lineChartView.xAxis.labelPosition = .bottom //只显示底部的X轴
        
        lineChartView.rightAxis.enabled = false //不展示右侧Y轴数据
        
        lineChartView.leftAxis.enabled = false
        
        lineChartView.chartDescription?.text = ""
        
    }

    func loadWeather(city: String){
        let cityname = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let str = "https://api.thinkpage.cn/v3/weather/now.json?key=stgqeqzd7smkfdzn&location=\(cityname)&language=zh-Hans&unit=c"
        let str2 = "https://api.thinkpage.cn/v3/weather/hourly.json?key=stgqeqzd7smkfdzn&location=\(cityname)&language=zh-Hans&unit=c&start=0&hours=24"
        let url = URL(string: str)
        let url2 = URL(string: str2)
        do{
            let jsondata = try NSData(contentsOf: url!, options: NSData.ReadingOptions.uncached)
            let jsondate2 = try NSData(contentsOf: url2!, options: NSData.ReadingOptions.uncached)
            let json = JSON(data: jsondata as Data)
            let josn2 = JSON(data: jsondate2 as Data)
            if let temp = json["results"][0]["now"].rawString() {
                // 找到电话号码
                print(temp)
            }else {
                // 打印错误信息
                print("www")
            }
            print("next")
            if let temp2 = josn2["results"][0]["hourly"][0].rawString() {
                // 找到电话号码
                print(temp2)
            }else {
                // 打印错误信息
                print("www")
            }
        }catch{}
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

}
