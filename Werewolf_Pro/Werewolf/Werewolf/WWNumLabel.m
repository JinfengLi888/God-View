//
//  WWNumLabel.m
//  Werewolf
//
//  Created by Jean on 11/26/16.
//  Copyright © 2016 jinfeng. All rights reserved.
//

#import "WWNumLabel.h"
#import "UIView+ext.h"



@implementation WWNumLabel

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
//        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

-(void)tapGestureEvent:(UITapGestureRecognizer *)sender
{
//    UIImageView *biteImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
////    biteImgView.image = [UIImage imageNamed:@"dieDayImg"];
//    biteImgView.image = [UIImage imageNamed:@"dieNightImg"];
//    biteImgView.alpha = 1;
//    [self addSubview:biteImgView];
    if ([self.delegate respondsToSelector:@selector(touchUpInsideEventWithTag:)])
    {
        [self.delegate performSelector:@selector(touchUpInsideEventWithTag:) withObject:[NSString stringWithFormat:@"%ld",self.tag]];
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (!self.canDrag) return;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    CGPoint previousPoint = [touch previousLocationInView:self.superview];
    CGPoint center = self.center;
    center.x += (currentPoint.x - previousPoint.x);
    center.y += (currentPoint.y - previousPoint.y);
    self.center = center;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (!self.canDrag) return;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    if ([self.delegate respondsToSelector:@selector(touchesEndedPoint:withTag:)]) {
        [self.delegate performSelector:@selector(touchesEndedPoint:withTag:) withObject:NSStringFromCGPoint(currentPoint) withObject:[NSString stringWithFormat:@"%ld",self.tag]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
