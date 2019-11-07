//
//  Lunar.h
//  阳历转阴历
//
//  Created by 孙云飞 on 2016/11/3.
//  Copyright © 2016年 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Solar.h"
@interface Lunar : NSObject

@property(strong,nonatomic) Solar *solar; //阳历时间
/**
 *是否闰月
 */
@property(assign) BOOL isleap;
/**
 *农历 日
 */
@property(assign) int lunarDay;
/**
 *农历 月
 */
@property(assign) int lunarMonth;
/**
 *农历 年
 */
@property(assign) int lunarYear;
//构造
- (instancetype)initWithYear:(int)year andMonth:(int)month andDay:(int)day;


//- (instancetype)init NS_UNAVAILABLE;
@end
