//
//  WWDealCardViewController.m
//  Werewolf
//
//  Created by Jean on 12/6/16.
//  Copyright © 2016 jinfeng. All rights reserved.
//

#import "WWDealCardViewController.h"
#import "WWDefines.h"
#import "UIView+ext.h"
#import "QBFlatButton.h"


#define ButtonWidth 120
#define ButtonHeight 60
#define ButtonGap    50
#define TextLabelHeight 30
#define CardViewWidth 250

@interface WWDealCardViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIImageView *defaultCardView;

@property (nonatomic, assign) BOOL isBack;

// 标识几号玩家
@property (nonatomic, assign) NSInteger index;
// 表示身份的label
@property (nonatomic, strong) UILabel *textLabel;
// 表示几号玩家的label
@property (nonatomic, strong) UILabel *titleLabel;


@property (nonatomic, strong) QBFlatButton *checkCard;
@property (nonatomic, strong) QBFlatButton *disCard;

@end

@implementation WWDealCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImg"]];

    self.isBack = YES;
    self.index = 0;
    self.dataArray = [NSMutableArray array];
    for (int i=0; i<self.villagerCount; i++)
    {
        [self.dataArray addObject:@"村民"];
    }
    for (int i=0; i<self.wolfCount; i++)
    {
        [self.dataArray addObject:@"狼人"];
    }
//    for (int i=0; i<self.prophetCount; i++)
//    {
//        [self.dataArray addObject:@"预言家"];
//    }
    for (int i=0; i<self.godArray.count; i++)
    {
        [self.dataArray addObject:self.godArray[i]];
    }
    NSMutableArray *newArray = [NSMutableArray array];
    NSInteger max = self.dataArray.count;
    for (NSInteger i=0; i<max; i++)
    {
        NSInteger x = arc4random() % self.dataArray.count;
        NSString *name = self.dataArray[x];
        [newArray addObject:name];
        [self.dataArray removeObjectAtIndex:x];
    }
    // 洗牌后的数组
    self.dataArray = newArray;
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 50, 26, 26)];
    [closeButton setImage:[UIImage imageNamed:@"closeImg"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dissMissEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    NSLog(@"洗牌后的数组：%@",self.dataArray);
    
    self.defaultCardView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CardViewWidth, CardViewWidth)];
    self.defaultCardView.image = [UIImage imageNamed:@"card_bg"];
    self.defaultCardView.center = self.view.center;
    self.defaultCardView.layer.cornerRadius = 5;
    self.defaultCardView.layer.shadowOffset =  CGSizeMake(1, 1);
    self.defaultCardView.layer.shadowOpacity = 0.8;
    self.defaultCardView.layer.shadowColor =  [UIColor blackColor].CGColor;
    [self.view addSubview:self.defaultCardView];
    
    CGFloat margin_Y = IS_IPHONE_5?80:100;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.defaultCardView.top-margin_Y, SCREEN_WIDTH, 50)];
    self.titleLabel.text = @"请 1 号玩家查看身份";
    self.titleLabel.textColor = EnableColor;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:self.titleLabel];
    
    // 身份Label
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CardViewWidth-TextLabelHeight, self.defaultCardView.width, TextLabelHeight)];
    self.textLabel.textAlignment = NSTextAlignmentRight;
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:20];
    self.textLabel.text = self.dataArray[self.index];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.alpha = 0;
    [self.defaultCardView addSubview:self.textLabel];
    
    float button_x = (SCREEN_WIDTH - ButtonWidth*2 - ButtonGap)/2.;
    self.checkCard = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    [self.checkCard addTarget:self action:@selector(cardViewTransitionEvent) forControlEvents:UIControlEventTouchUpInside];
    CGFloat Margin_Y = IS_IPHONE_5?60:80;
    self.checkCard.frame = CGRectMake(button_x, self.defaultCardView.bottom+Margin_Y, ButtonWidth, ButtonHeight);
    self.checkCard.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    self.checkCard.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    [self.checkCard setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
    [self.checkCard setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
    self.checkCard.radius = 8.0;
    self.checkCard.margin = 4.0;
    self.checkCard.depth = 3.0;
    
    self.checkCard.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.checkCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkCard setTitle:@"查看身份" forState:UIControlStateNormal];
    
    [self.view addSubview:self.checkCard];
    
    self.disCard = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    [self.disCard addTarget:self action:@selector(cardDismissEvent) forControlEvents:UIControlEventTouchUpInside];
    self.disCard.frame = CGRectMake(self.checkCard.right + ButtonGap, self.checkCard.y, ButtonWidth, ButtonHeight);
    self.disCard.faceColor = [UIColor colorWithRed:243.0/255.0 green:152.0/255.0 blue:0 alpha:1.0];
    self.disCard.sideColor = [UIColor colorWithRed:170.0/255.0 green:105.0/255.0 blue:0 alpha:1.0];
    [self.disCard setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
    [self.disCard setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
    
    self.disCard.radius = 8.0;
    self.disCard.margin = 4.0;
    self.disCard.depth = 3.0;
    self.disCard.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.disCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.disCard setTitle:@"查看完毕" forState:UIControlStateNormal];
    self.disCard.enabled = NO;
    [self.view addSubview:self.disCard];
}

// 查看身份按钮执行时间
-(void)cardViewTransitionEvent
{
    self.textLabel.alpha = 1;
    if (!self.isBack)
        return;
    
    self.titleLabel.text =[NSString stringWithFormat:@"%ld 号玩家身份是",self.index+1];
    
    [UIView transitionWithView:self.defaultCardView duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        if (self.isBack)
        {
            NSString *cardName = [self getCardNameWithActor:self.textLabel.text];
            self.defaultCardView.image = [UIImage imageNamed:cardName];
            self.isBack = NO;
        }
        else
        {
            self.defaultCardView.image = [UIImage imageNamed:@"card_bg"];
            self.isBack = YES;
        }
    } completion:^(BOOL finished) {
        self.checkCard.enabled = NO;
        self.disCard.enabled = YES;
    }];
}

