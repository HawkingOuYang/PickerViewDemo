//
//  MacroUtility.h
//  PickerViewDemo
//
//  Created by OYXJ on 16/2/14.
//  Copyright © 2016年 OYXJ. All rights reserved.
//

#ifndef MacroUtility_h
#define MacroUtility_h


#define kIOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define kAboveIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define kAboveIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define kAboveIOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)


#define isScreen4Inch ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#endif /* MacroUtility_h */
