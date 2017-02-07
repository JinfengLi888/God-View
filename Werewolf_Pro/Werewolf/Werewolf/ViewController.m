//
//  ViewController.m
//  Werewolf Home Page
//
//  Created by Jean on 11/12/16.
//  Copyright © 2016 jinfeng. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import "UIView+ext.h"
#import "WWDefines.h"
#import "WWButton.h"
#import "WWEveningViewController.h"
#import "WWSettingViewController.h"
#import "WWDealCardViewController.h"
#import <GoogleMobileAds/GADBannerView.h>

#define Stepper_Cunmin    66
#define Stepper_lang      77
#define Stepper_yuyanjia  88

#define LabelCount_Cunmin   33
#define LabelCount_lang     44
#define LabelCount_Yuyanjia 55

#define Label_X 20

#define DeepBuleColor RGBAColor(0, 150, 255, 1)
#define ButtonDisableColor RGBAColor(179, 179, 179 , 1)
#define TextColor [UIColor whiteColor]
#define EnableColor RGBAColor(33, 142, 208, 1)
#define DisableColor [UIColor grayColor]
#define LabelFontSize_1 17
#define LabelFontSize_2 20

#define ShenButtonTag 666
#define StartButtonTag 888

#define ShenLabel_Width (IS_IPHONE_5?80:100)
#define ShenLabel_length 50

#define WolfLabel_Width (IS_IPHONE_5?100:120)
#define LabelGap (IS_IPHONE_5?20:40)


@interface ViewController ()<WWDealCardProtocol>

@property (nonatomic, strong) NSArray *shenArray;
@property (nonatomic, strong) NSMutableArray *enableArray;
@property (nonatomic, strong) UILabel *playersLabel;

@property (nonatomic, strong) GADBannerView *bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.shenArray = @[@"女巫",@"猎人",@"白痴",@"守卫",@"丘比特",@"盗贼",@"白狼王",@"狼美人"];
    self.shenArray = @[@"先知",@"女巫",@"猎人",@"白痴"];
    self.enableArray = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"0",@"0",@"0",@"0", nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImg"]];
    self.title = @"狼人杀";
    
    CGFloat playerLabel_Y = IS_IPHONE_5 ? 70 : 90;
    self.playersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, playerLabel_Y, SCREEN_WIDTH, 50)];
    self.playersLabel.text = @"游戏人数 12 人";
    self.playersLabel.font = [UIFont systemFontOfSize:25];
    self.playersLabel.textColor = EnableColor;
    self.playersLabel.backgroundColor = [UIColor clearColor];
    self.playersLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.playersLabel];
    
    // 设置狼人
    CGRect rect = CGRectMake(Label_X, self.playersLabel.bottom+(IS_IPHONE_5 ? 20 : 40), WolfLabel_Width, 40);
    UILabel *langren = [[UILabel alloc] initWithFrame:rect];
    langren.backgroundColor = EnableColor;
    langren.textColor = TextColor;
    langren.font = [UIFont systemFontOfSize:LabelFontSize_1];
    langren.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:langren];
    
    // 设置字间距
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc]initWithString:@"狼人数量"];
    long number = 5.0f;//间距
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
    CFRelease(num);
    [langren setAttributedText:attributedString];
    
    // 设置村民
    UILabel *cunmin = [[UILabel alloc] initWithFrame:rect];
    cunmin.y = langren.bottom + 20;
    cunmin.backgroundColor = EnableColor;
    cunmin.textColor = TextColor;
    cunmin.font = [UIFont systemFontOfSize:LabelFontSize_1];
    cunmin.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:cunmin];
    
    attributedString =[[NSMutableAttributedString alloc]initWithString:@"村民数量"];
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
    CFRelease(num);
    [cunmin setAttributedText:attributedString];
    
    // 设置预言家
//    UILabel *yuyanjia = [[UILabel alloc] initWithFrame:rect];
//    yuyanjia.y = langren.bottom + 20;
//    yuyanjia.backgroundColor = EnableColor;
//    yuyanjia.textColor = TextColor;
//    yuyanjia.font = [UIFont systemFontOfSize:LabelFontSize_1];
//    yuyanjia.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:yuyanjia];
    
//    attributedString =[[NSMutableAttributedString alloc]initWithString:@"预言家数量"];
//    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
//    CFRelease(num);
//    [yuyanjia setAttributedText:attributedString];

    // 狼人人数
    CGRect rect_num = CGRectMake(langren.right + LabelGap, langren.y, 40, 40);
    UILabel *langCount = [[UILabel alloc] initWithFrame:rect_num];
    langCount.y = langren.y;
    langCount.backgroundColor = EnableColor;
    langCount.textColor = TextColor;
    langCount.font = [UIFont systemFontOfSize:LabelFontSize_1];
    langCount.textAlignment = NSTextAlignmentCenter;
    langCount.text = @"4";
    langCount.tag = LabelCount_lang;
    [self.view addSubview:langCount];
    
    // 村民人数
    UILabel *cunminCount = [[UILabel alloc] initWithFrame:rect_num];
    cunminCount.y = cunmin.y;
    cunminCount.backgroundColor = EnableColor;
    cunminCount.font = [UIFont systemFontOfSize:LabelFontSize_1];
    cunminCount.textColor = TextColor;
    cunminCount.textAlignment = NSTextAlignmentCenter;
    cunminCount.text = @"4";
    cunminCount.tag = LabelCount_Cunmin;
    [self.view addSubview:cunminCount];
    
    
    
    // 预言家人数
