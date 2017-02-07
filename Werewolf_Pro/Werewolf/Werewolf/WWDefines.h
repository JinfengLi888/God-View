//
//
//  Created by Jackie Lee on 14-4-26.
//  Copyright (c) 2014年 Smartisan. All rights reserved.
//

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define KAppVersion [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"] //***modify by strong 20140519
#define KeyWindow [UIApplication sharedApplication].keyWindow
#define system_version [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IOS_6 ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0)
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0 && [[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
#define IS_IOS_8 ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0 && [[[UIDevice currentDevice] systemVersion] floatValue]<9.0)

#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6P ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )

#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define HexColor(hexColor) [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1]

//适配IPhone UI X偏移

#define ADOPT_UI_XOFF ((SCREEN_WIDTH-320)/2)
#define ADOPT_UI_RIGHT_XOFF(x) (SCREEN_WIDTH-(320-x))
#define ADOPT_UI_YOFF ((SCREEN_HEIGHT-480)/2)

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define MainContentHeight      (SCREEN_HEIGHT - 20 - 44)

#define EnableColor RGBAColor(33, 142, 208, 1)

#define NightCell_Height 80

#define AppStoreURL @"https://itunes.apple.com/us/app/god-view/id1190935100?l=zh&ls=1&mt=8"
//https://itunes.apple.com/cn/app/chui-zi-shi-zhong/id828812911?mt=8
#define AppName @"上帝视角"

// 是否为发牌模式，存储在nsuserdefault中值
#define DealCardMode @"DealCardMode"
#define Purchased @"PurchasedRemovedAd"

#define Werewolf_Version @"1.0"

#define Product_ID @"onedollartoremovead"
