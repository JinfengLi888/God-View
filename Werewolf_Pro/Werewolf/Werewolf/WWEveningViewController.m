//
//  WWEveningViewController.m
//  Werewolf
//
//  Created by Jean on 11/26/16.
//  Copyright © 2016 jinfeng. All rights reserved.
//

#import "WWEveningViewController.h"
#import "WWDefines.h"
#import "UIView+ext.h"
#import "WWNumLabel.h"
#import "WWNightMurder.h"
#import "ViewController.h"
#import <GoogleMobileAds/GADBannerView.h>

#define Gap_Height (IS_IPHONE_5?(MainContentHeight/7.):(MainContentHeight/6.))
#define TextColor [UIColor whiteColor]

#define LabelFontSize 17

#define Label_Width 50
#define Label_Height 40

#define Num_Width 40
#define Num_Marigh 20
#define Num_Tag 666

#define Wolf_Label_Tag 100
#define Villager_Label_Tag 200
#define Gods_Label_Tag 300


@interface WWEveningViewController ()<WWNumLabelDelegate,UINavigationControllerDelegate>

@property (nonatomic) NSInteger totalPeople;  // 总人数
@property (nonatomic, strong) NSMutableArray *godsFrameArray; // 存放神的Frame的数组
@property (nonatomic) CGRect wolfFrame; // 狼区域的Frame
@property (nonatomic) CGRect villagerFrame; // 村民区域的Frame

// 初始号码组的原始Frame数组
@property (nonatomic, strong) NSMutableArray *originNumFrameArray;

// 存放狼人号码的数组
@property (nonatomic, strong) NSMutableArray *wolfArray;
// 存放狼坑的数组
@property (nonatomic, strong) NSMutableArray *wolfFrameArray;
// 存放神的号码的数组
@property (nonatomic, strong) NSMutableArray *godsNumArray;

// 存放平民坑的数组
@property (nonatomic, strong) NSMutableArray *villagerFrameArray;
// 神的总Frame 用于判断拖动数字时是否在神的区域里
@property (nonatomic) CGRect godsFrame;

// 尚未安置身份的号码组
@property (nonatomic, strong) NSMutableArray *numsArray;

// 记录该号码对应的Frame key:号码所属的label的Tag  value:Frame
@property (nonatomic, strong) NSMutableDictionary *numFrameDict;

// 记录当天的生死情况
@property (nonatomic, strong) WWNightMurder *nightMurder;

// 存放WWNightMurder的数组，有几个值，就证明到了第几天
@property (nonatomic, strong) NSMutableArray *daysArray;

// 记录死亡玩家的数组
@property (nonatomic, strong) NSMutableArray *deadArray;

// 广告
@property (nonatomic, strong) GADBannerView *bannerView;

@end

