//
//  ZYHandleImageView.h
//  DrawingBoard
//
//  Created by 朝阳 on 2017/10/14.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYHandleImageView;
@protocol ZYHandleImageViewDelegate <NSObject>

- (void)handleImageView:(ZYHandleImageView *)handleImageView newImage:(UIImage *)newImage;

@end

@interface ZYHandleImageView : UIView

@property (nonatomic, strong) UIImage *image;

/** 代理属性 */
@property (nonatomic, weak) id<ZYHandleImageViewDelegate> delegate;

@end
