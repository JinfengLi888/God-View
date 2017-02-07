//
//  UIView+ext.h
//  xuezhezaixian
//
//  Created by Li on 13-8-22.
//  Copyright (c) 2013年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ext)
- (CGPoint)origin;
- (void)setOrigin:(CGPoint)newOrigin;
- (CGSize)size;
- (void)setSize:(CGSize)newSize;

- (CGFloat)x;
- (void)setX:(CGFloat)newX;
- (CGFloat)y;
- (void)setY:(CGFloat)newY;

- (CGFloat)height;
- (void)setHeight:(CGFloat)newHeight;
- (CGFloat)width;
- (void)setWidth:(CGFloat)newWidth;

- (CGFloat)top;
- (CGFloat)left;
- (CGFloat)bottom;
- (CGFloat)right;
@end
