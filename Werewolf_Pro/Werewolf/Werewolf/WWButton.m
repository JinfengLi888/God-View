//
//  WWButton.m
//  Werewolf
//
//  Created by Jean on 11/14/16.
//  Copyright © 2016 jinfeng. All rights reserved.
//

#import "WWButton.h"
#import "WWDefines.h"

#define LabelFontSize_2 20
#define BuleColor RGBAColor(33, 142, 208, 1)

@implementation WWButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel.font = [UIFont systemFontOfSize:LabelFontSize_2];
//        self.backgroundColor = BuleColor;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.layer.cornerRadius = 5;
        self.layer.shadowOffset =  CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowColor =  [UIColor blackColor].CGColor;
    }
    
    return self;
}

@end
