//
//  PicAjustController.m
//  eCamera
//
//  Created by shiguang on 2018/10/25.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "PicAjustController.h"


typedef enum : NSUInteger{
    InputTypeBrightness = 0,
    InputTypeContrast = 1,
    InputTypeSaturation = 2
}InputType;

@interface PicAjustController ()
{
    CIContext *_context;
    CIImage *_image;
    CIImage *_outputImage;
    CIFilter *_colorControlsFilter;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *ajustFuncView;
@property (nonatomic,assign) CGFloat brightValue;
@property (nonatomic,assign) CGFloat contrastValue;
@property (nonatomic,assign) CGFloat saturationValue;
@property (nonatomic,assign) InputType inputType;
@property (weak, nonatomic) IBOutlet UIButton *brightnessBtn;
@property (weak, nonatomic) IBOutlet UIButton *contrastBtn;
@property (weak, nonatomic) IBOutlet UIButton *saturationBtn;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation PicAjustController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.brightValue = 0;
    self.contrastValue = self.saturationValue = 1;
    self.inputType = InputTypeBrightness;
    self.imageView.image = self.originImg;
    
    
    _context=[CIContext contextWithOptions:nil];
    
    _colorControlsFilter=[CIFilter filterWithName:@"CIColorControls"];
    
    //初始化CIImage源图像
    _image=[CIImage imageWithCGImage:self.originImg.CGImage];
    [_colorControlsFilter setValue:_image forKey:@"inputImage"];//设置滤镜的输入图片
    
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    self.slider.maximumValue = 0.5;
    self.slider.minimumValue = -0.5;
    self.slider.value = self.brightValue;
    self.slider.minimumTrackTintColor = [UIColor colorWithRed:37/255.0 green:185/255.0 blue:195/255.0 alpha:1.0];
    self.slider.maximumTrackTintColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
}
-(void)setImage{
    CIImage *outputImage= [_colorControlsFilter outputImage];//取得输出图像
    CGImageRef temp=[_context createCGImage:outputImage fromRect:[outputImage extent]];
    _imageView.image=[UIImage imageWithCGImage:temp];//转化为CGImage显示在界面中
    
    CGImageRelease(temp);//释放CGImage对象
}
- (IBAction)cancelClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveClick:(UIButton *)sender {
    self.ImageBlock(self.imageView.image);
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)compareTouchDownClick:(UIButton *)sender {
    self.imageView.image = self.originImg;
}
- (IBAction)compareTouchUpInsideClick:(UIButton *)sender {
    [self setImage];
}
- (IBAction)withDrawClick:(UIButton *)sender {
    self.imageView.image = self.originImg;
    self.slider.maximumValue = 0.5;
    self.slider.minimumValue = -0.5;
    self.slider.value = self.brightValue = 0;
    self.contrastValue = self.saturationValue = 1;
    self.brightnessBtn.selected = YES;
    self.contrastBtn.selected = self.saturationBtn.selected = NO;
}
- (IBAction)inputFilterChangeClick:(UIButton *)sender {
    self.inputType = (NSUInteger)sender.tag;
    switch (self.inputType) {
        case InputTypeBrightness:
            self.brightnessBtn.selected = YES;
            self.contrastBtn.selected = self.saturationBtn.selected = NO;
            self.slider.maximumValue = 0.5;
            self.slider.minimumValue = -0.5;
            self.slider.value = self.brightValue;
            break;
        case InputTypeContrast:
            self.contrastBtn.selected = YES;
            self.brightnessBtn.selected = self.saturationBtn.selected = NO;
            self.slider.maximumValue = 1.5;
            self.slider.minimumValue = 0.5;
            self.slider.value = self.contrastValue;
            break;
        case InputTypeSaturation:
            self.saturationBtn.selected = YES;
            self.contrastBtn.selected = self.brightnessBtn.selected = NO;
            self.slider.maximumValue = 1.5;
            self.slider.minimumValue = 0.5;
            self.slider.value = self.saturationValue;
            break;
        default:
            break;
    }
}

-(void)sliderValueChange:(UISlider *)slider{
    
    switch (self.inputType) {
        case InputTypeBrightness:
        {
            self.brightValue = slider.value;
            [_colorControlsFilter setValue:[NSNumber numberWithFloat:slider.value] forKey:@"inputBrightness"];
        }
            break;
        case InputTypeContrast:
        {
            self.contrastValue = slider.value;
            [_colorControlsFilter setValue:[NSNumber numberWithFloat:slider.value] forKey:@"inputSaturation"];
        }
            break;
        case InputTypeSaturation:
        {
            self.saturationValue = slider.value;
            [_colorControlsFilter setValue:[NSNumber numberWithFloat:slider.value] forKey:@"inputContrast"];
        }
            break;
        default:
            break;
    }
    [self setImage];
}

@end
