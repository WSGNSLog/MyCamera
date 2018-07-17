//
//  PECropRectView.m
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/21.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "PECropRectView.h"
#import "PEResizeControl.h"

//裁剪框视图view
@interface PECropRectView ()<PEResizeControlViewDelegate>
//响应缩放手势的四个角
@property (nonatomic) PEResizeControl *topLeftCornerView;
@property (nonatomic) PEResizeControl *topRightCornerView;
@property (nonatomic) PEResizeControl *bottomLeftCornerView;
@property (nonatomic) PEResizeControl *bottomRightCornerView;
//响应缩放手势的四条边
@property (nonatomic) PEResizeControl *topEdgeView;
@property (nonatomic) PEResizeControl *leftEdgeView;
@property (nonatomic) PEResizeControl *bottomEdgeView;
@property (nonatomic) PEResizeControl *rightEdgeView;

@property (nonatomic) CGRect initialRect;
@property (nonatomic) CGFloat fixedAspectRatio;

@end

@implementation PECropRectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        self.showsGridMajor = YES;
        self.showsGridMinor = NO;
        
        //CGRectInset:高度和宽度相对于父视图分别缩小20像素。正值表示缩小，负值表示扩大。
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, -2.0f, -2.0f)];
        //自动调整view的宽度，保证左边距和右边距不变
        //自动调整view的高度，以保证上边距和下边距不变
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //resizableImageWithCapInsets图片拉伸
        imageView.image = [[UIImage imageNamed:@"PEPhotoCropEditor.bundle/PEPhotoCropEditorBorder"] resizableImageWithCapInsets:UIEdgeInsetsMake(23.0f, 23.0f, 23.0f, 23.0f)];
        [self addSubview:imageView];
        
        self.topLeftCornerView = [[PEResizeControl alloc] init];
        //self.topLeftCornerView.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
        self.topLeftCornerView.delegate = self;
        [self addSubview:self.topLeftCornerView];
        
        self.topRightCornerView = [[PEResizeControl alloc] init];
        self.topRightCornerView.delegate = self;
        [self addSubview:self.topRightCornerView];
        
        self.bottomLeftCornerView = [[PEResizeControl alloc] init];
        self.bottomLeftCornerView.delegate = self;
        [self addSubview:self.bottomLeftCornerView];
        
        self.bottomRightCornerView = [[PEResizeControl alloc] init];
        self.bottomRightCornerView.delegate = self;
        [self addSubview:self.bottomRightCornerView];
        
        self.topEdgeView = [[PEResizeControl alloc] init];
        self.topEdgeView.delegate = self;
        [self addSubview:self.topEdgeView];
        
        self.leftEdgeView = [[PEResizeControl alloc] init];
        self.leftEdgeView.delegate = self;
        [self addSubview:self.leftEdgeView];
        
        self.bottomEdgeView = [[PEResizeControl alloc] init];
        self.bottomEdgeView.delegate = self;
        [self addSubview:self.bottomEdgeView];
        
        self.rightEdgeView = [[PEResizeControl alloc] init];
        self.rightEdgeView.delegate = self;
        [self addSubview:self.rightEdgeView];
    }
    
    return self;
}

