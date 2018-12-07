//
//  TestLabelTwo.m
//  多定时器
//
//  Created by mac on 2018/11/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TestLabelTwo.h"

@implementation TestLabelTwo

- (instancetype)init
{
    if(self=[super init]){
        [[ZFCTimerManger sharedInstance] addTarget:self handle:^(UILabel *target,ZFCTimerManger *timeManger){
            static int count = 80;
            if (count == 0) {
                [timeManger removeTarget:target];
            }
            target.text = [NSString stringWithFormat:@"TestLabelTwo:%d",count];
            count--;
        }];
        
    }
    return self;
}

@end
