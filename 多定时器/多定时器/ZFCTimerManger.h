//
//  TimerListener.h
//  多定时器
//
//  Created by mac on 2018/11/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZFCTimerManger;
typedef  void(^ZFCTimerMangerHandle)(id target,ZFCTimerManger *timeManger);

@interface ZFCTimerManger : NSObject

+ (instancetype)sharedInstance;

/**
 添加一个定时器

 @param target 要添加定时器的对象
 @param handle 回调
 */
- (void)addTarget:(id)target handle:(ZFCTimerMangerHandle)handle;


/**
 移除一个定时器

 @param target 前面添加定时器的对象
 */
- (void)removeTarget:(id)target;


/**
 移除所有的定时器,全部移除会自动关闭定时器
 */
- (void)removeAllTarget;

@end


