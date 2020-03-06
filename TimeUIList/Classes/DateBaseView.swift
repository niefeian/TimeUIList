//
//  DateBaseView.swift
//  FBSnapshotTestCase
//
//  Created by 聂飞安 on 2019/11/8.
//

import UIKit
import NFALunarUtil
import NFAToolkit

open class DateBaseView: UIView {
    
    open var maxYear = 2020
    open var minYear = 1940
    open var year = 2020 - 30
    open var forward = true
    
    var lunarCalendarDic = [String:[Lunar]]()
    var lunarCalendarArr = [String]()

    var row2 = 1
    var row3 = 1
    var row4 = 0
    
    public var block : CBWithParam!
    public var noTimeodaa : Bool = false
    var segmentIndex : Int = 0
    var loding = false

    //当年换农历
    let timeodaa = ["00:00-00:59早子","01:00-02:59丑时","03:00-04:59寅时","05:00-06:59卯时","07:00-08:59辰时","09:00-10:59巳时","11:00-12:59午时","13:00-14:59未时","15:00-16:59申时","17:00-18:59酉时","19:00-20:59戌时","21:00-22:59亥时","23:00-23:59晚子"]
    
    let chineseMonths = ["正月","二月","三月","四月", "五月", "六月", "七月", "八月","九月", "十月", "冬月", "腊月"]
    
