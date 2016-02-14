//
//  OnePickerView.h
//  GreenLawyer
//
//  Created by oyxj on 14-9-2.
//  Copyright (c) 2014年 OYXJ. All rights reserved.
//
#import <UIKit/UIKit.h>


@protocol OnePickerViewDelegate;

@interface OnePickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
{
    UILabel         *m_titleLabel;            //默认 设置为居中对齐
    UIPickerView    *m_thePickerView;         //numberOfComponentsInPickerView只能为1
    
    NSString        *m_title;
}

@property (nonatomic, assign) id <OnePickerViewDelegate> delegate;
@property (nonatomic, retain) UILabel       *titleLabel;
@property (nonatomic, retain) UIPickerView  *thePickerView;
@property (nonatomic, retain) NSString  *title;

- (OnePickerView *)initWithTitle:(NSString *)aTitle
             pickerViewDataArray:(NSArray *)aDataArray
                        delegate:(id<OnePickerViewDelegate>)aDelegate;

//设置默认选中的行
- (void)setupInitialIndex:(NSInteger)aInitialIndex;

- (void)show;
- (void)remove;

@end



@protocol OnePickerViewDelegate <NSObject>

@optional

- (void)onePickerView:(OnePickerView *)onePickerView
                 text:(NSString *)aTextSelected
 clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)onePickerViewCancel:(OnePickerView *)onePickerView;

@end