@implementation WWEveningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImg"]];
    self.totalPeople = self.wolfCount + self.villagerCount + self.prophetCount + self.godArray.count;
    self.godsFrameArray = [NSMutableArray array];
    self.originNumFrameArray = [NSMutableArray array];
    self.wolfArray = [NSMutableArray array];
    self.wolfFrameArray = [NSMutableArray array];
    self.villagerFrameArray = [NSMutableArray array];
    self.numsArray = [NSMutableArray array];
    self.numFrameDict = [NSMutableDictionary dictionary];
    self.godsNumArray = [NSMutableArray array];
    self.daysArray = [NSMutableArray array];
    self.deadArray = [NSMutableArray array];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.delegate = self;
    // 初始化 NightMurder 值
    [self createNextDay];
    self.nightMurder.step = 1;

    // 狼
    UIView *gapLine = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + Gap_Height, SCREEN_WIDTH, 1)];
    gapLine.backgroundColor = EnableColor;
    [self.view addSubview:gapLine];
    self.wolfFrame = CGRectMake(0, 64, SCREEN_WIDTH, Gap_Height);
    
    // 设置分割线
    int k = 2;
    if (self.godArray.count > 2) k = 3;
    for (int i=1; i<=k; i++)
    {
        // 横线
        UIView *gap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        gap.backgroundColor = EnableColor;
        gap.y = 64 + Gap_Height + i*Gap_Height;
        [self.view addSubview:gap];
    }
    
    for (int i=1; i<=k-1; i++)
    {
        // 竖线
        UIView *gap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, Gap_Height)];
        gap.backgroundColor = EnableColor;
        gap.x = SCREEN_WIDTH/2.;
        if (i == k-1 && self.godArray.count%2 == 1)
            break;
        else
            gap.y = 64 + i * Gap_Height;
        [self.view addSubview:gap];
    }
    
    // 计算神Label的Frame
    for (int i=0; i<self.godArray.count; i++)
    {
        int x = i % 2;
        int y = i / 2;
        CGFloat width = 0;
        if (i == self.godArray.count-1 && i%2==0)
            width = SCREEN_WIDTH;
        else
            width = SCREEN_WIDTH/2.;
        
        CGRect rect = CGRectMake(x*SCREEN_WIDTH/2.,64 + (y+1)*Gap_Height, width, Gap_Height);
        [self.godsFrameArray addObject:NSStringFromCGRect(rect)];
    
        UILabel *wolfLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x + 10,rect.origin.y+(Gap_Height-Label_Height)/2., Label_Width, Label_Height)];
        wolfLabel.backgroundColor = EnableColor;
        wolfLabel.textColor = TextColor;
        wolfLabel.text = self.godArray[i];
        wolfLabel.tag = Gods_Label_Tag + i;
        wolfLabel.font = [UIFont systemFontOfSize:LabelFontSize];
        wolfLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:wolfLabel];
    }
    
    // 设置Label 狼
    UILabel *wolfLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+ (Gap_Height-Label_Height)/2., Label_Width, Label_Height)];
    wolfLabel.backgroundColor = EnableColor;
    wolfLabel.textColor = TextColor;
    wolfLabel.text = @"狼人";
    wolfLabel.tag = Wolf_Label_Tag;
    wolfLabel.font = [UIFont systemFontOfSize:LabelFontSize];
    wolfLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:wolfLabel];
    
    // 设置Label 平民
    self.villagerFrame = CGRectMake(0, (self.godsFrameArray.count>2 ? 3 : 2)*Gap_Height + 64, SCREEN_WIDTH, Gap_Height);
    UILabel *villgerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.villagerFrame.origin.y + (Gap_Height-Label_Height)/2., Label_Width, Label_Height)];
    villgerLabel.backgroundColor = EnableColor;
    villgerLabel.textColor = TextColor;
    villgerLabel.text = @"平民";
    villgerLabel.tag = Villager_Label_Tag;
    villgerLabel.font = [UIFont systemFontOfSize:LabelFontSize];
    villgerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:villgerLabel];
    
    
    // 设置广告
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = @"ca-app-pub-4804139594779676/4185184347";
    self.bannerView.rootViewController = self;
    self.bannerView.center = self.view.center;
    self.bannerView.y = SCREEN_HEIGHT - 50;
