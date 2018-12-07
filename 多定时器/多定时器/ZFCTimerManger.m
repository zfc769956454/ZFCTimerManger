//
//  TimerListener.m
//  多定时器
//
//  Created by mac on 2018/11/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZFCTimerManger.h"
#import "ZFCGCDTimerManager.h"

//加锁
#define SemaphoreBegin \
static dispatch_semaphore_t semaphore; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
semaphore = dispatch_semaphore_create(1); \
}); \
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

//解锁
#define SemaphoreEnd \
dispatch_semaphore_signal(semaphore);

static NSString *const timer = @"timer";

@interface ZFCTimerManger ()

@property (nonatomic ,strong) NSMapTable   *targetsMap;

@end

@implementation ZFCTimerManger

+ (instancetype)sharedInstance {
    
    static ZFCTimerManger *_timeManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _timeManger = [[ZFCTimerManger alloc] init];
    });
    
    return _timeManger;
}


- (instancetype)init
{
    if(self=[super init]){
        self.targetsMap = [NSMapTable mapTableWithKeyOptions:(NSMapTableWeakMemory) valueOptions:NSPointerFunctionsCopyIn];
    }
    return self;
}


- (void)addTarget:(id)target handle:(ZFCTimerMangerHandle)handle{
    if (!handle || !target) return;
    SemaphoreBegin
    [self.targetsMap setObject:handle forKey:target];
    if (self.targetsMap.count > 0) {
        [self startGCDTimer];
    }
    SemaphoreEnd
}

- (void)removeTarget:(id)target {
    if (!target) return;
    SemaphoreBegin
    [self.targetsMap removeObjectForKey:target];
    if(self.targetsMap.count == 0){
        [self stopGCDTimer];
    }
    SemaphoreEnd
}


- (void)removeAllTarget {
    
    SemaphoreBegin
    [self.targetsMap removeAllObjects];
    [self stopGCDTimer];
    SemaphoreEnd
    
}


//开始
- (void)startGCDTimer {

    [[ZFCGCDTimerManager sharedInstance]scheduledDispatchTimerWithName:timer  timeInterval:1.0 queue:nil repeats:YES action:^{
        //防止枚举遍历的时候,添加/移除
        NSMapTable *tempTargetsMap = self.targetsMap.copy;
        for (id target in tempTargetsMap.keyEnumerator) {
            ZFCTimerMangerHandle handle  = [tempTargetsMap objectForKey:target];
            handle(target,self);
        }
    }];
}


//结束
- (void)stopGCDTimer {
    
    [[ZFCGCDTimerManager sharedInstance] cancelTimerWithName:timer];

}

@end
