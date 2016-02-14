//
//  ScopeTwoDatePickers.m
//  GreenLawyer
//
//  Created by oyxj on 14-9-2.
//  Copyright (c) 2014年 OYXJ. All rights reserved.
//

#import "RegionPickerView.h"

@interface RegionPickerView ()
{
    UIImageView *m_backgroundImageView;
    UIView *m_comboView;
    UIView *m_interactionView;
    
    NSMutableArray *m_countryMutableArray;
    NSMutableArray *m_provinceMutableArray;
    NSMutableArray *m_cityMutableArray;
    NSMutableArray *m_areaMutableArray;
    
    NSString *m_regionStr;
    
    NSString *m_province;
    NSString *m_city;
    NSString *m_area;
}
@property (nonatomic, retain) NSString *province;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *area;
@property (nonatomic, retain) NSMutableArray *countryMutableArray;
@property (nonatomic, retain) NSMutableArray *provinceMutableArray;
@property (nonatomic, retain) NSMutableArray *cityMutableArray;
@property (nonatomic, retain) NSMutableArray *areaMutableArray;
@property (nonatomic, retain) NSString *regionStr;

@property (nonatomic, retain) NSDictionary *plistDataAsDictionary;//plist数据源

@end

@implementation RegionPickerView
@synthesize delegate;
@synthesize title = m_title;
@synthesize titleLabel = m_titleLabel;
@synthesize countryMutableArray = m_countryMutableArray;
@synthesize provinceMutableArray = m_provinceMutableArray;
@synthesize cityMutableArray = m_cityMutableArray;
@synthesize areaMutableArray = m_areaMutableArray;
@synthesize regionStr = m_regionStr;
@synthesize pickerView1 = m_pickerView1;
@synthesize province = m_province;
@synthesize city = m_city;
@synthesize area = m_area;

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
    self.title = nil;
    self.province = nil;
    self.city = nil;
    self.area = nil;
    
    [self setCountryMutableArray:nil];
    [self setProvinceMutableArray:nil];
    [self setCityMutableArray:nil];
    [self setAreaMutableArray:nil];
    
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

    self.plistDataAsDictionary = nil;//plist数据源
    
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

- (RegionPickerView *)initWithTitle:(NSString *)aTitle
                             provinces:(NSMutableArray *)aProvinces
                                 citys:(NSMutableArray *)aCitys
                                  area:(NSMutableArray *)aAreas
                              delegate:(id<RegionPickerViewDelegate>)aDelegate
{
    self = [super init];
    if (self)
    {
        self.title     = aTitle;
        self.delegate = aDelegate;
        
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        self.frame = window.bounds;
        
        m_backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        m_backgroundImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:m_backgroundImageView];
        
        // 组合view
        m_comboView = [[UIView alloc] initWithFrame:CGRectMake(30, 120, 260, 260)];
        if (!isScreen4Inch)
        {
            [m_comboView setFrame:CGRectMake(30, 90, 260, 260)];
        }
        m_comboView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        m_comboView.layer.cornerRadius = 5.0;

        // 标题
        m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 230, 21)];
        m_titleLabel.textAlignment = NSTextAlignmentCenter;
        m_titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        m_titleLabel.text = self.title;
        [m_comboView addSubview:m_titleLabel];
        
        
        // 用户交互相关控件
        CGRect interactionViewFrame = CGRectMake(0, 50, m_comboView.frame.size.width, m_comboView.frame.size.height-50);
        m_interactionView = [[UIView alloc] initWithFrame:interactionViewFrame];
        [m_comboView addSubview:m_interactionView];
        
        // 时间选取器1
        m_pickerView1 = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 0, 240, 80)];  //(162.0, 180.0 and 216.0)
        m_pickerView1.dataSource = self;
        m_pickerView1.delegate = self;
        [m_interactionView addSubview:m_pickerView1];
        
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
        
        [self addSubview:m_comboView];
        
        
        [self loadCountryArrayFromDB];
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
        [m_comboView setFrame:comboViewFrame];
    }
}

- (void)remove
{
    [self removeFromSuperview];
}


