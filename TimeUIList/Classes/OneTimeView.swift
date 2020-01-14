//
//  OneTimeView.swift
//  FBSnapshotTestCase
//
//  Created by 聂飞安 on 2019/11/7.
//

import UIKit
import NFALunarUtil
import NFAToolkit
import NFATipsUI

open class OneTimeView: DateBaseView ,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBAction func cancelBtn(_ sender: Any) {
        self.removeFromSuperview()
    }

    @IBAction func config(_ sender: UIButton) {
     if let lunar = getLunar() {
         let solar = lunar.solar!
         let solarYear = Int(solar.solarYear)
         let solarMonth = Int(solar.solarMonth)
         let solarDay = Int(solar.solarDay)
         var strDate = "\(solarYear)-"
         if solarMonth > 9 {
             strDate += "\(solarMonth)-"
         }else{
             strDate += "0\(solarMonth)-"
         }
         if solarDay > 9 {
             strDate += "\(solarDay) "
         }else{
             strDate += "0\(solarDay) "
         }
         strDate += timeodaa[row4].subString(start: 0, length: 2) + ":00:00"
         if DateUtil.dateTimeFromStr(strDate).timeIntervalSinceNow < 0 {
             block?((self.getLunar(),timeodaa[row4],segmentIndex) as AnyObject)
             self.removeFromSuperview()
         }else{
              showTipsWindow("出生日期不能大于今天")
         }
     }
    }
    
    @IBAction func segUp(_ sender: UIButton) {
        if segmentIndex == 0 {
            segmentIndex = 1
            typeBtn.setTitle("(农历)", for: UIControl.State.normal)
            reloadLunar()
        }else{
            segmentIndex = 0
            typeBtn.setTitle("(公历)", for: UIControl.State.normal)
            reloadSolar()
        }
    }
    
    
    private static var instance : OneTimeView!
    
    open class func sharedInstance() -> OneTimeView {
        if instance == nil {
           instance = Bundle(for: self.classForCoder()).loadNibNamed("TimeUIList.bundle/OneTimeView", owner: self, options: nil)?.first as? OneTimeView
            Tools.setCornerRadius(instance.bgView, rate: 10)
        }
        return instance

    }
    
    private func loadTime(){
        pickerView.selectRow(maxYear - year, inComponent: 0, animated: false)
    }
       
   override public func reloadPickerView(){
       pickerView.reloadAllComponents()
       pickerView.selectRow(maxYear - year, inComponent: 0, animated: false)
       pickerView.selectRow(row2 - 1, inComponent: 1, animated: false)
        if  lunarCalendarArr.count > row2 - 1 && lunarCalendarDic[lunarCalendarArr[row2 - 1]]?.count ?? 0 > row3 - 1  && row3 - 1 >= 0{
            pickerView.selectRow(row3 - 1 , inComponent: 2, animated: false)
        }
       pickerView.selectRow(row4, inComponent: 3, animated: false)
   }
   
   /*
    UIPickerViewDelegate
    */
   public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
       return getComponentWidth(by: component)
   }
   
   public func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 4
   }
   
   public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       if  segmentIndex == 0 {
           return gregorianCalendar(pickerView, numberOfRowsInComponent: component)
       }
       if component == 0 {
           return maxYear - minYear  + 1
       }else if component == 1 {
           return lunarCalendarArr.count
       }else if component == 2 {
           if  lunarCalendarArr.count <= 0{
               return 0
           }
           return  lunarCalendarDic[lunarCalendarArr[row2 - 1]]?.count ?? 0
       }else if component == 3 {
           return timeodaa.count
       }
       
       return 0
   }
   
   public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
       if  segmentIndex == 0 {
           return gregorianCalendar(pickerView, viewForRow: row, forComponent: component, reusing: view)
       }
       let label = UILabel()
       label.font = UIFont.systemFont(ofSize: 15)
       label.frame = CGRect(x:0 ,y :0 ,width : getComponentWidth(by: component),height: 40)
       if component == 0 {
           label.text =  "\(maxYear-row)年"
       }else if component == 1 {
            label.text =  lunarCalendarArr[row]
       }else if component == 2 {
           if row >= chineseDays.count {
               label.text = ""
           }else{
               label.text = chineseDays[row]
           }
       }else{
           label.font = UIFont.systemFont(ofSize: 13)
           label.text =  timeodaa[row]
       }
       label.textAlignment = .center
       return label
   }

   public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       if  segmentIndex == 0 {
           gregorianCalendar(pickerView,didSelectRow:row,inComponent: component)
           if reDayCount(row2) < row3 {
               row3 = reDayCount(row2)
           }
           return
       }
       
       switch component {
       case 0:
           year = maxYear - row
           reloadLunar()
           break
       case 1:
           row2 = row + 1
           pickerView.reloadComponent(2)
           break
       case 2:
           if row >= chineseDays.count{
               row3 = row
           }else{
               row3 = row + 1
           }
       case 3:
           row4  = row
           break
       default: break
       }
       
       if lunarCalendarDic[lunarCalendarArr[row2-1]]?.count ?? 0 < row3 {
           row3 = lunarCalendarDic[lunarCalendarArr[row2-1]]?.count ?? 0
       }
   }

   
   func getComponentWidth(by component: Int)->CGFloat{
       if component == 0  {
        return AppWidth*0.9/4
       }else if component == 3 {
           return AppWidth*0.9 - AppWidth*0.9/3 - AppWidth*0.9/4
       }
       return AppWidth*0.9/6
   }
    
   func gregorianCalendar(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       if component == 0 {
          return maxYear - minYear  + 1
       }else if component == 1 {
           return 12
       }else if component == 2 {
          return reDayCount(row2)
       }else if component == 3 {
           return timeodaa.count
       }
       return 5
   }
   
   
   func gregorianCalendar(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
       let label = UILabel()
       label.font = UIFont.systemFont(ofSize: 15)
       label.frame = CGRect(x:0 ,y :0 ,width : getComponentWidth(by: component),height: 40)
       if component == 0 {
           label.text =  "\(maxYear-row)年"
       }else if component == 1 {
           label.text =  "\(1+row)月"
       }else if component == 2 {
           label.text =  "\(1+row)日"
       }else{
           label.font = UIFont.systemFont(ofSize: 13)
           if noTimeodaa {
                label.text =  timeodaa[row].subString(start: 0, length: timeodaa[row].count - 2)
           }else{
                if segmentIndex == 0 {
                    label.text =  timeodaa[row].subString(start: 0, length: timeodaa[row].count - 2)
                }else{
                    label.text =  timeodaa[row].subString(start: timeodaa[row].count - 2)
                }
           }
       }
       label.textAlignment = .center
       return label
   }
   
   func gregorianCalendar(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
       switch component {
       case 0:
           year = maxYear - row
           break
       case 1:
           row2 = row + 1
           pickerView.reloadComponent(2)
           break
       case 2:
           row3 = row + 1
       case 3:
           row4 = row
           break
       default: break
       }
   }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
