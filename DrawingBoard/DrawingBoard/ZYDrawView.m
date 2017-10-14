//
//  ZYDrawView.m
//  DrawingBoard
//
//  Created by 朝阳 on 2017/10/14.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import "ZYDrawView.h"
/** 定义类扩展 */
@interface ZYDrawView ()

@property (nonatomic, strong) UIBezierPath *path;
/** 用来保存所有的path */
@property (nonatomic, strong) NSMutableArray *allPaths;

@end

@implementation ZYDrawView

- (NSMutableArray *)allPaths
{
    if (!_allPaths) {
        self.allPaths = [NSMutableArray array];
    }
    return _allPaths;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

/**
 拖动手势方法
 */
- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 获取当前手指所在的点
    CGPoint curP = [pan locationInView:self];
    // 判断手势状态
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 创建路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        self.path = path;
        // 设置起点
        [path moveToPoint:curP];
        // 把路径保存到数组中
        [self.allPaths addObject:self.path];
        
    }else if(pan.state == UIGestureRecognizerStateChanged){
        [self.path addLineToPoint:curP];
        // 重绘,调用drawRect方法
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    
    for (UIBezierPath *path in self.allPaths) {
        [path stroke];
    }
    
}


@end
