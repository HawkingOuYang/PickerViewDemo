
//
//  DataPickerVie.m
//  MicroAPP
//
//  Created by 佳雄 沈 on 13-8-22.
//  Copyright (c) 2013年 广州市易杰数码科技有限公司. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView
@synthesize datePicker = m_datePicker;
@synthesize delegate;
@synthesize space = m_space;
@synthesize formatTime = m_formatTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		if ([toolBar respondsToSelector:@selector(setBarTintColor:)]) {
            toolBar.tintColor = [UIColor lightTextColor];
            toolBar.barTintColor = [UIColor darkTextColor];
        }else{
            toolBar.tintColor = [UIColor darkTextColor];
        }
        
		[self addSubview:toolBar];
		
		UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(btnCancelClick:)];
        
		UIBarButtonItem *sureBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确认", nil)
																	style:UIBarButtonItemStyleDone
																   target:self
																   action:@selector(btnOKClick:)];
		[sureBtn setTag:10];
        
//        self.space = [[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 210, 20)] autorelease];
//        self.space.textColor = [UIColor whiteColor];
//        self.space.textAlignment = NSTextAlignmentCenter;
//        self.space.font = [UIFont boldSystemFontOfSize:16.0];
//        self.space.backgroundColor = [UIColor clearColor];
		UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			   target:nil
																			   action:nil];
//        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithCustomView:self.space];
//        space.enabled = YES;

		[toolBar setItems:[NSArray arrayWithObjects:cancelBtn,space,sureBtn,nil]];
		[cancelBtn release];
		[sureBtn release];
		[space release];
        [toolBar release];
        
        
        
        
		self.datePicker = [[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 216)] autorelease];
		self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [self.datePicker setLocale:[[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] autorelease]];//location设置为中国
        
        self.backgroundColor=[UIColor whiteColor];
        [self.datePicker addTarget: self action: @selector(changes) forControlEvents: UIControlEventValueChanged];
		[self addSubview:self.datePicker];
        
    }
    return self;
}


-(void)dealloc
{
    self.space = nil;
    self.datePicker = nil;
    [super dealloc];
}

#pragma mark - Button Click Event

- (void)btnCancelClick:(id)sender
{
    if ([delegate respondsToSelector:@selector(didDatePickerViewCancelClicked:)])
    {
        [delegate didDatePickerViewCancelClicked:self];
    }
}

- (void)btnOKClick:(id)sender
{
    if ([delegate respondsToSelector:@selector(didDatePickerViewDoneClicked:)])
    {
        [delegate didDatePickerViewDoneClicked:self];
    }
}

-(void)changes
{
    if (self.formatTime) {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        
        
        [dateFormatter setDateFormat:self.formatTime];
        
        if (self.datePicker.date)
        {
            NSString *value = [dateFormatter stringFromDate:self.datePicker.date];
            
            self.space.text = value;
        }
    }

    
}

-(NSDate *)selectDate
{
    return self.datePicker.date;
}

@end


