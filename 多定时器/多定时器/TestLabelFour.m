//
//  TestLabelFour.m
//  多定时器
//
//  Created by mac on 2018/11/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TestLabelFour.h"

@implementation TestLabelFour

- (instancetype)init
{
    if(self=[super init]){
      
        
        [[ZFCTimerManger sharedInstance] addTarget:self handle:^(UILabel *target,ZFCTimerManger *timeManger){
            static int count = 10;
            
            target.text = [NSString stringWithFormat:@"TestLabelFour:%d",count];
            if (count == 0) {
                [target removeFromSuperview];
            }
            count--;
        }];
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"label释放了");
}

@end
