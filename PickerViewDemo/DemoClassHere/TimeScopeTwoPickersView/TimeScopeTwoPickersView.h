//
//  TimeScopeTwoPickersView.h
//  GreenLawyer
//
//  Created by oyxj on 14-9-2.
//  Copyright (c) 2014年 OYXJ. All rights reserved.
//
#import <UIKit/UIKit.h>


@protocol TimeScopeTwoPickersViewDelegate;

@interface TimeScopeTwoPickersView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UILabel         *m_titleLabel;          //默认 设置为居中对齐
    UIPickerView    *m_pickerView1;         //numberOfComponentsInPickerView只能为1
    UIPickerView    *m_pickerView2;         //numberOfComponentsInPickerView只能为1
    UILabel         *m_middleLabel;         //默认 标签text为"到"
}

@property (nonatomic, assign) id <TimeScopeTwoPickersViewDelegate> delegate;
@property (nonatomic, retain) UILabel       *titleLabel;
@property (nonatomic, retain) UIPickerView  *pickerView1;
@property (nonatomic, retain) UIPickerView  *pickerView2;
@property (nonatomic, retain) UILabel       *middleLabel;

- (TimeScopeTwoPickersView *)initWithTitle:(NSString *)aTitle
                               minimumHour:(NSInteger)aMinHour
                               maximumHour:(NSInteger)aMaxHour
                           minutesInterval:(NSInteger)aMinutesInterval
                                  delegate:(id<TimeScopeTwoPickersViewDelegate>)aDelegate;

- (void)setupTimeScopeRangeFrom:(NSString *)aTimeRangedFrom
                        rangeTo:(NSString *)aTimeRangedTo;

- (void)show;
- (void)remove;

@end



@protocol TimeScopeTwoPickersViewDelegate <NSObject>

@optional

- (void)timeScopeTwoPickersView:(TimeScopeTwoPickersView *)timeScopeTwoPickersView
                      rangeFrom:(NSString *)aTimeRangedFrom
                        rangeTo:(NSString *)aTimeRangedTo
           clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)timeScopeTwoPickersViewCancel:(TimeScopeTwoPickersView *)timeScopeTwoPickersView;

@end
