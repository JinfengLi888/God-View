//
//  WWDealCardViewController.h
//  Werewolf
//
//  Created by Jean on 12/6/16.
//  Copyright © 2016 jinfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WWDealCardProtocol <NSObject>

-(void)judgeEvent:(NSArray *)array;

@end

@interface WWDealCardViewController : UIViewController

@property (nonatomic) NSInteger wolfCount; // 狼人数量
@property (nonatomic) NSInteger villagerCount; // 村民数量
@property (nonatomic) NSInteger prophetCount; // 预言家数量

// 神的数组,存放神的名字
@property (nonatomic, strong) NSMutableArray *godArray;

@property (nonatomic, assign) id<WWDealCardProtocol> delegate;

@end
