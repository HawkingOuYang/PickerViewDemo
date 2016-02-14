//
//  TimeScopeTwoPickersView.m
//  GreenLawyer
//
//  Created by oyxj on 14-9-2.
//  Copyright (c) 2014年 OYXJ. All rights reserved.
//

#import "TimeScopeTwoPickersView.h"


@interface TimeScopeTwoPickersView ()
{
    UIImageView *m_backgroundImageView;     //1
    UIView      *m_comboView;               //2
    UIView      *m_interactionView;         //3
}
@property (nonatomic, retain)NSString *theTitle;
@property (nonatomic, assign)NSInteger minHour;
@property (nonatomic, assign)NSInteger maxHour;
@property (nonatomic, assign)NSInteger minutesInterval;
@property (nonatomic, retain)NSString *timeRangedFrom;
@property (nonatomic, retain)NSString *timeRangedTo;
@end

@implementation TimeScopeTwoPickersView
@synthesize delegate;
@synthesize titleLabel  = m_titleLabel;
@synthesize pickerView1 = m_pickerView1;
@synthesize pickerView2 = m_pickerView2;
@synthesize middleLabel = m_middleLabel;
@synthesize theTitle;
@synthesize minHour;
@synthesize maxHour;
@synthesize minutesInterval;
@synthesize timeRangedFrom;
@synthesize timeRangedTo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)dealloc
{
    self.titleLabel  = nil;
    self.pickerView1 = nil;
    self.pickerView2 = nil;
    self.middleLabel = nil;
 
    if (m_backgroundImageView) {
       [m_backgroundImageView release];
        m_backgroundImageView = nil;
    }
    if (m_comboView) {
       [m_comboView release];
        m_comboView = nil;
    }
    if (m_interactionView) {
       [m_interactionView release];
        m_interactionView = nil;
    }
    
    self.theTitle = nil;
    self.timeRangedFrom = nil;
    self.timeRangedTo   = nil;
    
    [super dealloc];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark -

- (TimeScopeTwoPickersView *)initWithTitle:(NSString *)aTitle
                               minimumHour:(NSInteger)aMinHour
                               maximumHour:(NSInteger)aMaxHour
                           minutesInterval:(NSInteger)aMinutesInterval
                                  delegate:(id<TimeScopeTwoPickersViewDelegate>)aDelegate
{
    self = [super init];
    if (self)
    {
        //数据检查，然后分发数据
        self.theTitle = aTitle;
        
        NSInteger tmpMinHour = 0;
        NSInteger tmpMaxHour = 24;
        if (aMinHour < aMaxHour) {
            tmpMinHour = aMinHour;
            tmpMaxHour = aMaxHour;
        }else{
            tmpMinHour = aMaxHour;
            tmpMaxHour = aMinHour;
        }
        self.minHour  = ( 0 < tmpMinHour && tmpMinHour < 24 ? tmpMinHour : 0  );
        self.maxHour  = ( 0 < tmpMaxHour && tmpMaxHour < 24 ? tmpMaxHour : 24 );
        self.minutesInterval = ( 0 < aMinutesInterval && aMinutesInterval < 60
                                 ? ( 60 % aMinutesInterval == 0 ? aMinutesInterval : 30 )
                                 : 30 ); //能被60整除，则可；否则，默认30分钟。
        
        self.delegate = aDelegate;
        
        self.timeRangedFrom = [NSString stringWithFormat:@"%d:00", (int)self.minHour];
        self.timeRangedTo   = [NSString stringWithFormat:@"%d:00", (int)self.maxHour];
        
        
        
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        self.frame = window.bounds;
        
        m_backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        m_backgroundImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:m_backgroundImageView];        //1
        
        // 组合view
        m_comboView = [[UIView alloc] initWithFrame:CGRectMake(30, 120, 260, 260)];
        if (!isScreen4Inch)
        {
            [m_comboView setFrame:CGRectMake(30, 90, 260, 260)];
        }
        m_comboView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        m_comboView.layer.cornerRadius = 5.0;
        [self addSubview:m_comboView];                  //2

        // 标题
        m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 230, 21)];
        m_titleLabel.textAlignment = NSTextAlignmentCenter;
        m_titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        m_titleLabel.text = self.theTitle;
        [m_comboView addSubview:m_titleLabel];
        
        
        // 用户交互相关控件
        CGRect interactionViewFrame = CGRectMake(0, 50, m_comboView.frame.size.width, m_comboView.frame.size.height-50);
        m_interactionView = [[UIView alloc] initWithFrame:interactionViewFrame];
        [m_comboView addSubview:m_interactionView];     //3
        
        // 时间选取器1
        m_pickerView1 = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 0, 110, 162.0)];  //(162.0, 180.0 and 216.0)
        m_pickerView1.dataSource = self;
        m_pickerView1.delegate = self;
        [m_interactionView addSubview:m_pickerView1];
        
        // 时间选取器2
        m_pickerView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(140, 0, 110, 162.0)];  //(162.0, 180.0 and 216.0)
        m_pickerView1.dataSource = self;
        m_pickerView2.delegate = self;
        [m_interactionView addSubview:m_pickerView2];
        
        // 两个选取器中的标签
        m_middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 72, 20, 20)];
        m_middleLabel.font = [UIFont systemFontOfSize:16.0];
        m_middleLabel.textAlignment = NSTextAlignmentCenter;
        m_middleLabel.text = @"到";
        [m_interactionView addSubview:m_middleLabel];
        

        // buttons
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 165, 130, 40)];
        [confirmButton addTarget:self action:@selector(btnConfirmClicked:) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [m_interactionView addSubview:confirmButton];
        [confirmButton release];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 165, 130, 40)];
        [cancelButton addTarget:self action:@selector(btnCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [m_interactionView addSubview:cancelButton];
        [cancelButton release];
        
    }
    return self;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    
    CGRect comboViewFrame = m_comboView.frame;
    if (comboViewFrame.size.height > 260.0)
    {
        if (isScreen4Inch)
        {
            comboViewFrame.origin.y = 90.0;
        }
        else
        {
            comboViewFrame.origin.y = 64.0;
        }
        m_comboView.frame = comboViewFrame;
    }
}