//    UILabel *yuyanjiaCount = [[UILabel alloc] initWithFrame:rect_num];
//    yuyanjiaCount.y = yuyanjia.y;
//    yuyanjiaCount.backgroundColor = EnableColor;
//    yuyanjiaCount.textColor = TextColor;
//    yuyanjiaCount.font = [UIFont systemFontOfSize:LabelFontSize_1];
//    yuyanjiaCount.textAlignment = NSTextAlignmentCenter;
//    yuyanjiaCount.text = @"1";
//    yuyanjiaCount.tag = LabelCount_Yuyanjia;
//    [self.view addSubview:yuyanjiaCount];
    
    // 狼人 设置加减数量按钮
    UIStepper *stepper_lang = [[UIStepper alloc] init];
    stepper_lang.tag = Stepper_lang;
    stepper_lang.x = langCount.right + LabelGap;
    stepper_lang.y = langren.y;
    stepper_lang.value = 4;
    [stepper_lang setMinimumValue:1];
    [stepper_lang setMaximumValue:5];
    [stepper_lang addTarget:self action:@selector(stepperValueChagned:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:stepper_lang];
    
    // 村民 设置加减数量按钮
    UIStepper *stepper_cunmin = [[UIStepper alloc] init];
    stepper_cunmin.tag = Stepper_Cunmin;
    stepper_cunmin.x = cunminCount.right + LabelGap;
    stepper_cunmin.y = cunmin.y;
    stepper_cunmin.value = 4;
    [stepper_cunmin setMinimumValue:1];
    [stepper_cunmin setMaximumValue:5];
    [stepper_cunmin addTarget:self action:@selector(stepperValueChagned:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:stepper_cunmin];
    
    
    
    // 预言家 设置加减数量按钮
//    UIStepper *stepper_yuyanjia = [[UIStepper alloc] init];
//    stepper_yuyanjia.tag = Stepper_yuyanjia;
//    stepper_yuyanjia.x = yuyanjiaCount.right + LabelGap;
//    stepper_yuyanjia.y = yuyanjiaCount.y;
//    stepper_yuyanjia.value = 1;
//    stepper_yuyanjia.enabled = NO;
//    [stepper_yuyanjia addTarget:self action:@selector(stepperValueChagned:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:stepper_yuyanjia];
    
    // 启用以下强神
    for (int i=0; i<self.shenArray.count; i++)
    {
        float x = i % 3;
        float y = i / 3;
        
        CGRect rect_shen = CGRectMake(Label_X + ShenLabel_Width*x + Label_X*x, cunmin.bottom + 50 + ShenLabel_length*y + Label_X*y, ShenLabel_Width, ShenLabel_length);
        WWButton *shenButton = [[WWButton alloc] initWithFrame:rect_shen];
        shenButton.tag = ShenButtonTag + i;
        [shenButton setTitle:self.shenArray[i] forState:UIControlStateNormal];
        shenButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [shenButton addTarget:self action:@selector(buttonTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        attributedString =[[NSMutableAttributedString alloc]initWithString:self.shenArray[i]];
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
        CFRelease(num);
        [shenButton.titleLabel setAttributedText:attributedString];
        
        [self.view addSubview:shenButton];
        
        if ([self.enableArray[i] isEqualToString:@"0"])
            shenButton.backgroundColor = DisableColor;
        else
            shenButton.backgroundColor = EnableColor;
    }
    
    // 开始游戏
    CGFloat marginY = IS_IPHONE_5?30:50;
    WWButton *lastShenButton = (WWButton *)[self.view viewWithTag:(ShenButtonTag + self.shenArray.count-1)];
    WWButton *startButton = [[WWButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-ShenLabel_Width)/2., lastShenButton.bottom + marginY, ShenLabel_Width, ShenLabel_length)];
    [startButton addTarget:self action:@selector(startButtonTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    NSString *titleName = IS_IPHONE_5?@"开始":@"开始游戏";
    [startButton setTitle:titleName forState:UIControlStateNormal];
    startButton.backgroundColor = RGBAColor(175, 201, 1, 1);
    [self.view addSubview:startButton];
    
    // 设置左上角设置按钮
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftButton addTarget:self action:@selector(settingButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"settingImg"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // 插入广告
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = @"ca-app-pub-4804139594779676/4185184347";
    self.bannerView.rootViewController = self;
    self.bannerView.center = self.view.center;
    self.bannerView.y = SCREEN_HEIGHT - 50;
//    [self.view addSubview:self.bannerView];  打开该行代码，加入广告
    
    GADRequest *request = [[GADRequest alloc] init];
    request.testDevices = @[@"ad12a2dcb8babdc6380982db08f79f03"];
    [self.bannerView loadRequest:request];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:Purchased])
    {
        [self.bannerView removeFromSuperview];
    }
}

#pragma mark -
#pragma mark Setting Button Event

-(void)settingButtonEvent
{
    WWSettingViewController *setting = [[WWSettingViewController alloc] init];
    UINavigationController *navSetting = [[UINavigationController alloc] initWithRootViewController:setting];
    [self.navigationController presentViewController:navSetting animated:YES completion:nil];
}

#pragma mark -
#pragma mark God method -

-(void)buttonTouchEvent:(UIButton *)button
{
    NSInteger tag = button.tag - ShenButtonTag;
    if (tag == 0)
    {
        // 预言家不能为空
        return;
    }
    NSString *enableString = self.enableArray[tag];
    if ([enableString isEqualToString:@"0"])
    {
        self.enableArray[tag] = @"1";
        button.backgroundColor = EnableColor;
    }
    else
    {
        self.enableArray[tag] = @"0";
        button.backgroundColor = DisableColor;
    }
    
    self.playersLabel.text = [NSString stringWithFormat:@"游戏人数 %ld 人",[self getPopulation]];
}

#pragma mark -
#pragma mark Start Button Touch Event

-(void)startButtonTouchEvent:(UIButton *)button
{
    NSArray *dataArray = [self getActors];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:DealCardMode])
    {
        //   ----------- 发牌模式 ------------
        WWDealCardViewController *dealCard = [[WWDealCardViewController alloc] init];
        dealCard.delegate = self;
        dealCard.wolfCount = [dataArray[0] integerValue];
        dealCard.villagerCount = [dataArray[1] integerValue];
        dealCard.godArray = dataArray[2];
        [self.navigationController presentViewController:dealCard animated:YES completion:nil];
    }
    else
    {
        WWEveningViewController *evening = [[WWEveningViewController alloc] init];
        evening.wolfCount = [dataArray[0] integerValue];
        evening.villagerCount = [dataArray[1] integerValue];
        evening.godArray = dataArray[2];
        [self.navigationController pushViewController:evening animated:YES];
    }
}

#pragma mark -
#pragma mark Stepper method -

-(void)stepperValueChagned:(UIStepper *)sender
{
    int value = [sender value];
    switch (sender.tag) {
        case Stepper_Cunmin:
        {
            UILabel *label = (UILabel *)[self.view viewWithTag:LabelCount_Cunmin];
            label.text = [NSString stringWithFormat:@"%d",value];
        }
            break;
        case Stepper_lang:
        {
            UILabel *label = (UILabel *)[self.view viewWithTag:LabelCount_lang];
            label.text = [NSString stringWithFormat:@"%d",value];
        }
            break;
        case Stepper_yuyanjia:
        {
            UILabel *label = (UILabel *)[self.view viewWithTag:LabelCount_Yuyanjia];
            label.text = [NSString stringWithFormat:@"%d",value];
        }
            break;
        default:
            break;
    }
    
    self.playersLabel.text = [NSString stringWithFormat:@"游戏人数 %ld 人",[self getPopulation]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Deal Card Protocol

-(void)judgeEvent:(NSArray *)array
{
    NSArray *dataArray = [self getActors];
    WWEveningViewController *evening = [[WWEveningViewController alloc] init];
    evening.dealedDataArray = array;
    evening.wolfCount = [dataArray[0] integerValue];
    evening.villagerCount = [dataArray[1] integerValue];;
    evening.godArray = dataArray[2];
    [self.navigationController pushViewController:evening animated:YES];
}

#pragma mark - get configuration return array
#pragma mark @[狼人数量，村民数量，神数组]

-(NSArray *)getActors
{
    UILabel *label_1 = (UILabel *)[self.view viewWithTag:LabelCount_lang];
    UILabel *label_2 = (UILabel *)[self.view viewWithTag:LabelCount_Cunmin];
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (int i=0; i<self.enableArray.count; i++)
    {
        if ([self.enableArray[i] isEqualToString:@"1"])
        {
            [dataArray addObject:self.shenArray[i]];
        }
    }
    
    NSArray *array = [NSArray arrayWithObjects:label_1.text,label_2.text,dataArray, nil];
    return array;
}

#pragma mark - get population
#pragma mark 获取游戏人数

-(NSInteger)getPopulation
{
    NSArray *dataArray = [self getActors];
    NSInteger wolfCount = [dataArray[0] integerValue];
    NSInteger villagerCount = [dataArray[1] integerValue];
    NSArray *godArray = dataArray[2];
    return wolfCount + villagerCount + godArray.count;
}

@end