- (void)loadCountryArrayFromDB
{
    NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:@"ChinaArea" ofType:@"plist"];
    if (plistFilePath) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistFilePath];
        if (dic) {
            [self setPlistDataAsDictionary: dic];//retain
        }
    }
    
    
    m_countryMutableArray = [[NSMutableArray alloc]init];
    
    /*
    NSArray *countryArr = [[BusinessManager sharedManager].cityManager cityWithCityType:[NSNumber numberWithInteger:kRegionTypeCountry] superCityCodeDic:nil];
    NSArray *overseasCountryArr = [[BusinessManager sharedManager].cityManager cityWithCityType:[NSNumber numberWithInteger:1] superCityCodeDic:nil];
    // cityWithCityType:[NSNumber numberWithInteger:1]    因为从网络请求列表,用kRegionTypeOverseas(4),   而保存到数据库的外国城市cType字段是1
    */
    
    /**
     国
     */
    NSArray *countryArr = @[@"中国"];
    NSArray *overseasCountryArr = nil;
    
    
    if ([countryArr count])
    {
        if (self.countryMutableArray)
        {
            [self setCountryMutableArray:nil];
        }

        [self setCountryMutableArray:[NSMutableArray arrayWithArray:countryArr]];
        if ([overseasCountryArr count])
        {
            [m_countryMutableArray addObjectsFromArray:overseasCountryArr];
        }

        /*
        CityEntity *aCountry = [m_countryMutableArray firstObject];
        NSString *stateCode = aCountry.code;
        NSDictionary *codeDic = [NSDictionary dictionaryWithObject:stateCode forKey:@"stateCode"];
        NSArray *provinceArr = [[BusinessManager sharedManager].cityManager cityWithCityType:nil superCityCodeDic:codeDic];
        */
        
        /**
         省
         */
        NSArray *provinceArr = nil;
        
        
        NSMutableArray *tmpMArr = [NSMutableArray array];
        
        NSArray *allKeys = [self.plistDataAsDictionary allKeys];
        allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 intValue] < [obj2 intValue]) {
                return NSOrderedAscending;
            } else if ([obj1 intValue] > [obj2 intValue]) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        for (NSString *key in allKeys) {
            NSDictionary *provinceDic = [self.plistDataAsDictionary objectForKey:key];
            [tmpMArr addObjectsFromArray: [provinceDic allKeys]];
        }
        provinceArr = tmpMArr;
        
        
        if ([provinceArr count])
        {
            [self setProvinceMutableArray:[NSMutableArray arrayWithArray:provinceArr]];
        }
        
        [self initCityArray];
        [self initAreaArray];
    }
}

//默认初始化城市数组根据第一个省份
- (void)initCityArray
{
    if(m_provinceMutableArray.count)
    {
        /*
        CityEntity *aCityEntity = nil;
        aCityEntity = [m_provinceMutableArray firstObject];
        
        NSString *provinceCode = aCityEntity.code;
        NSDictionary *codeDic = [NSDictionary dictionaryWithObject:provinceCode forKey:@"provinceCode"];
        NSArray *cityArr = [[BusinessManager sharedManager].cityManager cityWithCityType:nil superCityCodeDic:codeDic];
        */
        
        /**
         市
         */
        NSArray *cityArr = nil;
        
        
        NSMutableArray *tmpMArr = [NSMutableArray array];
        
        NSArray *allKeys = [self.plistDataAsDictionary allKeys];
        allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return NSOrderedAscending;
            } else if ([obj1 integerValue] > [obj2 integerValue]) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        for (NSString *key in allKeys) {
            NSDictionary *provinceDic = [self.plistDataAsDictionary objectForKey:key];
            
            NSArray *allValues = [provinceDic allValues];
            allValues = [allValues sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                if ([[obj1 allKeys].firstObject intValue] < [[obj2 allKeys].firstObject intValue]) {
                    return NSOrderedAscending;
                } else if ([[obj1 allKeys].firstObject intValue] > [[obj2 allKeys].firstObject intValue]) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }];
            
            for (NSDictionary *dic in allValues) {
                NSDictionary *cityDic = [dic allValues].firstObject;
                [tmpMArr addObjectsFromArray: [cityDic allKeys]];
            }
            break;//默认初始化城市数组根据第一个省份
        }
        cityArr = tmpMArr;
        
        
        if(cityArr.count)
        {
            [self setCityMutableArray:[NSMutableArray arrayWithArray:cityArr]];
        }
    }
}

