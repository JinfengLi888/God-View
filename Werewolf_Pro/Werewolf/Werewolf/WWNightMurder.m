//
//  WWNightMurder.m
//  Werewolf
//
//  Created by Jean on 12/2/16.
//  Copyright © 2016 jinfeng. All rights reserved.
//

#import "WWNightMurder.h"

@implementation WWNightMurder

-(NSString *)getStepString
{
    NSString *str = @"";
    switch (self.step) {
        case 1:
        {
            str = @"狼人请睁眼,请选择击杀目标.(点击号码杀死角色)";
        }
            break;
        case 2:
        {
            str = @"狼人请闭眼,预言家请睁眼，预言家请验人";
        }
            break;
        case 3:
        {
            str = [NSString stringWithFormat:@"今晚死亡的是%@号,是否使用解药.（点击死亡号码即可救活该角色）",self.wolfKill];
        }
            break;
        case 4:
        {
            str = @"是否使用毒药.(点击号码即可毒死该角色)";
        }
            break;
        case 5:
        {
            if (self.hunterPoisoned)
                str = @"猎人请睁眼，今晚状态是:不能开枪";
            else
                str = @"猎人请睁眼，今晚状态是:可以开枪";
        }
            break;
        case 6:
        {
            str = [NSString stringWithFormat:@"今天被放逐的人是%@号",self.bansionKill];
        }
            break;
        case 7:
        {
            str = [NSString stringWithFormat:@"猎人崩死%@号",self.hunterKill];
        }
            break;
        default:
            break;
    }
    return str;
}

@end
