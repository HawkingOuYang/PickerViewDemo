//
//  ViewController.m
//  PickerViewDemo
//
//  Created by OYXJ on 16/2/14.
//  Copyright © 2016年 OYXJ. All rights reserved.
//

#import "ViewController.h"

#import "OnePickerView.h"
#import "ScopeTwoPickersView.h"
#import "TimeScopeTwoPickersView.h"
#import "RegionPickerView.h"


@interface ViewController ()<
OnePickerViewDelegate,
ScopeTwoPickersViewDelegate,
TimeScopeTwoPickersViewDelegate,
RegionPickerViewDelegate>

@property (nonatomic, strong) OnePickerView *onePickerView;
@property (nonatomic, strong) ScopeTwoPickersView *scopeTwoPickersView;
@property (nonatomic, strong) TimeScopeTwoPickersView *timeScopeTwoPickersView;
@property (nonatomic, strong) RegionPickerView *regionPickerView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     pickerview 使用样例
     */
    _onePickerView = [[OnePickerView alloc] initWithTitle:@"onePickerView"
                                      pickerViewDataArray:@[@"1",@"2",@"3",@"4",@"5"]
                                                 delegate:self];
    
    _scopeTwoPickersView = [[ScopeTwoPickersView alloc] initWithTitle:@"scopeTwoPickersView"
                                                 pickerView1DataArray:@[@"一",@"二",@"三",@"四",@"五"]
                                                 pickerView2DataArray:@[@"壹",@"贰",@"叁",@"肆",@"伍"]
                                                             delegate:self];
    
    _timeScopeTwoPickersView = [[TimeScopeTwoPickersView alloc] initWithTitle:@"timeScopeTwoPickersView"
                                                                  minimumHour:6
                                                                  maximumHour:22
                                                              minutesInterval:20
                                                                     delegate:self];
    
    _regionPickerView = [[RegionPickerView alloc] initWithTitle:@"regionPickerView"
                                                      provinces:nil
                                                          citys:nil
                                                           area:nil
                                                       delegate:self];
    

    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 220, 30)];
    [btn1 setTitle:@"onePickerView" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(on1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 40+50*1, 220, 30)];
    [btn2 setTitle:@"scopeTwoPickersView" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(on2) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(20, 40+50*2, 220, 30)];
    [btn3 setTitle:@"timeScopeTwoPickersView" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(on3) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(20, 40+50*3, 220, 30)];
    [btn4 setTitle:@"regionPickerView" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(on4) forControlEvents:UIControlEventTouchUpInside];

    btn1.backgroundColor = [UIColor redColor];
    btn2.backgroundColor = [UIColor greenColor];
    btn3.backgroundColor = [UIColor blueColor];
    btn4.backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
}


#pragma mark - ACTION

- (void)on1
{
    [_onePickerView show];
}

- (void)on2
{
    [_scopeTwoPickersView show];
}

- (void)on3
{
    [_timeScopeTwoPickersView show];
}

- (void)on4
{
    [_regionPickerView show];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
