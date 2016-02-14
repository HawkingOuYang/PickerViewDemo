//
//  ScopeTwoDatePickers.h
//  GreenLawyer
//
//  Created by oyxj on 14-9-2.
//  Copyright (c) 2014年 OYXJ. All rights reserved.
//
#import <UIKit/UIKit.h>

//TODO: 要改成 所在地 选取器
@protocol RegionPickerViewDelegate;

@interface RegionPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UILabel         *m_titleLabel;          //默认 设置为居中对齐
    UIPickerView    *m_pickerView1;         //numberOfComponentsInPickerView只能为1
    
    NSString        *m_title;
}

@property (nonatomic, assign) id <RegionPickerViewDelegate> delegate;
@property (nonatomic, retain) UILabel       *titleLabel;
@property (nonatomic, retain) NSString  *title;
@property (nonatomic, retain) UIPickerView  *pickerView1;

- (RegionPickerView *)initWithTitle:(NSString *)aTitle
                             provinces:(NSMutableArray *)aProvinces
                                 citys:(NSMutableArray *)aCitys
                                  area:(NSMutableArray *)aAreas
                              delegate:(id<RegionPickerViewDelegate>)aDelegate;
- (void)show;
- (void)remove;

//根据所在地的值设置初始化时pickerview应该选中的row
- (void)setupInitialStatusByRegion:(NSString *)aRegion;

@end



@protocol RegionPickerViewDelegate <NSObject>

@optional

- (void)regionPickerView:(RegionPickerView *)regionPickerView
                     region:(NSString *)region
       clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)regionPickerViewCancel:(RegionPickerView *)regionPickerView;

@end