- (void)remove
{
    [self removeFromSuperview];
}


#pragma mark - Events

- (void)btnConfirmClicked:(UIButton *)btn
{
    if ([delegate respondsToSelector:@selector(timeScopeTwoPickersView:rangeFrom:rangeTo:clickedButtonAtIndex:)])
    {
        [delegate timeScopeTwoPickersView:self rangeFrom:self.timeRangedFrom rangeTo:self.timeRangedTo clickedButtonAtIndex:0];
    }
    
    [self remove];
}

- (void)btnCancelClicked:(UIButton *)btn
{
    if ([delegate respondsToSelector:@selector(timeScopeTwoPickersView:rangeFrom:rangeTo:clickedButtonAtIndex:)])
    {
        [delegate timeScopeTwoPickersView:self rangeFrom:self.timeRangedFrom rangeTo:self.timeRangedTo clickedButtonAtIndex:1];
    }
    
    if ([delegate respondsToSelector:@selector(timeScopeTwoPickersViewCancel:)])
    {
        [delegate timeScopeTwoPickersViewCancel:self];
    }
    
    [self remove];
}


#pragma mark - 时间 计算与设置

- (NSString *)timeStringByCalculateRowInteger:(NSInteger)aRowInteger
{//根据所在行 计算 这行的时间(行从0开始计数，对应于pickerView的row)
    
    NSInteger cycleInteger  = 60/self.minutesInterval;  //周期
    NSInteger hourInteger   = aRowInteger/cycleInteger + self.minHour;
    NSInteger minuteInteger = aRowInteger%cycleInteger * self.minutesInterval;
    
    NSString *hourString = nil;
    if (hourInteger < 10) {
        hourString = [NSString stringWithFormat:@"0%d", (int)hourInteger];
    }else{
        hourString = [NSString stringWithFormat:@"%d",  (int)hourInteger];
    }
    NSString *minuteString = nil;
    if (minuteInteger < 10) {
        minuteString = [NSString stringWithFormat:@"0%d", (int)minuteInteger];
    }else{
        minuteString = [NSString stringWithFormat:@"%d",  (int)minuteInteger];
    }
    
    NSString *timeString = [NSString stringWithFormat:@"%@:%@", hourString, minuteString];
    return timeString;
}