//默认初始化区域数组根据第一个城市
- (void)initAreaArray
{
    if(m_cityMutableArray.count)
    {
        /*
        CityEntity *aCityEntity = nil;

        aCityEntity = [m_cityMutableArray firstObject];
        
        NSString *cityCode = aCityEntity.code;
        NSDictionary *codeDic = [NSDictionary dictionaryWithObject:cityCode forKey:@"cityCode"];
        NSArray *areaArr = [[BusinessManager sharedManager].cityManager cityWithCityType:nil superCityCodeDic:codeDic];
        */
        
        /**
         区
         */
        NSArray *areaArr = nil;
        
        
        NSMutableArray *tmpMArr = [NSMutableArray array];
        
        NSArray *allKeys = [self.plistDataAsDictionary allKeys];
        allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return NSOrderedAscending;
            } else if ([obj1 integerValue] > [obj2 integerValue]) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        for (NSString *key in allKeys) {
            NSDictionary *provinceDic = [self.plistDataAsDictionary objectForKey:key];
            
            NSArray *allValues = [provinceDic allValues];
            allValues = [allValues sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                if ([[obj1 allKeys].firstObject intValue] < [[obj2 allKeys].firstObject intValue]) {
                    return NSOrderedAscending;
                } else if ([[obj1 allKeys].firstObject intValue] > [[obj2 allKeys].firstObject intValue]) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }];
            
            for (NSDictionary *dic in allValues) {
                NSDictionary *cityDic = [dic allValues].firstObject;
                tmpMArr = [cityDic allValues].firstObject;
                
                break;//默认初始化城市数组根据第一个市
            }
            break;//默认初始化城市数组根据第一个市
        }
        areaArr = tmpMArr;
        
        
        if(areaArr.count)
        {
            [self setAreaMutableArray:[NSMutableArray arrayWithArray:areaArr]];
        }
    }
}

- (void)setupInitialStatusByRegion:(NSString *)aRegion
{
    if(aRegion.length > 0)
    {
        NSArray *regionArray = [aRegion componentsSeparatedByString:@","];
        
        if(regionArray.count == 1)
        {
            self.province = regionArray[0];
        }
        else if(regionArray.count == 2)
        {
            self.province = regionArray[0];
            self.city = regionArray[1];
        }
        else
        {
            self.province = regionArray[0];
            self.city = regionArray[1];
            self.area = regionArray[2];
        }
        
        if(self.province && self.province.length > 0)
        {
            [self selectCurrentRowWithRegionValue:self.province
                                              arr:self.provinceMutableArray
                                        regionKey:@"provinceCode"
                                        component:0];
        }
        
        if(self.city && self.province.length > 0)
        {
            [self selectCurrentRowWithRegionValue:self.city
                                              arr:self.cityMutableArray
                                        regionKey:@"cityCode"
                                        component:1];
        }
        else
        {
            if(self.cityMutableArray.count)
            {
                /*
                [self selectCurrentRowWithRegionValue:[self.cityMutableArray[0] name]
                                                  arr:self.cityMutableArray
                                            regionKey:@"cityCode"
                                            component:1];
                */
                
                [self selectCurrentRowWithRegionValue:[self.cityMutableArray[0] description]
                                                  arr:self.cityMutableArray
                                            regionKey:@"cityCode"
                                            component:1];
            }
        }
            
        if(self.area && self.province.length > 0)
        {
            [self selectCurrentRowWithRegionValue:self.area
                                              arr:self.areaMutableArray
                                        regionKey:nil
                                        component:2];
        }
    }
}

