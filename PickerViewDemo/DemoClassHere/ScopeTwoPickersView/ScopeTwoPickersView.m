//
//  ScopeTwoPickersView.m
//  GreenLawyer
//
//  Created by oyxj on 14-9-2.
//  Copyright (c) 2014年 OYXJ. All rights reserved.
//

#import "ScopeTwoPickersView.h"


@interface ScopeTwoPickersView ()
{
    UIImageView *m_backgroundImageView;     //1
    UIView      *m_comboView;               //2
    UIView      *m_interactionView;         //3
}
@property (nonatomic, retain)NSString   *title;
@property (nonatomic, retain)NSString   *middleLabelTitle;
@property (nonatomic, retain)NSArray    *pickerView1DataArray;
@property (nonatomic, retain)NSArray    *pickerView2DataArray;
@property (nonatomic, retain)NSString   *textRangedFrom;
@property (nonatomic, retain)NSString   *textRangedTo;
@end

@implementation ScopeTwoPickersView
@synthesize delegate;
@synthesize titleLabel  = m_titleLabel;
@synthesize pickerView1 = m_pickerView1;
@synthesize pickerView2 = m_pickerView2;
@synthesize middleLabel = m_middleLabel;
@synthesize title;
@synthesize middleLabelTitle;
@synthesize pickerView1DataArray;
@synthesize pickerView2DataArray;
@synthesize textRangedFrom;
@synthesize textRangedTo;

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
    
    self.title = nil;
    self.middleLabelTitle = nil;
    
    self.pickerView1DataArray = nil;
    self.pickerView2DataArray = nil;
    self.textRangedFrom = nil;
    self.textRangedTo = nil;
    
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

- (ScopeTwoPickersView *)initWithTitle:(NSString *)aTitle
                  pickerView1DataArray:(NSArray *)aDataArray
                  pickerView2DataArray:(NSArray *)anotherDataArray
                              delegate:(id<ScopeTwoPickersViewDelegate>)aDelegate
{
    self = [super init];
    if (self)
    {
        self.title = aTitle;
        self.pickerView1DataArray = aDataArray;
        self.pickerView2DataArray = anotherDataArray;
        if (self.pickerView1DataArray.count > 0) {
            self.textRangedFrom = [self.pickerView1DataArray objectAtIndex:0];
        }
        if (self.pickerView2DataArray.count > 0) {
            self.textRangedTo   = [self.pickerView2DataArray objectAtIndex:0];
        }
        self.delegate = aDelegate;
        
        
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        self.frame = window.bounds;
        
        m_backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        m_backgroundImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:m_backgroundImageView];    //1
        
        
        // 组合view
        m_comboView = [[UIView alloc] initWithFrame:CGRectMake(30, 120, 260, 260)];
        if (!isScreen4Inch)
        {
            [m_comboView setFrame:CGRectMake(30, 90, 260, 260)];
        }
        m_comboView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        m_comboView.layer.cornerRadius = 5.0;
        [self addSubview:m_comboView];              //2
        
        
        // 标题
        m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 230, 21)];
        m_titleLabel.textAlignment = NSTextAlignmentCenter;
        m_titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        m_titleLabel.text = self.title;
        [m_comboView addSubview:m_titleLabel];
        
        
        // 用户交互相关控件
        CGRect interactionViewFrame = CGRectMake(0, 50, m_comboView.frame.size.width, m_comboView.frame.size.height-50);
        m_interactionView = [[UIView alloc] initWithFrame:interactionViewFrame];
        [m_comboView addSubview:m_interactionView]; //3
        
        // 选取器1
        m_pickerView1 = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 0, 110, 162.0)];  //(162.0, 180.0 and 216.0)
        m_pickerView1.dataSource = self;
        m_pickerView1.delegate = self;
        [m_interactionView addSubview:m_pickerView1];
        
        // 选取器2
        m_pickerView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(140, 0, 110, 162.0)];  //(162.0, 180.0 and 216.0)
        m_pickerView2.dataSource = self;
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
    if ([delegate respondsToSelector:@selector(scopeTwoPickersView:rangeFrom:rangeTo:clickedButtonAtIndex:)])
    {
        [delegate scopeTwoPickersView:self rangeFrom:self.textRangedFrom rangeTo:self.textRangedTo clickedButtonAtIndex:0];
    }
    
    [self remove];
}

- (void)btnCancelClicked:(UIButton *)btn
{
    if ([delegate respondsToSelector:@selector(scopeTwoPickersView:rangeFrom:rangeTo:clickedButtonAtIndex:)])
    {
        [delegate scopeTwoPickersView:self rangeFrom:self.textRangedFrom rangeTo:self.textRangedTo clickedButtonAtIndex:1];
    }
    
    if ([delegate respondsToSelector:@selector(scopeTwoPickersViewCancel:)])
    {
        [delegate scopeTwoPickersViewCancel:self];
    }
    
    [self remove];
}

#pragma mark - 设置

- (void)setupScopeRangeFromIndex:(NSInteger)aIndexRangedFrom rangeToIndex:(NSInteger)aIndexRangedTo
{
    if (aIndexRangedFrom &&  0 <= aIndexRangedFrom < self.pickerView1DataArray.count) {
        [self.pickerView1 selectRow:aIndexRangedFrom inComponent:0 animated:YES];
    }
    if (aIndexRangedTo   &&  0 <= aIndexRangedTo   < self.pickerView2DataArray.count) {
        [self.pickerView2 selectRow:aIndexRangedTo   inComponent:0 animated:YES];
    }

    if (self.pickerView1DataArray.count > aIndexRangedFrom) {
        self.textRangedFrom = [self.pickerView1DataArray objectAtIndex:aIndexRangedFrom];
    }
    if (self.pickerView2DataArray.count > aIndexRangedTo) {
        self.textRangedTo   = [self.pickerView2DataArray objectAtIndex:aIndexRangedTo];
    }
    
}


#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.pickerView1)
    {
        return self.pickerView1DataArray.count;
    }
    if (pickerView == self.pickerView2)
    {
        return self.pickerView2DataArray.count;
    }
    return 0;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelView = (UILabel *)view;
    if (!labelView)
    {
        labelView = [[[UILabel alloc] init] autorelease];
        
        labelView.font = [UIFont systemFontOfSize:18.0];
        labelView.textAlignment = NSTextAlignmentCenter;
    }
    
    if (pickerView == self.pickerView1)
    {
        if (component == 0)
        {
            labelView.text = [self.pickerView1DataArray objectAtIndex:row];
        }
    }
    if (pickerView == self.pickerView2)
    {
        if (component == 0)
        {
            labelView.text = [self.pickerView2DataArray objectAtIndex:row];
        }
    }
    
    
    return labelView;
}

#pragma mark - UIPickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.pickerView1)
    {
        if (component == 0)
        {
            self.textRangedFrom = [self.pickerView1DataArray objectAtIndex:row];
        }
    }
    if (pickerView == self.pickerView2)
    {
        if (component == 0)
        {
            self.textRangedTo = [self.pickerView2DataArray objectAtIndex:row];
        }
    }
}


@end
