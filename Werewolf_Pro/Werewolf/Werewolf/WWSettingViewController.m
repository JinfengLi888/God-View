//
//  WWSettingViewController.m
//  Werewolf
//
//  Created by Jean on 12/1/16.z
//  Copyright © 2016 jinfeng. All rights reserved.
//

#import "WWSettingViewController.h"
#import "WWDefines.h"
#import "UIView+ext.h"
#import <MessageUI/MessageUI.h> 
#import <StoreKit/StoreKit.h>

#define Xinshou_SwitchTag 77
#define TableHeight 55


@interface WWSettingViewController ()<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) SKPayment *payment;
@property (strong, nonatomic) SKMutablePayment *g_payment;

@end

@implementation WWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImg"]];
    self.title = @"设置";
    
    // 设置右上角完成按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(doneButtonEvent)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MainContentHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UILabel *creditLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 20)];
    creditLabel1.text =  @"App Icon and Card Images made by Freepik";
    creditLabel1.textAlignment = NSTextAlignmentCenter;
    creditLabel1.font = [UIFont systemFontOfSize:13];
    creditLabel1.textColor = [UIColor blackColor];
    creditLabel1.alpha = .7;
    creditLabel1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:creditLabel1];
    
    // 内购
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
}

-(void)doneButtonEvent
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate 

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2)
        return 1;
    else
        return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (section == 0)
    {
        if (row == 1)
        {
            // 我没有卡牌
            cell.textLabel.text = @"开启发牌模式";
            UISwitch *switchButton = [[UISwitch alloc] init];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [switchButton addTarget:self action:@selector(dealCardSwitchEvent:) forControlEvents:UIControlEventValueChanged];
            switchButton.on = [userDefault boolForKey:DealCardMode];
            switchButton.x = SCREEN_WIDTH-10-switchButton.width;
            switchButton.y = (TableHeight-switchButton.height)/2.;
            [cell.contentView addSubview:switchButton];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else if(row == 0)
        {
            cell.textLabel.text = @"版本号";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.text =[NSString stringWithFormat:@"v%@",Werewolf_Version];
            cell.detailTextLabel.textColor = HexColor(0x007aff);
//            cell.textLabel.text = @"新手模式";
//            UISwitch *switchButton = [[UISwitch alloc] init];
//            
//            switchButton.tag = Xinshou_SwitchTag;
//            switchButton.on = YES;
//            switchButton.x = SCREEN_WIDTH-10-switchButton.width;
//            switchButton.y = (TableHeight-switchButton.height)/2.;
//            [cell.contentView addSubview:switchButton];
        }
    }
    else if(section == 1)
    {
        if (row == 0)
        {
            cell.textLabel.text = @"分享此应用";
        }
        else if (row == 1)
        {
            cell.textLabel.text = @"去评分";
        }
    }
    else if (section == 2)
    {
//        if (row == 0)
//        {
//            cell.textLabel.text = @"一元去广告";
//        }
//        else if (row == 1)
//        {
            cell.textLabel.text = @"联系作者";
//        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    if (section == 1)
    {
        if (row == 0)
        {
            // share this app
            NSString *title = [NSString stringWithFormat:@"%@(狼人杀上帝助手)",AppName];
            NSURL *urlToShare = [NSURL URLWithString:AppStoreURL];
            UIImage *imgToShare = [UIImage imageNamed:@"iCon"];
            UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[urlToShare,imgToShare,title] applicationActivities:nil];
            [self presentViewController:activity animated:YES completion:nil];
        }
        else if(row == 1)
        {
            // rate on app store
            [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:AppStoreURL]
                                               options:@{}
                                     completionHandler:nil];
        }
    }
    else if(section == 2)
    {
//        if (row == 0)
//        {
//            // 去广告
//            [self payToRomoveAd];
//        }
//        else if(row == 1)
//        {
//            // 发邮件
            [self sendEmailToAuthor];
//        }
    }
}

#pragma mark -
#pragma mark Deal Card Event

-(void)dealCardSwitchEvent:(UISwitch *)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (sender.isOn)
        [userDefault setBool:YES forKey:DealCardMode];
    else
        [userDefault setBool:NO forKey:DealCardMode];
    
    [userDefault synchronize];
}

#pragma mark -
#pragma mark Email Action

-(void)sendEmailToAuthor
{
    NSString *emailTitle = @"Sent via God View";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"jackielycs@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Method 

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark 内购方法

-(void)payToRomoveAd
{
    if ([SKPaymentQueue canMakePayments]) {
//        [self requestProductData:PRODUCTID];
        //根据商品ID查找商品信息
        NSArray *product = [[NSArray alloc] initWithObjects:Product_ID, nil];
        NSSet *nsset = [NSSet setWithArray:product];
        //创建SKProductsRequest对象，用想要出售的商品的标识来初始化， 然后附加上对应的委托对象。
        //该请求的响应包含了可用商品的本地化信息。
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
        request.delegate = self;
        [request start];
    } else {
        NSLog(@"不允许程序内付费");
    }
}

#pragma mark -
#pragma mark SKProductsRequestDelegate Methods

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //接收商品信息
    NSArray *product = response.products;
    NSArray *invaildProducts = response.invalidProductIdentifiers;
    if ([product count] == 0) {
        // 无产品信息
        return;
    }
    // SKProduct对象包含了在App Store上注册的商品的本地化信息。
    SKProduct *storeProduct = nil;
    for (SKProduct *pro in product) {
        if ([pro.productIdentifier isEqualToString:Product_ID]) {
            storeProduct = pro;
        }
    }
    
    self.g_payment = [SKMutablePayment paymentWithProduct:storeProduct];
    self.g_payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:self.g_payment];
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"请求商品失败%@", error);
}

- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"反馈信息结束调用");
}

//监听购买结果
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *tran in transactions) {
    // 如果小票状态是购买完成
    if (SKPaymentTransactionStatePurchased == tran.transactionState) {
        [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        // 更新界面或者数据，把用户购买得商品交给用户
            //返回购买的商品信息
        //        [self verifyPruchase];
            //商品购买成功可调用本地接口
        } else if (SKPaymentTransactionStateRestored == tran.transactionState) {
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        } else if (SKPaymentTransactionStateFailed == tran.transactionState) {
            // 支付失败
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        }
    }
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"交易结束");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
- (void)verifyPruchase {
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    // 发送网络POST请求，对购买凭据进行验证
    //测试验证地址:https://sandbox.itunes.apple.com/verifyReceipt
    //正式验证地址:https://buy.itunes.apple.com/verifyReceipt
    NSURL *url = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    urlRequest.HTTPMethod = @"POST";
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    urlRequest.HTTPBody = payloadData;
    // 提交验证请求，并获得官方的验证JSON结果 iOS9后更改了另外的一个方法
    NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    // 官方验证结果为空
    if (result == nil)
    {
        NSLog(@"验证失败");// 购买失败
        return;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
    if (dict != nil)
    {
        NSLog(@"验证成功！购买的商品是：%@", @"_productName");
        // 在这里去除广告
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:YES forKey:Purchased];
        [userDefault synchronize];
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
