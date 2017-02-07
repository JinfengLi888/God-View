//
//  WWNumLabel.h
//  Werewolf
//
//  Created by Jean on 11/26/16.
//  Copyright © 2016 jinfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WWNumLabelDelegate <NSObject>

-(void)touchesEndedPoint:(NSString *)point withTag:(NSString *)tag;
-(void)touchUpInsideEventWithTag:(NSString *)tag;

@end

@interface WWNumLabel : UILabel

@property (nonatomic, assign) id<WWNumLabelDelegate> delegate;

// 是否可以拖动
@property (nonatomic, assign) BOOL canDrag;

@end
