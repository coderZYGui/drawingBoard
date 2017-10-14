//
//  ZYDrawView.m
//  DrawingBoard
//
//  Created by 朝阳 on 2017/10/14.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import "ZYDrawView.h"
#import "ZYBezierPath.h"
/** 定义类扩展 */
@interface ZYDrawView ()

@property (nonatomic, strong) UIBezierPath *path;
/** 用来保存所有的path */
@property (nonatomic, strong) NSMutableArray *allPaths;
/** 线宽 */
@property (nonatomic, assign) CGFloat width;
/** 线色 */
@property (nonatomic, strong) UIColor *color;

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
    
    
    
    // 设置一个默认线宽和线色
    self.width = 1;
    self.color = [UIColor blackColor];
    
}

// 清屏
- (void)clear
{
    [self.allPaths removeAllObjects];
    // 重绘
    [self setNeedsDisplay];
}

// 撤销
- (void)undo
{
    [self.allPaths removeLastObject];
    [self setNeedsDisplay];
}

// 擦除
- (void)eraser
{
    
}

// 设置线宽
- (void)setLineWidth:(CGFloat)width
{
    self.width = width;
    
}

// 设置线的颜色
- (void)setLineColor:(UIColor *)color
{
    self.color = color;
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
        ZYBezierPath *path = [[ZYBezierPath alloc] init];
        self.path = path;
        
        // 设置线宽
        [path setLineWidth:self.width];
        path.color = self.color;
        
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

- (void)setImage:(UIImage *)image
{
    _image = image;
    // 把图片添加到数组中
    [self.allPaths addObject:image];
    // 重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    for (ZYBezierPath *path in self.allPaths) {
        // 判断path的真实类型
        if ([path isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)path;
            // 把图片绘制到画板中(填充整个区域)
            [image drawInRect:rect];
        }else{
            [path.color set];
            [path stroke];
        }
    }
    
}

@end
