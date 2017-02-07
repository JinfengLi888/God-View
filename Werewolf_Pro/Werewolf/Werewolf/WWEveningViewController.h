//
//  WWEveningViewController.h
//  Werewolf
//
//  Created by Jean on 11/26/16.
//  Copyright © 2016 jinfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWEveningViewController : UIViewController

@property (nonatomic) NSInteger wolfCount; // 狼人数量
@property (nonatomic) NSInteger villagerCount; // 村民数量
@property (nonatomic) NSInteger prophetCount; // 预言家数量

// 神的数组,存放神的名字
@property (nonatomic, strong) NSMutableArray *godArray;


// 进行发牌过后的身份数组
@property (nonatomic, strong) NSArray *dealedDataArray;

@end
