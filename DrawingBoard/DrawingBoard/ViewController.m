//
//  ViewController.m
//  DrawingBoard
//
//  Created by 朝阳 on 2017/10/14.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import "ViewController.h"
#import "ZYDrawView.h"
#import "ZYHandleImageView.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYHandleImageViewDelegate>

@property (weak, nonatomic) IBOutlet ZYDrawView *drawView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 操作属于谁,写在谁的类中

/**
 清屏
 */
- (IBAction)clear:(UIBarButtonItem *)sender {
    [self.drawView clear];
}

/**
 撤销
 */
- (IBAction)undo:(UIBarButtonItem *)sender {
    [self.drawView undo];
}

/**
 橡皮擦
 */
- (IBAction)eraser:(UIBarButtonItem *)sender {
    [self.drawView eraser];
}

/**
 设置线宽
 */
- (IBAction)setLineWidth:(UISlider *)slider {
    [self.drawView setLineWidth:slider.value];
}

/**
 设置线颜色
 */
- (IBAction)setLineColor:(UIButton *)button {
    [self.drawView setLineColor:button.backgroundColor];
}


/**
 照片
 */
- (IBAction)photo:(UIBarButtonItem *)sender {
    
    //从系统相册中选择一张图片
    //1. 弹出系统相册
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    //2. 弹出相册的类型
    pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //3. 设置pickerVC代理
    pickerVC.delegate = self;
    //3. modal出系统相册
    [self presentViewController:pickerVC animated:YES completion:nil];
}
#pragma -mark UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info);
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    ZYHandleImageView *handleV = [[ZYHandleImageView alloc] initWithFrame:self.drawView.frame];
    handleV.backgroundColor = [UIColor clearColor];
    handleV.image = image;
    // 设置代理属性
    handleV.delegate = self;
    
    [self.view addSubview:handleV];
    
    
    // 系统相册modal消失
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark ZYHandleImageViewDelegate
- (void)handleImageView:(ZYHandleImageView *)handleImageView newImage:(UIImage *)newImage
{
    self.drawView.image = newImage;
}

/**
 保存
 */
- (IBAction)save:(UIBarButtonItem *)sender {
    
    //1. 开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, NO, 0);
    //2. 把drawView上的内容渲染到上下文中
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.drawView.layer renderInContext:ctx];
    //3. 从上下文中生成新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //把图片保存到桌面
//    NSData *data = UIImagePNGRepresentation(newImage);
//    [data writeToFile:@"/Users/sunny/Desktop/photo.png" atomically:YES];
    
    //4. 把图片保存到系统相册中
    // 注意: 弹出系统相册必须实现 image:didFinishSavingWithError:contextInfo:方法
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"saveSuccess");
}

/**
 隐藏导航
 */
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
