//
//  ZYDrawView.h
//  DrawingBoard
//
//  Created by 朝阳 on 2017/10/14.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYDrawView : UIView

@property (nonatomic, strong) UIImage *image;

// 清屏
- (void)clear;
// 撤销
- (void)undo;
// 擦除
- (void)eraser;
// 设置线宽
- (void)setLineWidth:(CGFloat)width;
// 设置线的颜色
- (void)setLineColor:(UIColor *)color;

@end