- (NSInteger)rowIntegerByCalculateTimeString:(NSString *)aTimeString
{//根据时间 计算 所在的行(行从0开始计数，对应于pickerView的row)
    
    NSArray  *timeComponentsArray = [aTimeString componentsSeparatedByString:@":"];
    if (timeComponentsArray.count != 2)
    {//数据不对，返回
        return 0;
    }
    
    NSInteger hourInteger   = [timeComponentsArray[0] integerValue];
    NSInteger minuteInteger = [timeComponentsArray[1] integerValue];
    NSInteger rowHour   = hourInteger-self.minHour;
    NSInteger rowMinute = minuteInteger/self.minutesInterval;
    NSInteger cycleInteger = 60/self.minutesInterval; //周期
    
    NSInteger rowInteger = rowHour*cycleInteger + rowMinute;  //小时行*周期＋分钟行
    return rowInteger;
}


- (void)setupTimeScopeRangeFrom:(NSString *)aTimeRangedFrom rangeTo:(NSString *)aTimeRangedTo
{//根据时间 设置picker的初始态
    
    //数据检查
    if (!aTimeRangedFrom || !aTimeRangedTo) {
        return;
    }
    
    self.timeRangedFrom = aTimeRangedFrom;
    self.timeRangedTo   = aTimeRangedTo;
    
    NSInteger rowInteger1 = [self rowIntegerByCalculateTimeString:self.timeRangedFrom];
    NSInteger rowInteger2 = [self rowIntegerByCalculateTimeString:self.timeRangedTo];
    if (rowInteger1 == 0 && rowInteger2 == 0)
    {//数据不对，返回
        return;
    }
    
    [self.pickerView1 selectRow:rowInteger1 inComponent:0 animated:YES];
    [self.pickerView2 selectRow:rowInteger2-rowInteger1 inComponent:0 animated:YES];    
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.pickerView1) {
        return 1;
    }
    if (pickerView == self.pickerView2) {
        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowTotal = (self.maxHour-self.minHour) * (60/self.minutesInterval);
    if (self.maxHour != 24) { rowTotal += 1; }  //最大时间不是24点时，行数要加1
    
    if (pickerView == self.pickerView1) {
        NSLog(@"时间滚轮－－－左边行数 %d", (int)rowTotal);
        return rowTotal;
    }
    if (pickerView == self.pickerView2) {
        NSInteger rowSelectedOfPicker1 = [self.pickerView1 selectedRowInComponent:0];
        NSLog(@"时间滚轮－－－右边行数 %d", (int)rowTotal - (int)rowSelectedOfPicker1);
        return (rowTotal - rowSelectedOfPicker1);
    }
    return 0;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel)
    {
        dateLabel = [[[UILabel alloc] init] autorelease];
        dateLabel.font = [UIFont systemFontOfSize:18.0];
        dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    NSString *labelText = nil;
    if (pickerView == self.pickerView1)
    {
        labelText = [self timeStringByCalculateRowInteger:row];
    }
    if (pickerView == self.pickerView2)
    {
        NSInteger rowSelectedOfPicker1 = [self.pickerView1 selectedRowInComponent:0];
        labelText = [self timeStringByCalculateRowInteger:rowSelectedOfPicker1 + row];
    }
    
    dateLabel.text = labelText;
    return dateLabel;
}

#pragma mark - UIPickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{//这个委托方法，只有在 手动拨动pickerView时，才调用； 因此 在手动拨动pickerView1后，重置pickerView2
    
    NSString *timeString = nil;
    if (pickerView == self.pickerView1)
    {
        timeString = [self timeStringByCalculateRowInteger:row];
        
        self.timeRangedFrom = [NSString stringWithString:timeString];
        
        NSComparisonResult result = [self.timeRangedFrom compare: self.timeRangedTo
                                                         options: NSNumericSearch];
        if (result == NSOrderedDescending) {
            [self.pickerView2 reloadComponent:0];
            [self.pickerView2 selectRow:0 inComponent:0 animated:YES];
        }
    }
    if (pickerView == self.pickerView2)
    {
        NSInteger rowSelectedOfPicker1 = [self.pickerView1 selectedRowInComponent:0];
        timeString = [self timeStringByCalculateRowInteger:rowSelectedOfPicker1 + row];
        
        self.timeRangedTo = [NSString stringWithString:timeString];
    }
    
}




@end
