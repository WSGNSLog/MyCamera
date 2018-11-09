//
//  PicGPUAjustController.m
//  MyCamera
//
//  Created by shiguang on 2018/11/5.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PicGPUAjustController.h"
#import "GPUImage.h"
#import "GPUImageBrightnessFilter.h" //亮度
#import "GPUImageContrastFilter.h" //对比度
#import "GPUImageSaturationFilter.h" //饱和度

typedef enum : NSUInteger{
    InputTypeBrightness = 0,
    InputTypeContrast = 1,
    InputTypeSaturation = 2
}InputType;

@interface PicGPUAjustController (){
    CIContext *_context;
    CIImage *_image;
    CIImage *_outputImage;
    CIFilter *_colorControlsFilter;
    GPUImagePicture           *picSource;
    GPUImageBrightnessFilter  *BrightnessFilter;
    GPUImageSaturationFilter  *SaturationFilter;
    GPUImageContrastFilter    *ContrastFilter;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *brightnessBtn;
@property (weak, nonatomic) IBOutlet UIButton *contrastBtn;
@property (weak, nonatomic) IBOutlet UIButton *saturationBtn;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic,assign) InputType inputType;
@property (nonatomic,assign) CGFloat brightValue;
@property (nonatomic,assign) CGFloat contrastValue;
@property (nonatomic,assign) CGFloat saturationValue;
@end

@implementation PicGPUAjustController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.brightValue = 0;
    self.contrastValue = self.saturationValue = 1;
    self.inputType = InputTypeBrightness;
    self.imageView.image = self.originImg;
    
    picSource =  [[GPUImagePicture alloc] initWithImage:self.originImg];
}

- (IBAction)cancelClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveClick:(UIButton *)sender {
    self.ImageBlock(self.imageView.image);
    [self dismissViewControllerAnimated:YES completion:nil];
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
            
            if (!BrightnessFilter) {
                BrightnessFilter = [[GPUImageBrightnessFilter alloc] init];
                [picSource addTarget:BrightnessFilter];
            }
            BrightnessFilter.brightness = slider.value;
            [self updateImage:BrightnessFilter];
        }
            break;
        case InputTypeContrast:
        {
            self.contrastValue = slider.value;
            
            if (!ContrastFilter) {
                ContrastFilter = [[GPUImageContrastFilter alloc] init];
                [picSource addTarget:ContrastFilter];
            }
            ContrastFilter.contrast = slider.value;
            [self updateImage:ContrastFilter];
        }
            break;
        case InputTypeSaturation:
        {
            self.saturationValue = slider.value;
            
            if (!SaturationFilter) {
                GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc] init];
                [picSource addTarget:filter];
                SaturationFilter = filter;
            }
            SaturationFilter.saturation = slider.value;
            [self updateImage:SaturationFilter];
        }
            break;
        default:
            break;
    }
}
-(void)updateImage:(GPUImageOutput*)filter
{
    [filter useNextFrameForImageCapture];
    [picSource processImage];
    UIImage *newImage = [filter imageFromCurrentFramebuffer];
    if (newImage) {
        self.imageView.image = newImage;
    }
}

@end
