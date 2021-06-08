//
//  settingsController.swift
//  TestDrowing
//
//  Created by Александр Вань on 25.05.2021.
//

import Foundation 
import  UIKit

class settingsController: UITableViewController{
    let brushSize = "brushSize"
    let distance = "distance"
    let redColor = "red"
    let greenColor = "green"
    let blueColor = "blue"
    let tapValue = "Tap"
    
    
    
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var sizeView: UILabel!
    @IBOutlet weak var distanceView: UILabel!
    @IBOutlet weak var distanceOutlet: UIStepper!
    @IBOutlet weak var redView: UILabel!
    @IBOutlet weak var greenView: UILabel!
    @IBOutlet weak var blueView: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var imageColor: UIImageView!
    @IBOutlet weak var tapSwitch: UISwitch!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizeView.text = String(UserDefaults.standard.float(forKey: brushSize))
        sizeSlider.setValue(UserDefaults.standard.float(forKey: brushSize), animated: true)
        
        distanceView.text = String(UserDefaults.standard.float(forKey: distance))
        distanceOutlet.value = Double(UserDefaults.standard.float(forKey: distance))
        //color
        redView.text = String(Int(UserDefaults.standard.float(forKey: redColor)))
        redSlider.setValue(UserDefaults.standard.float(forKey: redColor), animated: true)
        
        greenView.text = String(Int(UserDefaults.standard.float(forKey: greenColor)))
        greenSlider.setValue(UserDefaults.standard.float(forKey: greenColor), animated: true)
        
        blueView.text = String(Int(UserDefaults.standard.float(forKey: blueColor)))
        blueSlider.setValue(UserDefaults.standard.float(forKey: blueColor), animated: true)
        
        tapSwitch.isOn = UserDefaults.standard.bool(forKey: tapValue)
        
        setColor()
        
    }
    
    @IBAction func sizeSlider(_ sender: UISlider) {
        sizeView.text = String(format: "%.3f", sender.value)
        UserDefaults.standard.set(Float(String(format: "%.3f", sender.value)), forKey: brushSize)
        
    }
    
    
    func getSize() -> Float{
        return UserDefaults.standard.float(forKey: brushSize)
    }
    
    func getDistance() -> Float{
        return UserDefaults.standard.float(forKey: distance)
    }
    
    func setSize(var size: Float){
        UserDefaults.standard.set(size, forKey: brushSize)
    }
   
    func setDistance(var dis: Float){
        UserDefaults.standard.set(Float(String(format: "%.1f", dis)), forKey: distance)
    }
        /// Rounds the double to decimal places value
        
    @IBAction func distanceChoice(_ sender: UIStepper) {
        distanceView.text = String(format: "%.1f", sender.value)
        UserDefaults.standard.set(Float(String(format: "%.3f", sender.value)), forKey: distance)
    }
    
    @IBAction func redActionSlider(_ sender: UISlider) {
        redView.text = String(Int(sender.value))
        UserDefaults.standard.set(Float(String(format: "%.3f", sender.value)), forKey: redColor)
        
        setColor()
    }
    
    @IBAction func greenActionSlider(_ sender: UISlider) {
        greenView.text = String(Int(sender.value))
        UserDefaults.standard.set(Float(String(format: "%.3f", sender.value)), forKey: greenColor)
        setColor()
    }
    
    @IBAction func blueActionSlider(_ sender: UISlider) {
        blueView.text = String(Int(sender.value))
        UserDefaults.standard.set(Float(String(format: "%.3f", sender.value)), forKey: blueColor)
        setColor()
    }
    
    
    func setColor(){
        let color = UIColor.init(red: CGFloat(redSlider.value)/255, green: CGFloat(greenSlider.value)/255, blue: CGFloat(blueSlider.value)/255, alpha: 1.0)
        imageColor.backgroundColor = color
        
    }
    
    func getColor() -> UIColor{
        return UIColor.init(red: CGFloat(UserDefaults.standard.float(forKey: redColor)/255), green: CGFloat(UserDefaults.standard.float(forKey: greenColor)/255), blue: CGFloat(UserDefaults.standard.float(forKey: blueColor)/255), alpha: 1.0)
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        sizeSlider.setValue(0.03, animated: true)
        sizeView.text = String(sizeSlider.value)
        UserDefaults.standard.set(Float(String(format: "%.3f", sizeSlider.value)), forKey: brushSize)
        
        distanceOutlet.value = 0.5
        distanceView.text = String(distanceOutlet.value)
        UserDefaults.standard.set(Float(String(format: "%.3f", distanceOutlet.value)), forKey: distance)
        
        redSlider.setValue(255, animated: true)
        redView.text = String(redSlider.value)
        UserDefaults.standard.set(Float(String(format: "%.3f", redSlider.value)), forKey: redColor)
        
        greenSlider.setValue(0, animated: true)
        greenView.text = String(greenSlider.value)
        UserDefaults.standard.set(Float(String(format: "%.3f", greenSlider.value)), forKey: greenColor)
        
        blueSlider.setValue(0, animated: true)
        blueView.text = String(blueSlider.value)
        UserDefaults.standard.set(Float(String(format: "%.3f", blueSlider.value)), forKey: blueColor)
        
        setColor()
    }
    @IBAction func actionTapSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: tapValue)
    }

    
    
    
    func getTapSwitch() -> Bool{
        return UserDefaults.standard.bool(forKey: tapValue)
    }
    
}