//    [self.view addSubview:self.bannerView];  打开该行代码，加入广告
    GADRequest *request = [[GADRequest alloc] init];
    request.testDevices = @[@"ad12a2dcb8babdc6380982db08f79f03"];
    [self.bannerView loadRequest:request];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault boolForKey:DealCardMode])
        self.bannerView.alpha = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 计算狼坑的frame
    UILabel *wolfLabel = (UILabel *)[self.view viewWithTag:Wolf_Label_Tag];
    for (int i=0; i<self.wolfCount; i++)
    {
        float x = wolfLabel.right + 20 + i * Num_Width + i * 20;
        float y = wolfLabel.y;
        CGRect rect = CGRectMake(x, y, Num_Width, Num_Width);
        [self.wolfFrameArray addObject:NSStringFromCGRect(rect)];
    }
    
    // 计算平民坑的frame
    UILabel *villagerLabel = (UILabel *)[self.view viewWithTag:Villager_Label_Tag];
    for (int i=0; i<self.villagerCount; i++)
    {
        float x = villagerLabel.right + 20 + i * Num_Width + i * 20;
        float y = villagerLabel.y;
        CGRect rect = CGRectMake(x, y, Num_Width, Num_Width);
        [self.villagerFrameArray addObject:NSStringFromCGRect(rect)];
    }
    
    // 计算神牌们的总的Frame
    self.godsFrame = CGRectMake(0, self.wolfFrame.origin.y+Gap_Height, SCREEN_WIDTH, self.godArray.count>2?Gap_Height*2:Gap_Height);
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:DealCardMode])
    {
        int villIndex = 0;
        int wolfIndex = 0;
        for (int i=0; i<self.dealedDataArray.count; i++)
        {
            WWNumLabel *label = [[WWNumLabel alloc] initWithFrame:CGRectZero];
            label.delegate = self;
            label.backgroundColor = EnableColor;
            label.textColor = TextColor;
            label.canDrag = NO;
            label.tag = Num_Tag + i;
            label.text = [NSString stringWithFormat:@"%d",i+1];
            label.font = [UIFont systemFontOfSize:LabelFontSize];
            label.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:label];
            NSString *name = self.dealedDataArray[i];
            if ([name isEqualToString:@"村民"])
            {
                label.frame = CGRectFromString(self.villagerFrameArray[villIndex]);
                villIndex ++;
            }
            else if([name isEqualToString:@"狼人"])
            {
                label.frame = CGRectFromString(self.wolfFrameArray[wolfIndex]);
                wolfIndex ++;
            }
            
            // godArray中没有存放预言家
            NSMutableArray *gods = [NSMutableArray arrayWithArray:self.godArray];
//            [gods insertObject:@"预言家" atIndex:0];
            for (int j=0; j < gods.count; j++)
            {
                if ([name isEqualToString:gods[j]])
                {
                    CGRect godLabelrect = CGRectFromString(self.godsFrameArray[j]);
                    UILabel *godLabel = (UILabel *)[self.view viewWithTag:Gods_Label_Tag + j];
                    float x = godLabel.right + 20;
                    float y = (Gap_Height-Label_Height)/2. + godLabelrect.origin.y;
                    CGRect rect = CGRectMake(x, y, Num_Width, Num_Width);
                    
                    label.frame = rect;
                }
            }
        }
    }
    else
    {
        int x = 0;
        int y = 0;
        // iPhone 4/5 一行放5个数，iphone6及以上 一行放6个数
        CGFloat counts = IS_IPHONE_5|| IS_IPHONE_4 ? 5 : 6;
        for (int i=0; i<self.totalPeople; i++)
        {
            if(i<counts)
            {
                x = i;
                y = 0;
            }
            else if(i>=counts && i<counts*2)
            {
                x = i - counts;
                y = 1;
            }
            else if(i>=counts*2)
            {
                x = i - counts*2;
                y = 2;
            }
            
            CGRect rect = CGRectMake(Num_Marigh + x*Num_Width + Num_Marigh * x, Num_Marigh + Num_Marigh*y + self.villagerFrame.origin.y + Gap_Height + Num_Width*y, Num_Width, Num_Width);
            [self.originNumFrameArray addObject:NSStringFromCGRect(rect)];
            WWNumLabel *label = [[WWNumLabel alloc] initWithFrame:rect];
            label.delegate = self;
            label.backgroundColor = EnableColor;
            label.textColor = TextColor;
            label.canDrag = YES;
            label.tag = Num_Tag + i;
            label.text = [NSString stringWithFormat:@"%d",i+1];
            label.font = [UIFont systemFontOfSize:LabelFontSize];
            label.textAlignment = NSTextAlignmentCenter;
            [UIView animateWithDuration:.1 animations:^{
                [self.view addSubview:label];
            }];
            [self.numsArray addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
//    [self showInfoLabelEvent];
    
    // 如果购买则删除广告
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:Purchased])
    {
        [self.bannerView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark WWNumLabel Delegate Method -

-(void)touchesEndedPoint:(NSString *)point withTag:(NSString *)tag
{
    BOOL flag = YES; // 是否将该号码放回原位
    CGPoint currentPoint = CGPointFromString(point);
    NSInteger index = [tag integerValue] - Num_Tag;
    WWNumLabel *label = (WWNumLabel *)[self.view viewWithTag:[tag integerValue]];
    // 手指拖动的号码
    NSString *drag_num = [NSString stringWithFormat:@"%ld",index+1];
    if (CGRectContainsPoint(self.wolfFrame, currentPoint) && self.wolfArray.count < self.wolfCount)
    {
        // 将该号码放进狼坑
        flag = NO;
        [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            for (int i=0; i<self.wolfFrameArray.count; i++)
            {
                NSString *rectString = self.wolfFrameArray[i];
                if (![self.numFrameDict.allValues containsObject:rectString])
                {
                    label.frame = CGRectFromString(self.wolfFrameArray[i]);
                    [self.numFrameDict setObject:self.wolfFrameArray[i] forKey:tag];
                    break;
                }
            }
            
        } completion:nil];
        [self.wolfArray addObject:drag_num];
        [self.numsArray removeObject:drag_num];
        
        // 所有狼坑都以放置完毕 按照顺序排列一下
    }
    else if(CGRectContainsPoint(self.godsFrame, currentPoint))
    {
        flag = NO;
        for (int i=0; i<self.godArray.count; i++)
        {
            if (CGRectContainsPoint(CGRectFromString(self.godsFrameArray[i]), currentPoint))
            {
                CGRect godLabelrect = CGRectFromString(self.godsFrameArray[i]);
                UILabel *godLabel = (UILabel *)[self.view viewWithTag:Gods_Label_Tag + i];
                float x = godLabel.right + 20;
                float y = (Gap_Height-Label_Height)/2. + godLabelrect.origin.y;
                CGRect rect = CGRectMake(x, y, Num_Width, Num_Width);
                if ([self.numFrameDict.allValues containsObject:NSStringFromCGRect(rect)])
                {
                    // 如果有被记录过，说明这个地方已经有放置的号码了，那么将其房会远处
                    flag = YES;
                    break;
                }
                [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    label.frame = rect;
                    [self.numFrameDict setObject:NSStringFromCGRect(rect) forKey:tag];
                } completion:^(BOOL finished) {
                }];
                [self.godsNumArray addObject:drag_num];
                // 如果是从狼坑里拖过来的，那么狼坑的人数减一
                if ([self.wolfArray containsObject:drag_num])
                {
                    [self.wolfArray removeObject:drag_num];
                    
                    // 根据号码计算Tag
                    NSInteger tag_i = [drag_num integerValue] - 1 + Num_Tag;
                    NSString *strTag = [NSString stringWithFormat:@"%ld",tag_i];
                    if ([[self.numFrameDict allKeys] containsObject:strTag])
                    {
                        [self.numFrameDict removeObjectForKey:strTag];
                    }
                }
                else
                {
                    [self.numsArray removeObject:drag_num];
                }
                break;
            }
        }
    }
    if(flag)
    {
        // 放回原位
        [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.frame = CGRectFromString(self.originNumFrameArray[index]);
            [self.numFrameDict setObject:self.originNumFrameArray[index] forKey:tag];
        } completion:^(BOOL finished) {
        }];
        
        // 如果是从狼坑/神坑里拖过来的，那么狼坑/神坑的人数减一
        BOOL isFromWolf = [self.wolfArray containsObject:drag_num];
        BOOL isFromGods = [self.godsNumArray containsObject:drag_num];
        if (isFromWolf || isFromGods)
        {
            if (isFromWolf) [self.wolfArray removeObject:drag_num];
            if (isFromGods) [self.godsNumArray removeObject:drag_num];
            [self.numsArray addObject:drag_num];
            
            // 根据号码计算Tag
            NSInteger tag_i = [drag_num integerValue] - 1 + Num_Tag;
            NSString *strTag = [NSString stringWithFormat:@"%ld",tag_i];
            if ([[self.numFrameDict allKeys] containsObject:strTag])
            {
                [self.numFrameDict removeObjectForKey:strTag];
            }
        }
    }
    
//    NSLog(@"+++++++++11+++++++++:%ld..%ld",self.numsArray.count,self.villagerCount);
    // 所有有身份牌都放置好后，自动放置平民的身份牌
    if(self.numsArray.count == self.villagerCount)
    {
        [UIView animateWithDuration:.5 animations:^{
            if (self.bannerView)
                self.bannerView.alpha = 1;
        }];
        
        for (int i=0; i<self.villagerCount; i++)
        {
            UILabel *label = (UILabel *)[self.view viewWithTag:[self.numsArray[i] integerValue] + Num_Tag - 1];
            [UIView animateWithDuration:.45 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                label.frame = CGRectFromString(self.villagerFrameArray[i]);
                [self.numFrameDict setObject:self.villagerFrameArray[i] forKey:tag];
            } completion:^(BOOL finished) {
                [self.numsArray removeObject:drag_num];
            }];
        }
        // 号码摆放完毕 do thing （禁止拖动）
        for (int i=0; i<self.totalPeople; i++)
        {
            WWNumLabel *label = (WWNumLabel *)[self.view viewWithTag:Num_Tag + i];
            label.canDrag = NO;
        }
    }
}

