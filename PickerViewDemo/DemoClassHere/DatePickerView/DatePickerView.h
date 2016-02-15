
//
//  DataPickerVie.h
//  MicroAPP
//
//  Created by 佳雄 沈 on 13-8-22.
//  Copyright (c) 2013年 广州市易杰数码科技有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class DatePickerView;
@protocol DatePickerViewDelegate<NSObject>

- (void)didDatePickerViewCancelClicked:(DatePickerView *)aPickerView;
- (void)didDatePickerViewDoneClicked:(DatePickerView *)aPickerView;

@end

@interface DatePickerView : UIView
{
    UIDatePicker *m_datePicker;
    id<DatePickerViewDelegate> delegate;
    UILabel *m_space;
    
    NSString *m_formatTime;
}

@property(nonatomic, retain) UIDatePicker *datePicker;
@property(nonatomic, assign) id<DatePickerViewDelegate> delegate;
@property (nonatomic, retain) UILabel *space;
@property (nonatomic, retain) NSString * formatTime;


-(NSDate *)selectDate;
-(void)changes;
@end

