//
//  SearchViewController.swift
//  daehung
//
//  Created by 유상현 on 2018. 9. 27..
//  Copyright © 2018년 유상현. All rights reserved.
//

import UIKit
import SwiftyJSON


struct LocationSelectedCompelte {
    var startX : Double
    var startY : Double
    var endY : Double
    var endX : Double
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
   
    
    @IBOutlet var topFrameView: UIView!
    
    @IBOutlet var tblPlaces: UITableView!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var endTxtSearch: UITextField!
    private var isFirst = false
    private var isFirstCompelte = false
    private var isSecondCompelte = false
    
    var firstName : String?
    var sencondName : String?
    
    var reesultData = LocationSelectedCompelte(startX: 0, startY: 0, endY: 0, endX: 0);
    
    var searchCompelteDalegate : SearchCompelteDelegate?
    
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var resultsArray:[Dictionary<String, AnyObject>] = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtSearch.borderStyle = UITextBorderStyle.roundedRect
        endTxtSearch.borderStyle = UITextBorderStyle.roundedRect
        // Do any additional setup after loading the view, typically from a nib.
        txtSearch.addTarget(self, action: #selector(searchPlaceFromGoogle(_:)), for: .editingChanged)
        endTxtSearch.addTarget(self, action: #selector(searchPlaceFromGoogle(_:)), for: .editingChanged)
        
        
        tblPlaces.rowHeight = UITableViewAutomaticDimension
        tblPlaces.estimatedRowHeight = 100.0
        
        tblPlaces.dataSource = self
        tblPlaces.delegate = self
        
        // view setting
        addPaddingAndBorder(to: txtSearch)
        addPaddingAndBorder(to: endTxtSearch)
        addUiViewGradient(topFrameView)
        
        if let oneName = firstName{
            txtSearch.text = oneName
            endTxtSearch.becomeFirstResponder()
            isFirstCompelte = true
        }
        
        if let lastName = sencondName{
            endTxtSearch.text = lastName
            txtSearch.becomeFirstResponder()
            isSecondCompelte = true
            isFirst = true
        }
    }
    
    //MARK:- UITableViewDataSource and UItableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "placecell")
        if let lblPlaceName = cell?.contentView.viewWithTag(102) as? UILabel {
            
            let place = self.resultsArray[indexPath.row]
            
            // address name
            if let nameText = place["name"] as? String{
                    lblPlaceName.text = nameText
            }
            // address detail
            if let addressFormatTextLabel = cell?.contentView.viewWithTag(103) as? UILabel{
                if let addressFormatText = place["formatted_address"] as? String{
                    addressFormatTextLabel.text = addressFormatText
                }
            }

        }

        
        
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = self.resultsArray[indexPath.row]
        if let locationGeometry = place["geometry"] as? Dictionary<String, AnyObject> {
            if let location = locationGeometry["location"] as? Dictionary<String, AnyObject> {
                if let latitude = location["lat"] as? Double {
                    if let longitude = location["lng"] as? Double {
//                        UIApplication.shared.open(URL(string: "https://www.google.com/maps/@\(latitude),\(longitude),16z")!, options: [:])
                        print("wow \(place)")
                        if let name = place["name"] as? String{
                            
                            if(isFirst){
                                txtSearch.text = name + " 출발"
                                isFirstCompelte = true
                                reesultData.startX = longitude
                                reesultData.startY = latitude
                                endTxtSearch.resignFirstResponder()
                            }else{
                                endTxtSearch.text = name + " 도착"
                                isSecondCompelte = true
                                reesultData.endX = longitude
                                reesultData.endY = latitude
                                txtSearch.resignFirstResponder()
                            }
                            
                            if(isFirstCompelte && isSecondCompelte){
                              

                                if let seCom = searchCompelteDalegate{
                                    print("complelte ok")
                                    seCom.searchCompelte(reesultData)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    @objc func searchPlaceFromGoogle(_ textField:UITextField) {
        
        if let searchQuery = textField.text {
            var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(searchQuery)&key=AIzaSyCaf7l5zXOTgqc-FY2jkkvW5KZRxHyaS6w"
            strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            var urlRequest = URLRequest(url: URL(string: strGoogleApi)!)
            urlRequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, resopnse, error) in
                if error == nil {
                    
                    if let responseData = data {
                        let jsonDict = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        
                        if let dict = jsonDict as? Dictionary<String, AnyObject>{
                            
                            if let results = dict["results"] as? [Dictionary<String, AnyObject>] {
                                print("json == \(results)")
                                self.resultsArray.removeAll()
                                for dct in results {
                                    self.resultsArray.append(dct)
                                }
                                
                                DispatchQueue.main.async {
                                    self.tblPlaces.reloadData()
                                }
                                
                            }
                        }
                        
                    }
                } else {
                    //we have error connection google api
                }
            }
            task.resume()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
   
    
    @IBAction func txtSearchBigin(_ sender: Any) {
        print("first")
        isFirst = true;
        isFirstCompelte = false
    }
    
    @IBAction func endTxtSearchBegin(_ sender: Any) {
        print("end")
        isFirst = false;
        isSecondCompelte = false
    }
    
    func addPaddingAndBorder(to textfield: UITextField) {
        textfield.layer.cornerRadius =  6
//        textfield.layer.borderColor = UIColor.black.cgColor
//        textfield.layer.borderWidth = 1
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 41.0, height: 2.0))
        textfield.leftView = leftView
        textfield.leftViewMode = .always
    }
    
    func addUiViewGradient(_ view : UIView){
        let gradient = CAGradientLayer()

        let startColor = UIColor(red: (17/255.0), green: (199/255.0), blue: (190/255.0), alpha: 1.0)
        let endColor = UIColor(red: (52/255.0), green: (216/255.0), blue: (189/255.0), alpha: 1.0)
        
        gradient.frame = view.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0);
        
        view.layer.insertSublayer(gradient, at: 0)
    }
}

protocol SearchCompelteDelegate {
    func searchCompelte(_ resultData : LocationSelectedCompelte) -> Void
    
}
