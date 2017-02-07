//
//  WWPickerView.h
//  Werewolf
//
//  Created by Jean on 11/23/16.
//  Copyright © 2016 jinfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WWPickerBlock)(NSString *num);

@interface WWPickerView : UIPickerView

@property (nonatomic) NSInteger nums;
@property (nonatomic, copy) WWPickerBlock block;

@property (nonatomic, strong) UIViewController *superController;

@end