//根据当前省份、城市或者区域的字符串值,选中它们在pickerView中所在的row
- (void)selectCurrentRowWithRegionValue:(NSString *)regionValue
                                    arr:(NSMutableArray *)arr
                              regionKey:(NSString *)regionKey
                              component:(int)component
{
    /*
    CityEntity *aEntity = nil;
     */
    NSString *location = nil;
    
    //清空缓存数字，避免出现错误的地区组合
    if(component == 0)
        [self.cityMutableArray removeAllObjects];
    else if(component == 1)
        [self.areaMutableArray removeAllObjects];
    
    //搜索当前区域在所在组中row，并选row
    for(int i=0; i<arr.count; i++)
    {
        /*
        NSRange rangeValue = [[arr[i]name] rangeOfString:regionValue options:NSCaseInsensitiveSearch];
        */
        NSRange rangeValue = [[arr[i]description] rangeOfString:regionValue options:NSCaseInsensitiveSearch];
         
        if(rangeValue.location != NSNotFound)
        {
            [self.pickerView1 selectRow:i inComponent:component animated:YES];
            /*
            aEntity = arr[i];
             */
            location = [arr[i]description];
            break;
        }
        else
        {
            /*
            aEntity = arr[0];
            */
            location = [arr[0]description];
        }
    }

    if(component < 2)
    {
        /*
        NSString *provinceCode = aEntity.code;
        NSDictionary *codeDic = [NSDictionary dictionary];

        if(provinceCode)
            codeDic = [NSDictionary dictionaryWithObject:provinceCode forKey:regionKey];
        NSArray *cityArr = [[BusinessManager sharedManager].cityManager cityWithCityType:nil superCityCodeDic:codeDic];
        
        if(cityArr.count)
        {
            if([regionKey isEqualToString:@"provinceCode"])
            {
                [self setCityMutableArray:[NSMutableArray arrayWithArray:cityArr]];
            }
            else if([regionKey isEqualToString:@"cityCode"])
            {
                [self setAreaMutableArray:[NSMutableArray arrayWithArray:cityArr]];
            }
        }
         */
        
        if([regionKey isEqualToString:@"provinceCode"])
        {
            
            /**
             市
             */
            NSArray *cityArr = nil;
            
            
            NSMutableArray *tmpMArr = [NSMutableArray array];
            
            NSArray *allKeys = [self.plistDataAsDictionary allKeys];
            allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return NSOrderedAscending;
                } else if ([obj1 integerValue] > [obj2 integerValue]) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }];
            for (NSString *key in allKeys) {
                NSDictionary *provinceDic = [self.plistDataAsDictionary objectForKey:key];
                NSString *provice = [provinceDic allKeys].firstObject;
                if ([provice isEqualToString: regionValue]) {
                    
                    NSArray *allValues = [provinceDic allValues];
                    allValues = [allValues sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        
                        if ([[obj1 allKeys].firstObject intValue] < [[obj2 allKeys].firstObject intValue]) {
                            return NSOrderedAscending;
                        } else if ([[obj1 allKeys].firstObject intValue] > [[obj2 allKeys].firstObject intValue]) {
                            return NSOrderedDescending;
                        } else {
                            return NSOrderedSame;
                        }
                    }];
                    
                    for (NSDictionary *dic in allValues) {
                        NSDictionary *cityDic = [dic allValues].firstObject;
                        [tmpMArr addObjectsFromArray: [cityDic allKeys]];
                    }
                }
            }
            cityArr = tmpMArr;
            
            
            [self setCityMutableArray:[NSMutableArray arrayWithArray:cityArr]];
        }
        else if([regionKey isEqualToString:@"cityCode"])
        {
            
            /**
             区
             */
            NSArray *areaArr = nil;
            
            
            NSMutableArray *tmpMArr = [NSMutableArray array];
            
            NSArray *allKeys = [self.plistDataAsDictionary allKeys];
            allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return NSOrderedAscending;
                } else if ([obj1 integerValue] > [obj2 integerValue]) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }];
            for (NSString *key in allKeys) {
                NSDictionary *provinceDic = [self.plistDataAsDictionary objectForKey:key];
                
                NSArray *allValues = [provinceDic allValues];
                allValues = [allValues sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    
                    if ([[obj1 allKeys].firstObject intValue] < [[obj2 allKeys].firstObject intValue]) {
                        return NSOrderedAscending;
                    } else if ([[obj1 allKeys].firstObject intValue] > [[obj2 allKeys].firstObject intValue]) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                BOOL isShouldBreak = NO;
                
                for (NSDictionary *dic in allValues) {
                    NSDictionary *cityDic = [dic allValues].firstObject;
                    NSString *city = [cityDic allKeys].firstObject;
                    if ([city isEqualToString: regionValue]) {
                        tmpMArr = [cityDic allValues].firstObject;
                        
                        isShouldBreak = YES;
                    }
                }
                
                if (isShouldBreak) {
                    break;
                }
            }
            areaArr = tmpMArr;
            
            
            [self setAreaMutableArray:[NSMutableArray arrayWithArray:areaArr]];
        }

    }

    [self.pickerView1 reloadAllComponents];

}

