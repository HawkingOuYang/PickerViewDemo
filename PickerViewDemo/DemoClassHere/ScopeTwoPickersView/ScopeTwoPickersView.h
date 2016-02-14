//
//  ScopeTwoPickersView.h
//  GreenLawyer
//
//  Created by oyxj on 14-9-2.
//  Copyright (c) 2014年 OYXJ. All rights reserved.
//
#import <UIKit/UIKit.h>


@protocol ScopeTwoPickersViewDelegate;

@interface ScopeTwoPickersView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
{
    UILabel         *m_titleLabel;          //默认 设置为居中对齐
    UIPickerView    *m_pickerView1;         //numberOfComponentsInPickerView只能为1
    UIPickerView    *m_pickerView2;         //numberOfComponentsInPickerView只能为1
    UILabel         *m_middleLabel;         //默认 两个picker中间的标签text为"到";
}

@property (nonatomic, assign) id <ScopeTwoPickersViewDelegate> delegate;
@property (nonatomic, retain) UILabel       *titleLabel;
@property (nonatomic, retain) UIPickerView  *pickerView1;
@property (nonatomic, retain) UIPickerView  *pickerView2;
@property (nonatomic, retain) UILabel       *middleLabel;

- (ScopeTwoPickersView *)initWithTitle:(NSString *)aTitle
                  pickerView1DataArray:(NSArray *)aDataArray
                  pickerView2DataArray:(NSArray *)anotherDataArray
                              delegate:(id<ScopeTwoPickersViewDelegate>)aDelegate;

- (void)setupScopeRangeFromIndex:(NSInteger)aIndexRangedFrom
                    rangeToIndex:(NSInteger)aIndexRangedTo;

- (void)show;
- (void)remove;

@end



@protocol ScopeTwoPickersViewDelegate <NSObject>

@optional

- (void)scopeTwoPickersView:(ScopeTwoPickersView *)scopeTwoPickersView
                  rangeFrom:(NSString *)aTextRangedFrom
                    rangeTo:(NSString *)aTextRangedTo
       clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)scopeTwoPickersViewCancel:(ScopeTwoPickersView *)scopeTwoPickersView;

@end
