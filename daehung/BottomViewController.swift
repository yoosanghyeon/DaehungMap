//
//  BottomViewController.swift
//  daehung
//
//  Created by 유상현 on 2018. 9. 24..
//  Copyright © 2018년 유상현. All rights reserved.
//

import UIKit

class BottomViewController: UIViewController {


    @IBOutlet var stationName: UITextField!
    @IBOutlet var timeFiled: UITextField!
    @IBOutlet var rentAvailableText: UITextField!
    
    @IBOutlet var stationAddress: UITextField!
    
    var delegateClicked : BottomViewButtonClickDelegate?
    
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0)
        return bdView
    }()
    
    
    @IBOutlet var startButton: UIButton!
    @IBOutlet var endButton: UIButton!
    
    let menuView = UIView()
    let menuHeight = UIScreen.main.bounds.height / 3
    var isPresenting = false
    // bottom data
    public var bottomViewData : Dictionary<String , String>?
    public var addressText : String?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("bottom init data :: \(bottomViewData)")
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        
        let result = formatter.string(from: date)
        
  
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        

        let hour = components.hour
        let minute = components.minute
        
        timeFiled.text = "조회시간: " + result + " " + String(hour!) + "시" + String(minute!) + "분"

        if var address = addressText{
            address = address.replacingOccurrences(of: "대한민국", with: "")
            stationAddress.text = address
        }
        if let data = bottomViewData{
            if let stationNameData = data["stationName"]{

                let statationNames = stationNameData.split(separator: ".");
                print(statationNames)
                if let firstStationNumber = statationNames.first {
                    stationAddress.text = stationAddress.text! + " (대여소 번호:" + firstStationNumber + ")"
                    
                }
                
                if let lastStationName = statationNames.last{
                    let value = String(lastStationName)
                    stationName.text = value
                }
            }
            
            if let parkingCnt = data["parkingBikeTotCnt"]{
                rentAvailableText.text = "대여가능 : " + parkingCnt + "대"
            }
        }
        
        let lightGreen = UIColor(red: (18/255.0), green: (198/255.0), blue: (191/255.0), alpha: 1.0)
        
        rentAvailableText.layer.borderColor =  lightGreen.cgColor
        rentAvailableText.layer.borderWidth = 1.0
   
        view.backgroundColor = .clear
        

        
        let tab = UITapGestureRecognizer(target: self, action: #selector(buttonClicked))
        view.addGestureRecognizer(tab)

    }
    
    @objc func buttonClicked(){
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func startStationClicked(_ sender: Any) {
        if let clicked = delegateClicked{
            if let data = bottomViewData{
                dismiss(animated: true, completion: nil)
                clicked.startButtonClick(data)
            }
            
        }
    }
    

    @IBAction func endStationClicked(_ sender: Any) {
        
        if let clicked = delegateClicked{
            if let data = bottomViewData{
                dismiss(animated: true, completion: nil)
                clicked.endButtonClick(data)
            }
        }
    }
    

}
protocol BottomViewButtonClickDelegate {
     func startButtonClick(_ data: Dictionary<String, String>)
     func endButtonClick(_ data: Dictionary<String, String>)
}

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
