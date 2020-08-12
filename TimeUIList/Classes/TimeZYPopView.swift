//
//  TimeZYPopView.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/8/10.
//

import UIKit
import SwiftProjects
import NFAToolkit
import SnapKit
import NFALunarUtil
import NFATipsUI


public class TimeZYPopView: BasePopVC {

    private var pickerView: UIPickerView! = UIPickerView()
    
    public var minimumDate: Date! // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
    public var maximumDate: Date! // default is nil
    
    public var isLunar = false
    
    public var showToday = false
    
    public var showLunar = true
    
    private var rows = (0,0,0,0) // 年在第几个 月 日 时
    
    private var maxComponent = 0
    
    private  var lunarCalendarDic = [String:[Lunar]]()
    private  var lunarCalendarArr = [String]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        regisPopSize(CGSize(width: AppWidth, height: AppHeight*0.35))
        // Do any additional setup after loading the view.
    }
    
    
     
     public func getShowTime() -> String{
         if !isLunar {
            return getSolar()
         }
         return getLunarString()
     }
     
    public  func getLunarString()->String{
        if let lunar = getLunar() {
         let lunarYear = Int(lunar.lunarYear)
         let lunarMonth = Int(lunar.lunarMonth)
         let lunarDay = Int(lunar.lunarDay)
         let lunarMonths = lunarMonth > DateUtil.chineseMonths.count ? "" : DateUtil.chineseMonths[lunarMonth-1]
         let lunarDays = lunarDay > DateUtil.chineseDays.count ? "" : DateUtil.chineseDays[lunarDay-1]
         if lunar.isleap {
            return "\(lunarYear)年闰\(lunarMonths)\(lunarDays)\(DateUtil.timeodaa[rows.3])"
         }
         return "\(lunarYear)年\(lunarMonths)\(lunarDays)\(DateUtil.timeodaa[rows.3])"
         }
         return ""
     }
     
     
     public func getSolar()->String{
         if let lunar = getLunar() {
         let solar = lunar.solar!
         let solarYear = Int(solar.solarYear)
         let solarMonth = Int(solar.solarMonth)
         let solarDay = Int(solar.solarDay)
            return "\(solarYear)年\(solarMonth)月\(solarDay)日 \(DateUtil.timeodaa[rows.3])"
         }
//        getDayString(rows.3)
        return ""
     }
    
    public func getLunar() -> Lunar?{
           if  !isLunar
           {
            let oldDates = DateUtil.getYMD(minimumDate)
//
            return CalendarDisplyManager.obtainLunar(from: Solar(year: Int32(oldDates.0+rows.0), andMonth: Int32(rows.1+1), andDay: Int32(rows.2+1)))
           }
            if lunarCalendarArr.count < rows.1
            {
              return nil
            }
          if lunarCalendarDic[lunarCalendarArr[rows.1]]?.count ?? 0 <= rows.2
          {
              return nil
          }
          return lunarCalendarDic[lunarCalendarArr[rows.1]]?[rows.2]
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
             strDate += DateUtil.timeodaa[rows.3].subString(start: 0, length: 2) + ":00:00"
//                strDate +=  " \(DateUtil.getDayString(rows.3)):00:00"
             return  "\(Int(DateUtil.dateTimeFromStr(strDate).timeIntervalSince1970))"
         }
         return ""
     }
    
    public override func initializePage() {
        addAutoView([(.view, 2),(.button, 4)])
        super.initializePage()
        self.view.addSubview(pickerView)
    }
    
    public override func initLayoutSubviews() {
        getSubview(autoViewClass: .view, index: 1)?.snp.makeConstraints({ (make) in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        })
        
        getSubview(autoViewClass: .button, index: 1)?.snp.makeConstraints({ (make) in
            make.left.equalTo(20.pd6sW)
            make.size.equalTo(CGSize(width: 40.pd6sW, height: 20.pd6sW))
            make.top.equalTo(8.pd6sW)
        })
        
        
        getSubview(autoViewClass: .button, index: 2)?.snp.makeConstraints({ (make) in
            make.left.equalTo(getSubview(autoViewClass: .button, index: 1)!.snp_right).offset(10.pd6sW)
            make.size.equalTo(CGSize(width: 40.pd6sW, height: 20.pd6sW))
            make.top.equalTo(8.pd6sW)
        })
        
        getSubview(autoViewClass: .button, index: 3)?.snp.makeConstraints({ (make) in
           make.right.equalTo(-20.pd6sW)
           make.size.equalTo(CGSize(width: 40.pd6sW, height: 20.pd6sW))
           make.top.equalTo(8.pd6sW)
        })
        
        getSubview(autoViewClass: .button, index: 4)?.snp.makeConstraints({ (make) in
            make.right.equalTo(getSubview(autoViewClass: .button, index: 3)!.snp_left).offset(-10)
            make.size.equalTo(CGSize(width: 40.pd6sW, height: 20.pd6sW))
            make.top.equalTo(8.pd6sW)
        })
        
        getSubview(autoViewClass: .view, index: 2)?.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 40.pd6sW, height: 1))
            make.top.equalTo(getSubview(autoViewClass: .button, index: 2)!.snp_bottom).offset(2)
            make.centerX.equalTo(getSubview(autoViewClass: .button, index: 1)!)
        })
       
        pickerView.snp.makeConstraints { (make) in
            make.top.equalTo(getSubview(autoViewClass: .view, index: 2)!.snp_bottom).offset(2)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
       
    }
    
    public override func initializeDraw() {
        getSubview(autoViewClass: .view, index: 1)?.backgroundColor = .white
        getSubview(autoViewClass: .view, index: 2)?.backgroundColor = .initString("#E52B29")
        let array = ["阳历","阴历","确定","今天"]
        for i in 1...4 {
            if let button = getSubview(autoViewClass: .button, index: i) as? UIButton
            {
                button.addTarget(self, action: #selector(self.touchUpInside(_:)), for: .touchUpInside)
                button.setTitle(array[i-1], for: .normal)
                button.setTitleColor(.initString("#333333"), for: .normal)
                button.titleLabel?.setFont(18)
                if i == 2 && !showLunar || i == 4 && !showToday
                {
                    button.isHidden = true
                }
            }
        }
    }
    
    @objc func touchUpInside(_ btn : UIButton){
        if loding {
            showTipsWindow("您的操作太快啦~")
            return
        }
        let tag = (btn.tag - 200 )
        if tag != 3
        {
            UIView.animate(withDuration: 0.3) {
                if tag == 1
                {
                    self.getSubview(autoViewClass: .view, index: 2)?.transform = .identity
                }
                else
                {
                    self.getSubview(autoViewClass: .view, index: 2)?.transform = .init(translationX: 50.pd6sW, y: 0)
                }
            }
            isLunar = tag == 2
        }
        switch tag {
        case 1:
            reloadSolar()
            break
        case 2:
            reloadLunar()
        break
        case 3:
            callBack?((self.getLunarString(),getSolar(),getTimestamp(),"\(rows.3)",isLunar ? 0 : 1) as AnyObject)
            break
        case 4:
        //回到今天
            goToThatDay(Date())
          break
        default:
            break
        }
    }
    
    public func goToThatDay(_ data : Date){
        if minimumDate == nil || maximumDate == nil
        {
            return
        }
        if data.timeIntervalSince1970 > minimumDate.timeIntervalSince1970 && data.timeIntervalSince1970 < maximumDate.timeIntervalSince1970
        {
            if !isLunar {
                let str = DateUtil.dateToStrt(data)
                let arr = str.components(separatedBy: "-")
                if arr.count == 4 {
                    if minimumDate == nil {
                        minimumDate = DateUtil.dateFromStr("1970-01-01")
                    }
                    rows.0 = (Int(arr[0]) ?? 0 ) - DateUtil.getYMD(minimumDate).0
                    rows.1 = (Int(arr[1]) ?? 1) - 1
                    rows.2 = (Int(arr[2]) ?? 1) - 1
                    rows.3 = ((Int(arr[3]) ?? 0) + 1) / 2
                    reloadPickerView()
                }
            }
        }
    }
    
    public override func initializeDelegate() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

   
    public override func initializeData() {
        if minimumDate == nil {
            minimumDate = DateUtil.dateFromStr("1970-01-01")
        }
        if maximumDate == nil {
//           明年的今天就是你的暴富日
            maximumDate = DateUtil.addDateToStr(Date(), year: 1, month: 0, day: 0)
        }
        
        maxComponent = DateUtil.deltasCalculated(maximumDate!,minimumDate!).0
    }
    
    func reloadSolar(){
        if lunarCalendarArr.count > rows.1
        {
            let key = lunarCalendarArr[rows.1]
            if lunarCalendarDic[key]?.count ?? 0 > rows.2
            {
                   if let solar = lunarCalendarDic[key]?[rows.2].solar
                   {
                       let solarYear = Int(solar.solarYear)
                       let solarMonth = Int(solar.solarMonth)
                       let solarDay = Int(solar.solarDay)
                       rows.1 = solarMonth - 1
                       rows.2 = solarDay - 1
                       rows.0 = solarYear -  DateUtil.getYMD(minimumDate).0
                       reloadPickerView()
                   }
               }
       }
    }
    
    
    private func reloadLunar(){
        if  loding {
            return
        }
        loding = true
        lunarCalendarDic = [String:[Lunar]]()
        lunarCalendarArr = [String]()
        let oldDates = DateUtil.getYMD(DateUtil.addDateToStr(minimumDate, year: rows.0, month: 0, day: 0))
        let oldYear = oldDates.0
        var nowYear = 0
        //Solar这个是公历诶
        //Lunar 农历
        if let nowLunar = CalendarDisplyManager.obtainLunar(from: Solar(year: Int32(oldYear), andMonth: Int32(rows.1 + 1) , andDay: Int32(rows.2 + 1))){
            nowYear = Int(nowLunar.lunarYear)
            if nowYear < DateUtil.getYMD(minimumDate).0 {
                nowYear = DateUtil.getYMD(minimumDate).0
            }
            //首先获得改年农历第一天 计算出各自公历的时间
            var isLeapMonth = 0
            if let fistDay =  CalendarDisplyManager.obtainSolar(from: Lunar(year: Int32(nowYear), andMonth: 1, andDay: 1)){
                if  let lastDay =  CalendarDisplyManager.obtainSolar(from: Lunar(year: Int32(nowYear + 1), andMonth: 1, andDay: 1)){
                    var fistSolarYear = fistDay.solarYear
                    var fistSolarMonth = fistDay.solarMonth
                    var fistSolarDay = fistDay.solarDay
                    let lastSolarMonth = lastDay.solarMonth
                    let lastSolarDay = lastDay.solarDay
                    for month in fistSolarMonth...12{
                        let count = DateUtil.reDayCount(Int(fistSolarYear),Int(month))
                        for day in Int(fistSolarDay)...count{
                            if let lunar = CalendarDisplyManager.obtainLunar(from: Solar(year: fistSolarYear, andMonth: month, andDay: Int32(day))){
                                let key = lunar.isleap ? "闰\(DateUtil.chineseMonths[Int(lunar.lunarMonth-1)])" : DateUtil.chineseMonths[Int(lunar.lunarMonth-1)]
                                if lunar.isleap && isLeapMonth == 0 {
                                    isLeapMonth = Int(lunar.lunarMonth)
                                }
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
                        var count = DateUtil.reDayCount(Int(fistSolarYear),Int(month))
                        if month == lastSolarMonth{
                            count = Int(lastSolarDay)
                        }
                        for day in Int(fistSolarDay)...count{
                            if let lunar = CalendarDisplyManager.obtainLunar(from: Solar(year: fistSolarYear, andMonth: month, andDay: Int32(day))){
                                let key = lunar.isleap ? "闰\(DateUtil.chineseMonths[Int(lunar.lunarMonth-1)])月" : DateUtil.chineseMonths[Int(lunar.lunarMonth-1)]
                                if lunar.isleap && isLeapMonth == 0 {
                                    isLeapMonth = Int(lunar.lunarMonth)
                                }
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
            //这边要考虑是不是闰月，而且是闰几月
            if nowLunar.isleap ||  (nowLunar.lunarMonth > isLeapMonth && isLeapMonth > 0)
            {
                rows.1 = Int(nowLunar.lunarMonth)
            }
            else
            {
                rows.1 = Int(nowLunar.lunarMonth - 1)
            }
            
            rows.2 = Int(nowLunar.lunarDay - 1)
        }
        if rows.2 < 0
        {
            rows.2 = 0
        }
        loding = false
//        let nowTime = DateUtil.getYMD(DateUtil.addDateToStr(minimumDate, year: rows.0, month: rows.1, day: rows.2)).0
        
        if  nowYear != oldYear
        {
            rows.0 =  rows.0 + nowYear - oldYear
            DispatchQueue.global().async {[weak self] in
                self?.reloadLunar()
            }
        }
        else
        {
            DispatchQueue.main.async {[weak self] in
                self?.reloadPickerView()
            }
        }
    }
    
    
    func reloadPickerView(){
        pickerView?.reloadAllComponents()
        pickerView?.selectRow(rows.0, inComponent: 0, animated: false)
        pickerView?.selectRow(rows.1, inComponent: 1, animated: false)
        if isLunar
        {
            if  lunarCalendarArr.count > rows.1 && lunarCalendarDic[lunarCalendarArr[rows.1 ]]?.count ?? 0 > rows.2  && rows.2  >= 0{
                pickerView?.selectRow(rows.2 , inComponent: 2, animated: false)
            }
        }
        else
        {
            pickerView?.selectRow(rows.2 , inComponent: 2, animated: false)
        }
        if rows.3 < 12
        {
            pickerView?.selectRow(rows.3 , inComponent: 3, animated: false)
        }
    }
}

extension TimeZYPopView : UIPickerViewDelegate,UIPickerViewDataSource
{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = view as? UILabel ?? UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.frame = CGRect(x:0 ,y :0 ,width : getComponentWidth(by: component),height: 40)
        label.textAlignment = .center
        if component == 0 {
            let oldDates = DateUtil.getYMD(minimumDate)
            label.text =  "\(oldDates.0+row)年"
           
            return label
        }
        if  !isLunar || loding{
            return gregorianCalendar(pickerView, viewForRow: row, forComponent: component, reusing: label)
        }
        
        if component == 1 {
             label.text =  lunarCalendarArr[row]
        }else if component == 2 {
            if row >= DateUtil.chineseDays.count {
                label.text = ""
            }else{
                label.text = DateUtil.chineseDays[row]
            }
        }else{
            label.font = UIFont.systemFont(ofSize: 13)
            label.text =  DateUtil.timeodaa[row]
        }
        label.textAlignment = .center
        return label
    }
    
    func getComponentWidth(by component: Int)->CGFloat{
       if component == 0  {
           return AppWidth/4
       }else if component == 3 {
           return AppWidth - AppWidth/3 - AppWidth/4
       }
       return AppWidth/6
    }
    
    func gregorianCalendar(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing label: UILabel) -> UIView {
            if component == 1
            {
               label.text =  "\(1+row)月"
           }else if component == 2
            {
               label.text =  "\(1+row)日"
           }else
            {
               label.font = UIFont.systemFont(ofSize: 13)
               label.text =  DateUtil.timeodaa[row]
//                "\(row)点"
           }
           label.textAlignment = .center
           return label
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isLunar
        {
            switch component {
            case 0:
                return maxComponent
            case 1:
                return lunarCalendarArr.count
            case 2:
                if  lunarCalendarArr.count <= 0{
                    return 0
                }
                return lunarCalendarDic[lunarCalendarArr[rows.1]]?.count ?? 0
            case 3:
                return 13
            default:
                break
            }
        }
        switch component {
        case 0:
            return maxComponent
        case 1:
            return 12
        case 2:
                if minimumDate == nil
                {
                    minimumDate = DateUtil.dateFromStr("1970-01-01")
                }
             let oldDates = DateUtil.getYMD(DateUtil.addDateToStr(minimumDate, year: rows.0, month: rows.1, day: 0))
                let dayCount = DateUtil.reDayCount(oldDates.0, rows.1+1)
                if dayCount <= rows.2
                {
                    rows.2 = dayCount - 1
                }
            return dayCount
        case 3:
            return 13
        default:
            break
        }
        return 0
   }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
       return getComponentWidth(by: component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
            case 0:
            rows.0 = row
            if isLunar
            {
               reloadLunar()
            }
            else
            {
              pickerView.reloadComponent(2)
            }
            case 1:
            rows.1 = row
            case 2:
            rows.2 = row
            case 3:
            rows.3 = row
        default:
            break
        }
        if component < 3
        {
            pickerView.reloadComponent(component+1)
        }
        
    }
      
}
