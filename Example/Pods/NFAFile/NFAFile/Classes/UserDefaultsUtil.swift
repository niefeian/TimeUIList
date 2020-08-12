//
//  UserDefaultsUtil.swift
//  Pods-Tools_Example
//
//  Created by 聂飞安 on 2019/8/15.
//

import Foundation


public enum UserDefaultsStatus {
    case never , unfinish , finish
}

open class UserDefaultsUtils {
    
    /// 在分组中进行完结
    open class func finishInGroup(_ group : String, key : String , finish : Bool = true) {
        setInGroup(group,key: key,value: finish)
    }

    open class func getGroup(_ group : String, key : String) ->  UserDefaultsStatus{
        let groups = UserDefaults.standard.value(forKey: group)
        if groups == nil {
            return .never
        } else {
           let oldDic = groups as! NSDictionary
            if oldDic.object(forKey: key) as? Bool ?? false {
                return .finish
            }else{
                return .unfinish
            }
        }
    }
    
    /*
     计数器
     */
    open class func getCounter(_ group : String, key : String) ->  Int{
       return getInGroup(group, key: key) as? Int ?? 0
    }
    
    open class func finshCounter(_ group : String, key : String){
        setInGroup(group, key: key, value: -1)
    }
    
    open class func setInGroup(_ group : String, key : String , value : Any ) {
        let groups = UserDefaults.standard.value(forKey: group) as? NSDictionary ?? NSDictionary()
        let dic = NSMutableDictionary(dictionary: groups)
        dic.setValue(value, forKey: key)
        UserDefaults.standard.set(dic, forKey: group)
        UserDefaults.standard.synchronize()
    }
    
    open class func getInGroup(_ group : String, key : String ) -> Any?{
        let groups = UserDefaults.standard.value(forKey: group) as? NSDictionary
        return groups?.object(forKey: key)
    }
     
}