#pragma mark -

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSArray *subviews = self.subviews;
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[PEResizeControl class]]) {
            if (CGRectContainsPoint(subview.frame, point)) {
                return subview;
            }
        }
    }
    
    return nil;
}
//重绘作用：重写该方法以实现自定义的绘制内容
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    for (NSInteger i = 0; i < 3; i++) {
        CGFloat borderPadding = 2.0f;
        
        if (self.showsGridMinor) {
            for (NSInteger j = 1; j < 3; j++) {
                [[UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:0.3f] set];
                
                UIRectFill(CGRectMake(roundf(width / 3 / 3 * j + width / 3 * i), borderPadding, 1.0f, roundf(height) - borderPadding * 2));
                UIRectFill(CGRectMake(borderPadding, roundf(height / 3 / 3 * j + height / 3 * i), roundf(width) - borderPadding * 2, 1.0f));
            }
        }
        // UIRectFill(CGRect rect)：向当前绘图环境所创建的内存中的图片上填充一个矩形。
        
        // UIRectFillUsingBlendMode(CGRect rect , CGBlendMode blendMode)：向当前绘图环境所创建的内存中的图片上填充一个矩形，绘制使用指定的混合模式。
        
        //UIRectFrame(CGRect rect)：向当前绘图环境所创建的内存中的图片上绘制一个矩形边框
        if (self.showsGridMajor) {
            if (i > 0) {
                [[UIColor whiteColor] set];
                //round：如果参数是小数，则求本身的四舍五入。
                //外缘的矩形拉伸图片四条边距父视图边缘向内缩紧2，所以borderPadding设为2，画出来的线正好与矩形边框贴合
                //绘制四个宽为1的矩形
                //竖线
                UIRectFill(CGRectMake(roundf(width / 3 * i), borderPadding, 1.0f, roundf(height) - borderPadding * 2));
                //横线
                UIRectFill(CGRectMake(borderPadding, roundf(height / 3 * i), roundf(width) - borderPadding * 2, 1.0f));
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //四个边角的宽高为44，self.topLeftCornerView.frame = CGRectMake(22,22,44,44)，始终保持每个边角的一半宽、一半高在裁剪框视图PECropRectView的外面，保证角的周围都是可以拖动的
    //四条边同理
    self.topLeftCornerView.frame = (CGRect){CGRectGetWidth(self.topLeftCornerView.bounds) / -2, CGRectGetHeight(self.topLeftCornerView.bounds) / -2, self.topLeftCornerView.bounds.size};
    self.topRightCornerView.frame = (CGRect){CGRectGetWidth(self.bounds) - CGRectGetWidth(self.topRightCornerView.bounds) / 2, CGRectGetHeight(self.topRightCornerView.bounds) / -2, self.topLeftCornerView.bounds.size};
    self.bottomLeftCornerView.frame = (CGRect){CGRectGetWidth(self.bottomLeftCornerView.bounds) / -2, CGRectGetHeight(self.bounds) - CGRectGetHeight(self.bottomLeftCornerView.bounds) / 2, self.bottomLeftCornerView.bounds.size};
    self.bottomRightCornerView.frame = (CGRect){CGRectGetWidth(self.bounds) - CGRectGetWidth(self.bottomRightCornerView.bounds) / 2, CGRectGetHeight(self.bounds) - CGRectGetHeight(self.bottomRightCornerView.bounds) / 2, self.bottomRightCornerView.bounds.size};
    //四条边利用四个边角的位置及自身宽高计算自己的frame
    self.topEdgeView.frame = (CGRect){CGRectGetMaxX(self.topLeftCornerView.frame), CGRectGetHeight(self.topEdgeView.frame) / -2, CGRectGetMinX(self.topRightCornerView.frame) - CGRectGetMaxX(self.topLeftCornerView.frame), CGRectGetHeight(self.topEdgeView.bounds)};
    self.leftEdgeView.frame = (CGRect){CGRectGetWidth(self.leftEdgeView.frame) / -2, CGRectGetMaxY(self.topLeftCornerView.frame), CGRectGetWidth(self.leftEdgeView.bounds), CGRectGetMinY(self.bottomLeftCornerView.frame) - CGRectGetMaxY(self.topLeftCornerView.frame)};
    self.bottomEdgeView.frame = (CGRect){CGRectGetMaxX(self.bottomLeftCornerView.frame), CGRectGetMinY(self.bottomLeftCornerView.frame), CGRectGetMinX(self.bottomRightCornerView.frame) - CGRectGetMaxX(self.bottomLeftCornerView.frame), CGRectGetHeight(self.bottomEdgeView.bounds)};
    self.rightEdgeView.frame = (CGRect){CGRectGetWidth(self.bounds) - CGRectGetWidth(self.rightEdgeView.bounds) / 2, CGRectGetMaxY(self.topRightCornerView.frame), CGRectGetWidth(self.rightEdgeView.bounds), CGRectGetMinY(self.bottomRightCornerView.frame) - CGRectGetMaxY(self.topRightCornerView.frame)};
}

#pragma mark - 是否显示大的网格
- (void)setShowsGridMajor:(BOOL)showsGridMajor
{
    _showsGridMajor = showsGridMajor;
    [self setNeedsDisplay];
}
#pragma mark - 是否显示小的网格
- (void)setShowsGridMinor:(BOOL)showsGridMinor
{
    _showsGridMinor = showsGridMinor;
    [self setNeedsDisplay];
}

- (void)setKeepingAspectRatio:(BOOL)keepingAspectRatio
{
    _keepingAspectRatio = keepingAspectRatio;
    
    if (self.keepingAspectRatio) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        //fminf 返回参数的最小数值
        self.fixedAspectRatio = fminf(width / height, height / width);
    }
}

#pragma mark - 手势处理代理
- (void)resizeControlViewDidBeginResizing:(PEResizeControl *)resizeControlView
{
    self.initialRect = self.frame;
    
    if ([self.delegate respondsToSelector:@selector(cropRectViewDidBeginEditing:)]) {
        [self.delegate cropRectViewDidBeginEditing:self];
    }
}

- (void)resizeControlViewDidResize:(PEResizeControl *)resizeControlView
{
    self.frame = [self cropRectMakeWithResizeControlView:resizeControlView];
        
    if ([self.delegate respondsToSelector:@selector(cropRectViewEditingChanged:)]) {
        [self.delegate cropRectViewEditingChanged:self];
    }
}

- (void)resizeControlViewDidEndResizing:(PEResizeControl *)resizeControlView
{
    if ([self.delegate respondsToSelector:@selector(cropRectViewDidEndEditing:)]) {
        [self.delegate cropRectViewDidEndEditing:self];
    }
}
#pragma mark - 通过手势处理view的偏移计算裁剪框view新的frame
- (CGRect)cropRectMakeWithResizeControlView:(PEResizeControl *)resizeControlView
{
    CGRect rect = self.frame;
    /*
     CGRect size = CGRectMake(20, 20, 400, 400);
     //矩形中最小x值 ,size.x
     CGRectGetMinX(size) = 20;
     
     //矩形中最小y值 ,size.y
     CGRectGetMinY(size)=20,
     
     //矩形中最大x值,size.x+width
     CGRectGetMaxX(size)= 420
     
     //矩形中最大y值,size.y+height
     CGRectGetMaxY(size)=420
     
     //矩形中中心x值,size.x+width/2
     CGRectGetMidX(size)=220；
     
     //矩形中 中心y值size.y+height/2
     CGRectGetMidY(size)=220;
     */
    if (resizeControlView == self.topEdgeView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect),
                          CGRectGetMinY(self.initialRect) + resizeControlView.translation.y,
                          CGRectGetWidth(self.initialRect),
                          CGRectGetHeight(self.initialRect) - resizeControlView.translation.y);
        
        if (self.keepingAspectRatio) {
            rect = [self constrainedRectWithRectBasisOfHeight:rect aspectRatio:self.fixedAspectRatio];
        }
    } else if (resizeControlView == self.leftEdgeView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect) + resizeControlView.translation.x,
                          CGRectGetMinY(self.initialRect),
                          CGRectGetWidth(self.initialRect) - resizeControlView.translation.x,
                          CGRectGetHeight(self.initialRect));
        
        if (self.keepingAspectRatio) {
            rect = [self constrainedRectWithRectBasisOfWidth:rect aspectRatio:self.fixedAspectRatio];
        }
    } else if (resizeControlView == self.bottomEdgeView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect),
                          CGRectGetMinY(self.initialRect),
                          CGRectGetWidth(self.initialRect),
                          CGRectGetHeight(self.initialRect) + resizeControlView.translation.y);
        
        if (self.keepingAspectRatio) {
            rect = [self constrainedRectWithRectBasisOfHeight:rect aspectRatio:self.fixedAspectRatio];
        }
    } else if (resizeControlView == self.rightEdgeView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect),
                          CGRectGetMinY(self.initialRect),
                          CGRectGetWidth(self.initialRect) + resizeControlView.translation.x,
                          CGRectGetHeight(self.initialRect));
        
        if (self.keepingAspectRatio) {
            rect = [self constrainedRectWithRectBasisOfWidth:rect aspectRatio:self.fixedAspectRatio];
        }
    } else if (resizeControlView == self.topLeftCornerView) {
        //最新的rect = (原始的x坐标+左上边角的x偏移量，原始的y坐标+左上边角的y偏移量，原始的宽度-左上边角的x偏移量，原始的高度-左上边角的y偏移量)
        rect = CGRectMake(CGRectGetMinX(self.initialRect) + resizeControlView.translation.x,
                          CGRectGetMinY(self.initialRect) + resizeControlView.translation.y,
                          CGRectGetWidth(self.initialRect) - resizeControlView.translation.x,
                          CGRectGetHeight(self.initialRect) - resizeControlView.translation.y);
        
        if (self.keepingAspectRatio) {
            CGRect constrainedRect;
            if (fabsf(resizeControlView.translation.x) < fabsf(resizeControlView.translation.y)) {
                constrainedRect = [self constrainedRectWithRectBasisOfHeight:rect aspectRatio:self.fixedAspectRatio];
            } else {
                constrainedRect = [self constrainedRectWithRectBasisOfWidth:rect aspectRatio:self.fixedAspectRatio];
            }
            constrainedRect.origin.x -= CGRectGetWidth(constrainedRect) - CGRectGetWidth(rect);
            constrainedRect.origin.y -= CGRectGetHeight(constrainedRect) - CGRectGetHeight(rect);
            rect = constrainedRect;
        }
    } else if (resizeControlView == self.topRightCornerView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect),
                          CGRectGetMinY(self.initialRect) + resizeControlView.translation.y,
                          CGRectGetWidth(self.initialRect) + resizeControlView.translation.x,
                          CGRectGetHeight(self.initialRect) - resizeControlView.translation.y);
        
        if (self.keepingAspectRatio) {
            if (fabsf(resizeControlView.translation.x) < fabsf(resizeControlView.translation.y)) {
                rect = [self constrainedRectWithRectBasisOfHeight:rect aspectRatio:self.fixedAspectRatio];
            } else {
                rect = [self constrainedRectWithRectBasisOfWidth:rect aspectRatio:self.fixedAspectRatio];
            }
        }
    } else if (resizeControlView == self.bottomLeftCornerView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect) + resizeControlView.translation.x,
                          CGRectGetMinY(self.initialRect),
                          CGRectGetWidth(self.initialRect) - resizeControlView.translation.x,
                          CGRectGetHeight(self.initialRect) + resizeControlView.translation.y);
        
        if (self.keepingAspectRatio) {
            CGRect constrainedRect;
            if (fabsf(resizeControlView.translation.x) < fabsf(resizeControlView.translation.y)) {
                constrainedRect = [self constrainedRectWithRectBasisOfHeight:rect aspectRatio:self.fixedAspectRatio];
            } else {
                constrainedRect = [self constrainedRectWithRectBasisOfWidth:rect aspectRatio:self.fixedAspectRatio];
            }
            constrainedRect.origin.x -= CGRectGetWidth(constrainedRect) - CGRectGetWidth(rect);
            rect = constrainedRect;
        }
    } else if (resizeControlView == self.bottomRightCornerView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect),
                          CGRectGetMinY(self.initialRect),
                          CGRectGetWidth(self.initialRect) + resizeControlView.translation.x,
                          CGRectGetHeight(self.initialRect) + resizeControlView.translation.y);
        
        if (self.keepingAspectRatio) {
            if (fabsf(resizeControlView.translation.x) < fabsf(resizeControlView.translation.y)) {
                rect = [self constrainedRectWithRectBasisOfHeight:rect aspectRatio:self.fixedAspectRatio];
            } else {
                rect = [self constrainedRectWithRectBasisOfWidth:rect aspectRatio:self.fixedAspectRatio];
            }
        }
    }
    //最小宽度
    CGFloat minWidth = CGRectGetWidth(self.leftEdgeView.bounds) + CGRectGetWidth(self.rightEdgeView.bounds);
    if (CGRectGetWidth(rect) < minWidth) {
        rect.origin.x = CGRectGetMaxX(self.frame) - minWidth;
        rect.size.width = minWidth;
    }
    //最小高度
    CGFloat minHeight = CGRectGetHeight(self.topEdgeView.bounds) + CGRectGetHeight(self.bottomEdgeView.bounds);
    if (CGRectGetHeight(rect) < minHeight) {
        rect.origin.y = CGRectGetMaxY(self.frame) - minHeight;
        rect.size.height = minHeight;
    }

    if (self.fixedAspectRatio) {
        CGRect constrainedRect = rect;

        if (CGRectGetWidth(rect) < minWidth) {
            constrainedRect.size.width = rect.size.height * (minWidth / rect.size.width);
        }

        if (CGRectGetHeight(rect) < minHeight) {
            constrainedRect.size.height = rect.size.width * (minHeight / rect.size.height);
        }

        rect = constrainedRect;
    }
    
    return rect;
}

- (CGRect)constrainedRectWithRectBasisOfWidth:(CGRect)rect aspectRatio:(CGFloat)aspectRatio
{
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    if (width < height) {
        height = width / self.fixedAspectRatio;
    } else {
        height = width * self.fixedAspectRatio;
    }
    rect.size = CGSizeMake(width, height);
    
    return rect;
}

- (CGRect)constrainedRectWithRectBasisOfHeight:(CGRect)rect aspectRatio:(CGFloat)aspectRatio
{
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    if (width < height) {
        width = height * self.fixedAspectRatio;
    } else {
        width = height / self.fixedAspectRatio;
    }
    rect.size = CGSizeMake(width, height);
    
    return rect;
}

@end
