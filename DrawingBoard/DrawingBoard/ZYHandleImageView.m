//
//  ZYHandleImageView.m
//  DrawingBoard
//
//  Created by 朝阳 on 2017/10/14.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import "ZYHandleImageView.h"
/** 定义类扩展 */
@interface ZYHandleImageView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *imageV;

@end

@implementation ZYHandleImageView

- (UIImageView *)imageV
{
    if (!_imageV) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        imageV.userInteractionEnabled = YES;
        [self addSubview:imageV];
        _imageV = imageV;
        // 添加手势
        [self addGestures];
    }
    return _imageV;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageV.image = image;
}

- (void)addGestures
{
    // 拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(pan:)];
    
    [self.imageV addGestureRecognizer:pan];
    
    // 捏合
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    pinch.delegate = self;
    [self.imageV addGestureRecognizer:pinch];
    
    
    // 添加旋转
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    rotation.delegate = self;
    
    [self.imageV addGestureRecognizer:rotation];
    
    // 长按
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.imageV addGestureRecognizer:longP];
}

// 拖动的时候调用
- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 手指移动后,相对于坐标中的偏移量
    // 此时的pan.view 就相当于 UIImageView
    CGPoint transP = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, transP.x, transP.y);
    // 复位
    [pan setTranslation:CGPointZero inView:pan.view];
    
}

// 捏合的时候调用
- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    //复位
    [pinch setScale:1];
}

// 旋转的时候调用
- (void)rotation:(UIRotationGestureRecognizer *)rotation
{
    rotation.view.transform = CGAffineTransformRotate(rotation.view.transform, rotation.rotation);
    //复位
    [rotation setRotation:0];
}

// 长按的时候调用
-(void)longPress:(UILongPressGestureRecognizer *)longPress
{
    // 长按时,图片闪烁一下
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.imageV.alpha = 0;
            
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.imageV.alpha = 1;
                
            }completion:^(BOOL finished) {
                // 把相册中的图片绘制到DrawView上
                //1. 开启一个位图上下文
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                //2. 把imageV上的内容绘制到上下文中
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                [self.layer renderInContext:ctx];
                //3. 从上下文中生成新的图片
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                
                //4. 关闭上下文
                UIGraphicsEndImageContext();
                
                // 若要把newImage绘制到DrawView上,需要使用代理进行传值
                if ([self.delegate respondsToSelector:@selector(handleImageView:newImage:)]) {
                    [self.delegate handleImageView:self newImage:newImage];
                }
                
                //从父控件当中移除
                [self removeFromSuperview];
                
            }];
        }];
    }
}

//能够同时支持多个手势
-(BOOL)gestureRecognizer:(nonnull UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

@end