- (void)mergeAreaStr
{
    /*
    self.province = [[m_provinceMutableArray objectAtIndex:[self.pickerView1 selectedRowInComponent:0]] name];
    */
    self.province = [[m_provinceMutableArray objectAtIndex:[self.pickerView1 selectedRowInComponent:0]] description];
    
    if(m_cityMutableArray.count)
        /*
        self.city = [[m_cityMutableArray objectAtIndex:[self.pickerView1 selectedRowInComponent:1]] name];
        */
        self.city = [[m_cityMutableArray objectAtIndex:[self.pickerView1 selectedRowInComponent:1]] description];
    else
        self.city = @"";
    
    if(m_areaMutableArray.count)
        /*
        self.area = [[m_areaMutableArray objectAtIndex:[self.pickerView1 selectedRowInComponent:2]] name];
         */
        self.area = [[m_areaMutableArray objectAtIndex:[self.pickerView1 selectedRowInComponent:2]] description];
    else
        self.area = @"";
    
    
    if([self.city isEqualToString:@""])
        self.regionStr = [NSString stringWithFormat:@"%@",self.province];
    else if([self.area isEqualToString:@""])
        self.regionStr = [NSString stringWithFormat:@"%@,%@",self.province,self.city];
    else
        self.regionStr = [NSString stringWithFormat:@"%@,%@,%@",self.province,self.city,self.area];
}

#pragma mark - update DATA

- (NSArray *)updateCityByProvince:(NSString *)regionValue
{
    /**
     市
     */
    NSArray *cityArr = nil;
    
    
    NSMutableArray *tmpMArr = [NSMutableArray array];
    
    NSArray *allKeys = [self.plistDataAsDictionary allKeys];
    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;
        } else if ([obj1 integerValue] > [obj2 integerValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    for (NSString *key in allKeys) {
        NSDictionary *provinceDic = [self.plistDataAsDictionary objectForKey:key];
        NSString *provice = [provinceDic allKeys].firstObject;
        if ([provice isEqualToString: regionValue]) {
            
            NSArray *allValues = [provinceDic allValues];
            allValues = [allValues sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                if ([[obj1 allKeys].firstObject intValue] < [[obj2 allKeys].firstObject intValue]) {
                    return NSOrderedAscending;
                } else if ([[obj1 allKeys].firstObject intValue] > [[obj2 allKeys].firstObject intValue]) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }];
            
            for (NSDictionary *dic in allValues) {
                NSArray *values = [dic allValues];
                for (NSDictionary *cityDic in values) {
                    [tmpMArr addObjectsFromArray: [cityDic allKeys]];
                }
            }
        }
    }
    cityArr = tmpMArr;
    
    return cityArr;
}

- (NSArray *)updateAreaByCity:(NSString *)regionValue
{
    /**
     区
     */
    NSArray *areaArr = nil;
    
    
    NSMutableArray *tmpMArr = [NSMutableArray array];
    
    NSArray *allKeys = [self.plistDataAsDictionary allKeys];
    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;
        } else if ([obj1 integerValue] > [obj2 integerValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    for (NSString *key in allKeys) {
        NSDictionary *provinceDic = [self.plistDataAsDictionary objectForKey:key];
        
        NSArray *allValues = [provinceDic allValues];
        allValues = [allValues sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            if ([[obj1 allKeys].firstObject intValue] < [[obj2 allKeys].firstObject intValue]) {
                return NSOrderedAscending;
            } else if ([[obj1 allKeys].firstObject intValue] > [[obj2 allKeys].firstObject intValue]) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        
        BOOL isShouldBreak = NO;
        
        for (NSDictionary *dic in allValues) {
            NSDictionary *cityDic = [dic allValues].firstObject;
            NSString *city = [cityDic allKeys].firstObject;
            if ([city isEqualToString: regionValue]) {
                tmpMArr = [cityDic allValues].firstObject;
                
                isShouldBreak = YES;
            }
        }
        
        if (isShouldBreak) {
            break;
        }
    }
    areaArr = tmpMArr;
    
    return areaArr;
}

#pragma mark - Events

- (void)btnConfirmClicked:(UIButton *)btn
{
    [self mergeAreaStr];
    
    if ([delegate respondsToSelector:@selector(regionPickerView:region:clickedButtonAtIndex:)])
    {
        [delegate regionPickerView:self region:self.regionStr clickedButtonAtIndex:0];
    }
    
    [self remove];
}

- (void)btnCancelClicked:(UIButton *)btn
{
    if ([delegate respondsToSelector:@selector(regionPickerView:region:clickedButtonAtIndex:)])
    {
        [delegate regionPickerView:self region:self.regionStr clickedButtonAtIndex:1];
    }
    
    if ([delegate respondsToSelector:@selector(regionPickerViewCancel::)])
    {
        [delegate regionPickerViewCancel:self];
    }
    
    [self remove];
}



#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return m_provinceMutableArray.count;
    else if(component == 1)
        return m_cityMutableArray.count;
    else
        return m_areaMutableArray.count;}


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
        /*
        labelView.text = [(CityEntity *)[m_provinceMutableArray objectAtIndex:row] name];
         */
        labelView.text = [[m_provinceMutableArray objectAtIndex:row] description];
    }
    else if (component == 1)
    {
        /*
        labelView.text = [(CityEntity *)[m_cityMutableArray objectAtIndex:row]name];
        */
        labelView.text = [[m_cityMutableArray objectAtIndex:row] description];
    }
    else if (component == 2)
    {
        /*
        labelView.text = [(CityEntity *)[m_areaMutableArray objectAtIndex:row] name];
        */
        labelView.text = [[m_areaMutableArray objectAtIndex:row] description];
    }
    
    return labelView;
}

