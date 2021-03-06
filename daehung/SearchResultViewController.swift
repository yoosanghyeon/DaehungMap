//
//  SearchResultViewController.swift
//  daehung
//
//  Created by 유상현 on 2018. 9. 28..
//  Copyright © 2018년 유상현. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMaps
import GooglePlaces
import Foundation

class SearchResultViewController: UIViewController {
    
    
    @IBOutlet var mapView: GMSMapView!
    var resultData : LocationSelectedCompelte?
    // latitude :: x
    // lon :: y

    @IBOutlet var timePrediction: UILabel!
    @IBOutlet var distancePrediction: UILabel!
    
    
    
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let data = resultData{
            
            let startLocation = CLLocation(latitude: data.startY, longitude: data.startX)
            let endLocation = CLLocation(latitude: data.endY, longitude: data.endX)
            let midPosition = midLocation(start: startLocation, end: endLocation)
//            print("data ::  \(data)")
//            print(midPosition)
            let cameraPosition = GMSCameraPosition
                .camera(withLatitude: midPosition.coordinate.latitude, longitude: midPosition.coordinate.longitude, zoom: 14.0)
            mapView.animate(to: cameraPosition)
            fetctFindWorkLoad(data)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    startX:126.977022
//    startY:37.569758
//    endX:126.997589
//    endY:37.570594
//    reqCoordType:WGS84GEO
//    resCoordType:WGS84GEO
//    startName:출발지
//    endName:도착지
    
    func fetctFindWorkLoad(_ locationData : LocationSelectedCompelte){
        print("fetch working")
//        print("fetch location \(locationData)")
     
        
        let parameters: Parameters =  [
            "startX" : locationData.startX ,
            "startY" : locationData.startY ,
            "endX" : locationData.endX ,
            "endY" : locationData.endY ,
            "reqCoordType" : "WGS84GEO" ,
            "resCoordType" : "WGS84GEO",
            "startName" : "출발지" ,
            "endName" : "도착지"
        ]
        Alamofire.request(
            "https://api2.sktelecom.com/tmap/routes/pedestrian?version=1",
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.httpBody,
            headers: ["Content-Type":"application/x-www-form-urlencoded",
                      "appKey":"8c9d7780-2aaa-4b93-b962-8cdf17811a41",
                      "Accept":"application/json"]
            )
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                if let json = response.result.value {
                    let data = JSON(json);
                    let path = GMSMutablePath()
                    let features = data["features"]
                    for (index, object) in features {

                        if(Int(index) == 0){
                            let distance = object["properties"]["totalDistance"].stringValue
                            if(!distance.elementsEqual("")){
                                let km = Meter(Double(distance)!)
                                print(km)
                                self.distancePrediction.text = "이동거리: " + String(km.km) + "km"
                                
                            }
                            
                            let totalTime = object["properties"]["totalTime"].stringValue
                            if(!totalTime.elementsEqual("")){
                                let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: Int(totalTime)!)
                                var totalTimeText = "예상시간: "
                                if(h != 0){
                                    totalTimeText = totalTimeText + String(h) + "시 "
                                }
                                
                                if(m > 0){
                                    totalTimeText = totalTimeText + String(m) + "분 "
                                }
                                
                                if(s > 0){
                                    totalTimeText = totalTimeText + String(s) + "초"
                                }
                                self.timePrediction.text = totalTimeText
                            }
                            
                        }
                        
                        
                        let type = object["geometry"]["type"].stringValue
//                        lat = "37.494698";
//                        lng = "126.858504";
                        if(type != "Point"){
                            for(i, lineString) in object["geometry"]["coordinates"]{
                                print(" \(i) ::: \(lineString.arrayValue[0])")
                                print(" \(i) ::: \(lineString.arrayValue[1])")
                                path.add(CLLocationCoordinate2D(latitude: Double(lineString.arrayValue[1].stringValue)!, longitude: Double(lineString.arrayValue[0].stringValue)!))
                            }
                        }
                        
                    }
                    let polyline = GMSPolyline(path: path)
                    let lightGreen = UIColor(red: (28/255.0), green: (208/255.0), blue: (126/255.0), alpha: 1.0)
                    polyline.strokeColor = lightGreen
                    polyline.strokeWidth = 3
                    polyline.map = self.mapView
                        
                        
                        
                    }
                }
        }
    
    func midLocation(start: CLLocation, end: CLLocation) -> CLLocation {
        let lat1 = Double.pi * start.coordinate.latitude / 180.0
        let long1 = Double.pi * start.coordinate.longitude / 180.0
        let lat2 = Double.pi * end.coordinate.latitude / 180.0
        let long2 = Double.pi * end.coordinate.longitude / 180.0
        
        let bxLoc = cos(lat2) * cos(long2 - long1)
        let byLoc = cos(lat2) * sin(long2 - long1)
        let mlat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bxLoc) * (cos(lat1) + bxLoc) + (byLoc * byLoc)))
        let mlong = (long1) + atan2(byLoc, cos(lat1) + bxLoc)
        
        return CLLocation(latitude: (mlat * 180 / Double.pi), longitude: (mlong * 180 / Double.pi))
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
struct Meter {
    var value: Double
    
    init(_ value: Double) {
        self.value = value
    }
    
    var mm: Double { return value * 1000.0 }
    var km: Double { return value / 1000.0 }
}