#pragma mark 点击号码事件

-(void)touchUpInsideEventWithTag:(NSString *)tag
{
    NSInteger index = [tag integerValue] - Num_Tag;
    NSString *num = [NSString stringWithFormat:@"%ld",index+1];
    WWNumLabel *label = (WWNumLabel *)[self.view viewWithTag:[tag integerValue]];
    NSLog(@"点击号码:%@",num);
    
    if ([self.deadArray containsObject:num])
    {
        NSString *title = [NSString stringWithFormat:@"确定复活%@号玩家?",num];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            for (UIView *view in label.subviews)
            {
                [view removeFromSuperview];
                [self.deadArray removeObject:num];
            }
        }];

        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIImageView *biteImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, label.width, label.height)];
        biteImgView.image = [UIImage imageNamed:@"dieDayImg"];
        
        [label addSubview:biteImgView];
        biteImgView.alpha = 0;
        [UIView animateWithDuration:.25 animations:^{
            biteImgView.alpha = 1;
        }];
        [self.deadArray addObject:num];
    }
//    [self handleKilledPeopleWithNum:num];
}

#pragma mark -
#pragma mark 处理死亡角色

-(void)handleKilledPeopleWithNum:(NSString *)num
{
    switch (self.nightMurder.step++) {
        case 1:
        {
            self.nightMurder.wolfKill = num;
        }
            break;
            
        default:
            break;
    }
    
    [self showInfoLabelEvent];
}

