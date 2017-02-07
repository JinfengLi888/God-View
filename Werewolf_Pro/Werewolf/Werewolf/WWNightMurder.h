//
//  WWNightMurder.h
//  Werewolf
//
//  Created by Jean on 12/2/16.
//  Copyright © 2016 jinfeng. All rights reserved.
//  每天死亡的号码

#import <Foundation/Foundation.h>

@interface WWNightMurder : NSObject

// 被狼人击杀的号码
@property (nonatomic, strong) NSString *wolfKill;
// 女巫是否救起,如果YES，那么是平安夜，解药已使用
@property (nonatomic) BOOL rescued;
// 女巫毒死的号码
@property (nonatomic, strong) NSString *witchKill;
// 判断witchKill是否是猎人，是猎人则无法开枪
@property (nonatomic) BOOL hunterPoisoned;

// 被投票放逐的人, 赋值后判断是否是猎人，是猎人则可以开枪；判断是否为白痴，是白痴那投不死
@property (nonatomic, strong) NSString *bansionKill;
// 被猎人崩死的人
@property (nonatomic, strong) NSString *hunterKill;

// 每天一共7个步骤：1.狼人击杀 2.预言家请睁眼验人 3.女巫救人 4.女巫毒人 5.猎人状态 6.放逐投票 7.猎人开枪
@property (nonatomic) NSInteger step;

// 根据步骤来获取提示信息
-(NSString *)getStepString;

@end