    let chineseDays = [ "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十","十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十","廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
    
    public func gotoDayTime(_ data : Date){
        let str = DateUtil.dateToStrt(data)
        let arr = str.components(separatedBy: "-")
        if arr.count == 4 {
            year = Int(arr[0]) ?? maxYear
            row2 = (Int(arr[1]) ?? 1)
            row3 = (Int(arr[2]) ?? 1)
            row4 = (((Int(arr[3]) ?? 0) + 1)/2)%timeodaa.count
            reloadPickerView()
        }
    }
    
    public func reloadPickerView(){
       
    }
    
    func reloadSolar(){
        if lunarCalendarArr.count > row2-1 {
            let key = lunarCalendarArr[row2-1]
            if let solar = lunarCalendarDic[key]?[row3-1].solar {
                let solarYear = Int(solar.solarYear)
                let solarMonth = Int(solar.solarMonth)
                let solarDay = Int(solar.solarDay)
                row2 = solarMonth
                row3 = solarDay
                year = solarYear
                reloadPickerView()
            }
        }
    }
    
    func reloadLunar(){
        if  loding {
            return
        }
        loding = true
        lunarCalendarDic = [String:[Lunar]]()
        lunarCalendarArr = [String]()
        let oldYear = year
        if  let nowLunar = CalendarDisplyManager.obtainLunar(from: Solar(year: Int32(year), andMonth: Int32(row2), andDay: Int32(row3))){
            year = Int(nowLunar.lunarYear)
            if year <= maxYear - 100 {
                year = 1920
            }
            //首先获得改年农历第一天 计算出各自公历的时间
            if let fistDay =  CalendarDisplyManager.obtainSolar(from: Lunar(year: Int32(year), andMonth: 1, andDay: 1)){
                if  let lastDay =  CalendarDisplyManager.obtainSolar(from: Lunar(year: Int32(year + 1), andMonth: 1, andDay: 1)){
                    var fistSolarYear = fistDay.solarYear
                    var fistSolarMonth = fistDay.solarMonth
                    var fistSolarDay = fistDay.solarDay
                    let lastSolarMonth = lastDay.solarMonth
                    let lastSolarDay = lastDay.solarDay
                    for month in fistSolarMonth...12{
                        let count = reDayCount2(fistSolarYear,month)
                        for day in fistSolarDay...count{
                            if let lunar = CalendarDisplyManager.obtainLunar(from: Solar(year: fistSolarYear, andMonth: month, andDay: day)){
                                let key = lunar.isleap ? "闰\(chineseMonths[Int(lunar.lunarMonth-1)])" : chineseMonths[Int(lunar.lunarMonth-1)]
                                if  var arr = lunarCalendarDic[key] {
                                    arr.append(lunar)
                                    lunarCalendarDic[key] = arr
                                }else{
                                    var arr  = [Lunar]()
                                    arr.append(lunar)
                                    lunarCalendarDic[key] = arr
                                    lunarCalendarArr.append(key)
                                }
                            }
                        }
                        fistSolarDay = 1
                    }
                    fistSolarYear += 1
                    fistSolarMonth = 1
                    fistSolarDay = 1
                    //计算次年剩余部分
                    
                    for month in fistSolarMonth...lastSolarMonth{
                        var count = reDayCount2(fistSolarYear,month)
                        if month == lastSolarMonth{
                            count = lastSolarDay
                        }
                        for day in fistSolarDay...count{
                            if let lunar = CalendarDisplyManager.obtainLunar(from: Solar(year: fistSolarYear, andMonth: month, andDay: day)){
                                let key = lunar.isleap ? "闰\(chineseMonths[Int(lunar.lunarMonth-1)])月" : chineseMonths[Int(lunar.lunarMonth-1)]
                                if  var arr = lunarCalendarDic[key] {
                                    arr.append(lunar)
                                    lunarCalendarDic[key] = arr
                                }else{
                                    var arr  = [Lunar]()
                                    arr.append(lunar)
                                    lunarCalendarDic[key] = arr
                                    lunarCalendarArr.append(key)
                                }
                            }
                        }
                        fistSolarDay = 1
                    }
                }
            }
            row2 = Int(nowLunar.lunarMonth )
            row3 = Int(nowLunar.lunarDay )
            reloadPickerView()
        }
        loding = false
        if year != oldYear {
            reloadLunar()
        }
    }
    
    func reDayCount2(_ years : Int32 ,_ month : Int32) -> Int32 {
        if [1,3,5,7,8,10,12].contains(month){
            return 31
        }else if month == 2 {
            if year%4 == 0 {
                return 29
            }else{
                return 28
            }
        } else {
            return 30
        }
    }
    
    
    func reDayCount(_ month : Int) -> Int {
        if [1,3,5,7,8,10,12].contains(month){
            return 31
        }else if month == 2 {
            if year%4 == 0 {
                return 29
            }else{
                return 28
            }
        } else {
            return 30
        }
    }
    
     
     public func getLunar() -> Lunar?{
         if  segmentIndex == 0 {
             return CalendarDisplyManager.obtainLunar(from: Solar(year: Int32(year), andMonth: Int32(row2), andDay: Int32(row3)))
         }
         return lunarCalendarDic[lunarCalendarArr[row2-1]]?[row3-1]
     }
     
     public func getShowTime() -> String{
         if  segmentIndex == 0 {
            return getSolar()
         }
         return getLunarString()
     }
     
    public  func getLunarString()->String{
        if let lunar = getLunar() {
         let lunarYear = Int(lunar.lunarYear)
         let lunarMonth = Int(lunar.lunarMonth)
         let lunarDay = Int(lunar.lunarDay)
         let lunarMonths = lunarMonth > self.chineseMonths.count ? "" : self.chineseMonths[lunarMonth-1]
         let lunarDays = lunarDay > self.chineseDays.count ? "" : self.chineseDays[lunarDay-1]
         if lunar.isleap {
             return "\(lunarYear)年闰\(lunarMonths)\(lunarDays)\(timeodaa[row4].subString(start: timeodaa[row4].count - 2))"
         }
         return "\(lunarYear)年\(lunarMonths)\(lunarDays)\(timeodaa[row4].subString(start: timeodaa[row4].count - 2))"
         }
         return ""
     }
     
    public  func getLunar2()->String{
          if let lunar = getLunar() {
         let lunarYear = Int(lunar.lunarYear)
         let lunarMonth = Int(lunar.lunarMonth)
         let lunarDay = Int(lunar.lunarDay)
         let lunarMonths = lunarMonth > self.chineseMonths.count ? "" : self.chineseMonths[lunarMonth-1]
         let lunarDays = lunarDay > self.chineseDays.count ? "" : self.chineseDays[lunarDay-1]
         if lunar.isleap {
             return "\(lunarYear.cn2)年闰\(lunarMonths)\(lunarDays) \(timeodaa[row4].subString(start: timeodaa[row4].count - 2))"
         }
         return "\(lunarYear.cn2)年\(lunarMonths)\(lunarDays) \(timeodaa[row4].subString(start: timeodaa[row4].count - 2))"
         }
           return ""
     }
     
     public func getSolar()->String{
         if let lunar = getLunar() {
         let solar = lunar.solar!
         let solarYear = Int(solar.solarYear)
         let solarMonth = Int(solar.solarMonth)
         let solarDay = Int(solar.solarDay)
         return "\(solarYear)年\(solarMonth)月\(solarDay)日 \(timeodaa[row4].subString(start: 0, length: timeodaa[row4].count - 2))"
         }
           return ""
     }
     
    public func getTimestamp()->String{
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
             return  "\(DateUtil.dateTimeFromStr(strDate).timeIntervalSince1970)"
         }
         return ""
     }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