#pragma mark -
#pragma mark UILabel Scale Animation

-(void)labelScaleAnimation:(UILabel *)label
{
    label.alpha = 0;
    label.transform = CGAffineTransformMakeScale(0.9,0.9);
    [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        label.alpha = 1;
        label.transform = CGAffineTransformMakeScale(1.05,1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

#pragma mark -
#pragma mark Create a new WWNightMurder

-(void)createNextDay
{
    self.nightMurder = [[WWNightMurder alloc] init];
}

#pragma mark -
#pragma mark Get Tag by using Number

-(NSString *)getTagWithNumber:(NSString *)num
{
    NSInteger tag = [num integerValue] - 1 + Num_Tag;
    return [NSString stringWithFormat:@"%ld",tag];
}

#pragma mark -
#pragma mark Show the reminder label Event

-(void)showInfoLabelEvent
{
    NSString *tag = [self getTagWithNumber:[NSString stringWithFormat:@"%ld",self.totalPeople]];
    UILabel *label = (UILabel *)[self.view viewWithTag:[tag integerValue]];
                      
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, label.bottom + Num_Marigh, SCREEN_WIDTH, 30)];
    infoLabel.text = [self.nightMurder getStepString];
    infoLabel.textColor = [UIColor redColor];
    infoLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:infoLabel];
    [self labelScaleAnimation:infoLabel];
}

#pragma mark -
#pragma mark UINavigationController Delegate Method

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if ([viewController isKindOfClass:[ViewController class]])
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定重新开始吗?"
//                                                                                 message:@""
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            return ;
//        }];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
}

@end