// 查看完毕按钮执行时间
-(void)cardDismissEvent
{
    self.textLabel.alpha = 0;
    if (self.isBack)
        return;
    [UIView transitionWithView:self.defaultCardView duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.defaultCardView.image = [UIImage imageNamed:@"card_bg"];
    } completion:^(BOOL finished) {
        self.isBack = YES;
        self.checkCard.enabled = YES;
        self.disCard.enabled = NO;
    }];
    
    if (self.index == self.dataArray.count-1)
    {
        // 最有一个玩家查看完毕，法官开始主持工作
        [self.checkCard removeFromSuperview];
        [self.disCard removeFromSuperview];
        
        float button_x = (SCREEN_WIDTH - ButtonWidth)/2.;
        QBFlatButton *judgeButton = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        [judgeButton addTarget:self action:@selector(judgeButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        judgeButton.frame = CGRectMake(button_x, self.defaultCardView.bottom+80, ButtonWidth, ButtonHeight);
        judgeButton.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        judgeButton.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        judgeButton.radius = 8.0;
        judgeButton.margin = 4.0;
        judgeButton.depth = 3.0;
        
        judgeButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [judgeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [judgeButton setTitle:@"开始主持" forState:UIControlStateNormal];
        [self.view addSubview:judgeButton];
        self.titleLabel.text = @"请将手机交给上帝";
        return;
    }
    self.titleLabel.text =[NSString stringWithFormat:@"请 %ld 号玩家查看身份",++self.index + 1];
    self.textLabel.text = self.dataArray[self.index];
}

// 法官主持开始
-(void)judgeButtonEvent
{
    NSLog(@"-------");
    if ([self.delegate respondsToSelector:@selector(judgeEvent:)])
    {
        [self.delegate performSelector:@selector(judgeEvent:) withObject:self.dataArray];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dissMissEvent
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 根据角色名称返回相应图片名称
-(NSString *)getCardNameWithActor:(NSString *)name
{
    if ([name isEqualToString:@"狼人"])
    {
        return @"wolfCard";
    }
    else if([name isEqualToString:@"村民"])
    {
        return @"villagerCard";
    }
    else if([name isEqualToString:@"先知"])
    {
        return @"seerCard";
    }
    else if([name isEqualToString:@"女巫"])
    {
        return @"witchCard";
    }
    else if([name isEqualToString:@"猎人"])
    {
        return @"hunterCard";
    }
    else if([name isEqualToString:@"白痴"])
    {
        return @"idiotCard";
    }
    else
    {
        return @"";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
