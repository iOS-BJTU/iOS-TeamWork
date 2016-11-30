//
//  AddCityViewController.swift
//  WhetherProject
//
//  Created by ts on 2016/11/24.
//  Copyright © 2016年 ts. All rights reserved.
//

import UIKit
import CoreLocation

class AddCityViewController: UIViewController , CLLocationManagerDelegate{
    var city: CityCD?
    var cityName = "??"
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var locationAddress :String = "北京"
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
        let status = CLLocationManager.authorizationStatus()
        if status == .restricted || status == .denied {
            print("locatio service is denied")
        } else {
            if status == .notDetermined {
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            } else {
                startLocationService()
            }
        }
    }
    
    @IBAction func beijingBtn(_ sender: UIButton) {// 查北京的天气然后回主页显示
    }
    
    @IBAction func tianjinBtn(_ sender: UIButton) {// 查天津的天气然后回主页显示
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
        if segue.identifier == "beijingExit", let destVC = segue.destination as? mainTableViewController{
            cityName = "北京"
            destVC.cityName = "北京"
        }
        if segue.identifier == "tianjinExit", let destVC = segue.destination as? mainTableViewController{
            cityName = "天津"
            destVC.cityName = "天津"
        }
        if segue.identifier == "shanghaiExit", let destVC = segue.destination as? mainTableViewController{
            cityName = "上海"
            destVC.cityName = "上海"
        }
        if segue.identifier == "guangzhouExit", let destVC = segue.destination as? mainTableViewController{
            cityName = "广州"
            destVC.cityName = "广州"
        }
        if segue.identifier == "shenzhenExit", let destVC = segue.destination as? mainTableViewController{
            cityName = "深圳"
            destVC.cityName = "深圳"
        }
        if segue.identifier == "searchCity", let destVC = segue.destination as? mainTableViewController{
            cityName = cityTextField.text!
            destVC.cityName = cityTextField.text!
        }
        if segue.identifier == "locateSuccess", let destVC = segue.destination as? mainTableViewController{
            cityName = locationAddress
            destVC.cityName = cityName
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
    
    func startLocationService() {
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationService() {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
        if (error as NSError).code != CLError.locationUnknown.rawValue {
            stopLocationService()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        let latitude = String(format: "%.8f", newLocation.coordinate.latitude)
        let longitude = String(format: "%.8f", newLocation.coordinate.longitude)
        print("latitude=" + latitude + " --longitude="+longitude)
        findGeoInfo(newLocation)
        
        if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
            print("We are Done!")
            findGeoInfo(newLocation)
            stopLocationService()
        }
        
//        performSegue(withIdentifier: "locateSuccess", sender: self)//退出视窗
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            startLocationService()
        } else { stopLocationService()
        }
    }
    
    func findGeoInfo(_ location: CLLocation) {
        print("*** Going to geocode")
        geocoder.reverseGeocodeLocation(location, completionHandler: { [weak self] placemarks, error in
            if let error = error {
                print("fail with error: \(error)")
            } else if let placemark = placemarks?.last! {
                self?.locationAddress = "北京"
//                print("locationAddress3=" + (self?.getAddress(from: placemark))!)
//                self?.locationAddress = (self?.getAddress(from: placemark))!
            } else {
                print("no address found")
            }
        })
    }
    
    func getAddress(from placemark: CLPlacemark?) -> String {
        var address = ""
        if let s = placemark?.subThoroughfare {
            address += s + " ?"
        }
        if let s = placemark?.thoroughfare {
            address += s
        }
        address += "\n"
        if let s = placemark?.locality {//北京市
            address += s + " !"
        }
        if let s = placemark?.administrativeArea {//北京市
            address += s + " &" }
        if let s = placemark?.postalCode {
            address += s
        }
        
        print("address="+address)
        return (placemark?.locality)!
        
//        return address
    }
}
