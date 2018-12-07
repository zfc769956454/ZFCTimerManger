//
//  BKGCDTimerManager.m
//  AlertDemo
//
//  Created by mac on 2018/3/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZFCGCDTimerManager.h"

@interface ZFCGCDTimerManager()
@property (nonatomic, strong) NSMutableDictionary *timerContainer;
@property (nonatomic, strong) NSMutableDictionary *actionBlockCache;
@end


@implementation ZFCGCDTimerManager

#pragma mark - Public Method
+ (ZFCGCDTimerManager *)sharedInstance {
    static ZFCGCDTimerManager *_gcdTimerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _gcdTimerManager = [[ZFCGCDTimerManager alloc] init];
    });
    
    return _gcdTimerManager;
}

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action {
    if (nil == timerName)
        return;
    
    if (nil == queue)
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        [self.timerContainer setObject:timer forKey:timerName];
    }
    
    /* timer精度为0.01秒 */
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.01 * NSEC_PER_SEC);
    __weak typeof(self) weakSelf = self;
    /* 移除之前的action */
    [weakSelf removeActionCacheForTimer:timerName];
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            action();
        });
        if (!repeats) {
            [weakSelf cancelTimerWithName:timerName];
        }
    });
}

- (void)cancelTimerWithName:(NSString *)timerName {
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer) {
        return;
    }
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
    [self.actionBlockCache removeObjectForKey:timerName];
}

- (BOOL)existTimer:(NSString *)timerName {
    if ([self.timerContainer objectForKey:timerName]) {
        return YES;
    }
    return NO;
}

#pragma mark - Property

- (NSMutableDictionary *)timerContainer {
    if (!_timerContainer) {
        _timerContainer = [[NSMutableDictionary alloc] init];
    }
    return _timerContainer;
}

- (NSMutableDictionary *)actionBlockCache {
    if (!_actionBlockCache) {
        _actionBlockCache = [[NSMutableDictionary alloc] init];
    }
    return _actionBlockCache;
}

#pragma mark - Action Cache

- (void)cacheAction:(dispatch_block_t)action forTimer:(NSString *)timerName {
    id actionArray = [self.actionBlockCache objectForKey:timerName];
    
    if (actionArray && [actionArray isKindOfClass:[NSMutableArray class]]) {
        [(NSMutableArray *)actionArray addObject:action];
    } else {
        NSMutableArray *array = [NSMutableArray arrayWithObject:action];
        [self.actionBlockCache setObject:array forKey:timerName];
    }
}

- (void)removeActionCacheForTimer:(NSString *)timerName {
    if (![self.actionBlockCache objectForKey:timerName])
        return;
    
    [self.actionBlockCache removeObjectForKey:timerName];
}
@end
