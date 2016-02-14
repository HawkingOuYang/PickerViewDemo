//
//  OnePickerView.m
//  GreenLawyer
//
//  Created by oyxj on 14-9-2.
//  Copyright (c) 2014年 OYXJ. All rights reserved.
//

#import "OnePickerView.h"


@interface OnePickerView ()
{
    UIImageView *m_backgroundImageView;     //1
    UIView      *m_comboView;               //2
    UIView      *m_interactionView;         //3
}
@property (nonatomic, retain)NSArray    *pickerViewDataArray;
@property (nonatomic, retain)NSString   *textSelected;
@end

@implementation OnePickerView
@synthesize delegate;
@synthesize titleLabel  = m_titleLabel;
@synthesize thePickerView = m_thePickerView;
@synthesize title = m_title;
@synthesize pickerViewDataArray;
@synthesize textSelected;

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
    self.thePickerView = nil;
    
    self.title = nil;
    
    self.pickerViewDataArray = nil;
    self.textSelected = nil;
    
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

- (OnePickerView *)initWithTitle:(NSString *)aTitle
             pickerViewDataArray:(NSArray *)aDataArray
                        delegate:(id<OnePickerViewDelegate>)aDelegate
{
    self = [super init];
    if (self)
    {
        self.title = aTitle;
        self.pickerViewDataArray = aDataArray;
        if (self.pickerViewDataArray.count > 0) {
            self.textSelected = [self.pickerViewDataArray objectAtIndex:0];
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
        
        // 选取器
        m_thePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 0, 220, 162.0)];  //(162.0, 180.0 and 216.0)
        m_thePickerView.dataSource = self;
        m_thePickerView.delegate = self;
        [m_interactionView addSubview:m_thePickerView];
        
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
    if ([delegate respondsToSelector:@selector(onePickerView:text:clickedButtonAtIndex:)])
    {
        [delegate onePickerView:self text:self.textSelected clickedButtonAtIndex:0];
    }
    
    [self remove];
}

- (void)btnCancelClicked:(UIButton *)btn
{
    if ([delegate respondsToSelector:@selector(onePickerView:rangeFrom:rangeTo:clickedButtonAtIndex:)])
    {
        [delegate onePickerView:self text:self.textSelected clickedButtonAtIndex:1];
    }
    
    if ([delegate respondsToSelector:@selector(onePickerViewCancel:)])
    {
        [delegate onePickerViewCancel:self];
    }
    
    [self remove];
}


#pragma mark - 设置

//设置默认选中的行
- (void)setupInitialIndex:(NSInteger)aInitialIndex
{
    if (aInitialIndex &&  0 <= aInitialIndex < self.pickerViewDataArray.count) {
        [self.thePickerView selectRow:aInitialIndex inComponent:0 animated:YES];
    }
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerViewDataArray.count;
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
    
    if (component == 0)
    {
        labelView.text = [self.pickerViewDataArray objectAtIndex:row];
    }


    return labelView;
}

#pragma mark - UIPickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.textSelected = [self.pickerViewDataArray objectAtIndex:row];
    }
}


@end
