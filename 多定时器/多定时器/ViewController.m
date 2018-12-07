//
//  ViewController.m
//  多定时器
//
//  Created by mac on 2018/11/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ViewController.h"
#import "ZFCTimerManger.h"

#import "TestLabelOne.h"
#import "TestLabelTwo.h"
#import "TestLabelThree.h"
#import "TestLabelFour.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    TestLabelOne *label=[TestLabelOne new];
    label.frame=CGRectMake(50, 100, 200, 100);
    label.backgroundColor=[UIColor lightGrayColor];
    label.textColor=[UIColor redColor];
    
    TestLabelTwo *labelTwo=[TestLabelTwo new];
    labelTwo.frame=CGRectMake(50, CGRectGetMaxY(label.frame) + 20, 200, 100);
    labelTwo.backgroundColor=[UIColor lightGrayColor];
    labelTwo.textColor=[UIColor redColor];
   
    
    TestLabelThree *labelThree=[TestLabelThree new];
    labelThree.frame=CGRectMake(50, CGRectGetMaxY(labelTwo.frame) + 20, 200, 100);
    labelThree.backgroundColor=[UIColor lightGrayColor];
    labelThree.textColor=[UIColor redColor];
   
    
    
    TestLabelFour *labelFour=[TestLabelFour new];
    labelFour.frame=CGRectMake(50, CGRectGetMaxY(labelThree.frame) + 20, 200, 100);
    labelFour.backgroundColor=[UIColor lightGrayColor];
    labelFour.textColor=[UIColor redColor];
    
    
    [self.view addSubview:label];
    [self.view addSubview:labelTwo];
    [self.view addSubview:labelThree];
    [self.view addSubview:labelFour];
    
    
    
}


@end
