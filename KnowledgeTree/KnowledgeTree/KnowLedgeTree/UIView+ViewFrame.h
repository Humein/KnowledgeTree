//
//  UIView+ViewFrame.h
//  KnowledgeTree
//
//  Created by 鑫鑫 on 2017/4/12.
//  Copyright © 2017年 xinxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewFrame)
- (CGPoint)origin;
- (void)setOrigin:(CGPoint) point;

- (CGSize)size;
- (void)setSize:(CGSize) size;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)tail;
- (void)setTail:(CGFloat)tail;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;

@end
