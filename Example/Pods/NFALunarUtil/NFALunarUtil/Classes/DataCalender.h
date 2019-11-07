//
//  DataCalender.h
//  FlyCalendar
//
//  Created by 聂飞安 on 2019/8/16.
//  Copyright © 2019 聂飞安. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataCalender : NSObject
+ (NSString *)chineseCalendarOfDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