#pragma mark - UIPickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    /*
    CityEntity *aCityEntity = nil;
     */
    
    self.province = nil;
    self.city = nil;
    self.area = nil;
    self.regionStr = nil;
    
    if (component == 0)
    {
        [m_areaMutableArray removeAllObjects];
        
        /*
        aCityEntity = [m_provinceMutableArray objectAtIndex:row];
        
        NSString *provinceCode = aCityEntity.code;
        NSDictionary *codeDic = [NSDictionary dictionaryWithObject:provinceCode forKey:@"provinceCode"];
        NSArray *cityArr = [[BusinessManager sharedManager].cityManager cityWithCityType:nil superCityCodeDic:codeDic];
        */
        
        NSString *regionValue = [[m_provinceMutableArray objectAtIndex:row] description];
        
        
        NSArray *cityArr = [self updateCityByProvince: regionValue];
        
        
        if(cityArr.count)
        {
            [self setCityMutableArray:[NSMutableArray arrayWithArray:cityArr]];
            
            
            NSArray *areaArr = [self updateAreaByCity: cityArr[0]];
            [self setAreaMutableArray: [NSMutableArray arrayWithArray:areaArr]];
        }
        else
        {
            [m_cityMutableArray removeAllObjects];
        }
        
        
        /*
        self.province = aCityEntity.name;
        */
        self.province = regionValue;
        
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadAllComponents];
        
    }
    else if(component == 1)
    {
        if(m_cityMutableArray.count)
        {
            /*
            aCityEntity = [m_cityMutableArray objectAtIndex:row];

            NSString *cityCode = aCityEntity.code;
            NSDictionary *codeDic = [NSDictionary dictionaryWithObject:cityCode forKey:@"cityCode"];
            NSArray *areaArr = [[BusinessManager sharedManager].cityManager cityWithCityType:nil superCityCodeDic:codeDic];
             */
            
            NSString *regionValue = [[m_cityMutableArray objectAtIndex:row] description];
            

            NSArray *areaArr = [self updateAreaByCity: regionValue];
            
            
            if(areaArr.count)
            {
                [self setAreaMutableArray:[NSMutableArray arrayWithArray:areaArr]];
            }
            else
            {
                [m_areaMutableArray removeAllObjects];
            }
            
            /*
            self.city = aCityEntity.name;
            */
            self.city = regionValue;
            
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadAllComponents];
        }

    }
    else
    {
        if(m_areaMutableArray.count)
            /*
            self.area = [[m_areaMutableArray objectAtIndex:row] name];
             */
            self.area = [[m_areaMutableArray objectAtIndex:row] description];
    }
    
    /*
    self.province = [[m_provinceMutableArray objectAtIndex:[pickerView selectedRowInComponent:0]] name];
    */
    self.province = [[m_provinceMutableArray objectAtIndex:[pickerView selectedRowInComponent:0]] description];
}




@end
