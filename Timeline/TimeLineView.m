//
//  TimeLineView.m
//  CalendarApp
//
//  Created by Jiang Hao on 2/7/2016.
//  Copyright © 2016 shampire. All rights reserved.
//

#import "TimeLineView.h"
#import <AVFoundation/AVFoundation.h>

@implementation TimeLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupContent];
    }
    return self;
}

- (id)initWithBulletType:(BulletType)bulletType timeFrames:(NSArray<TimeFrame *> *)timeFrames
{
    self.lineColor = [UIColor lightGrayColor];
    self.titleLabelColor = [UIColor colorWithRed:0/255 green:180/255 blue:160/255 alpha:1];
    self.detailLabelColor = [UIColor colorWithRed:110/255 green:110/255 blue:110/255 alpha:1];
    self.bulletType = Diamond;
    
    if (self)
    {
        self.timeFrames = [timeFrames mutableCopy];
        self.bulletType = bulletType;
        self = [super initWithFrame:CGRectZero];
        [self setTranslatesAutoresizingMaskIntoConstraints:false];
        [self setupContent];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupContent
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    UIView *guideView = [UIView new];
    [guideView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self addSubview:guideView];
    
    [self addConstraints:@[
                         [NSLayoutConstraint constraintWithItem:guideView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:24],
                         [NSLayoutConstraint constraintWithItem:guideView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                         [NSLayoutConstraint constraintWithItem:guideView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],
                         [NSLayoutConstraint constraintWithItem:guideView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0]]];
    
    NSInteger i = 0;
    
    UIView *viewFromAbove = guideView;
    
    for (TimeFrame *timeFrame in self.timeFrames) {
        UIView *view = [self blockForTimeFrame:timeFrame imageTag:i];
        [self addSubview:view];
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewFromAbove attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                               [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:viewFromAbove attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],
         ]];
        if (self.showBulletOnRight) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:viewFromAbove attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        } else {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:viewFromAbove attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        }
        viewFromAbove = view;
        i++;
    }
    
    CGFloat extraSpace = 200;
    
    UIView *line = [[UIView alloc] init];
    [line setTranslatesAutoresizingMaskIntoConstraints:false];
    [line setBackgroundColor:self.lineColor];
    [self addSubview:line];
    [self sendSubviewToBack:line];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1],
                           [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewFromAbove attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                           [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:extraSpace]]];
    
    if (self.showBulletOnRight) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-16.5]];
    } else {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:16.5]];
    }
    [self addConstraint:[NSLayoutConstraint constraintWithItem:viewFromAbove attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (UIView *)bulletView:(CGSize)size BulletType:(BulletType)bulletType
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (bulletType) {
        case Circle:
            path = [path hexagonOfSize:size];
            break;
        case DiamondSlash:
            path = [path hexagonOfSize:size];
        case Hexagon:
            path = [path hexagonOfSize:size];
        case Carrot:
            path = [path hexagonOfSize:size];
        case Arrow:
            path = [path hexagonOfSize:size];
        default:
            break;
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = self.lineColor.CGColor;
    shapeLayer.path = path.CGPath;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [view setTranslatesAutoresizingMaskIntoConstraints:false];
    [view.layer addSublayer:shapeLayer];
    return view;
}

- (UIView *)blockForTimeFrame:(TimeFrame *)timeFrame imageTag:(NSInteger)imageTag
{
    UIView *view = [UIView new];
    [view setTranslatesAutoresizingMaskIntoConstraints:false];
    
    // == Bullet ==
    
    CGSize size = CGSizeMake(14, 14);
    UIView *bullet = [self bulletView:size BulletType:self.bulletType];
    [view addSubview:bullet];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:bullet attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    if (self.showBulletOnRight) {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:bullet attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-24]];
    } else {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:bullet attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
    }
    
    // == Tile(Date) ==
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel setAllowsDefaultTighteningForTruncation:false];
    [titleLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    NSString *dateString = [NSString stringWithFormat:@"%@", timeFrame.date];
    NSLog(@"dateString : %@", dateString);
    [titleLabel setText:dateString];
    [titleLabel setNumberOfLines:0];
    [titleLabel.layer setMasksToBounds:false];
    [titleLabel sizeToFit];
    [view addSubview:titleLabel];
    [view addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-40],
                           [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-5],
                           ]];
    if (self.showBulletOnRight) {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-40]];
        titleLabel.textAlignment = NSTextAlignmentRight;
    } else {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:40]];
        titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    // == Text ==
    
    UILabel *textLabel = [UILabel new];
    [textLabel setAllowsDefaultTighteningForTruncation:false];
    [textLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];
    [textLabel setText:timeFrame.text];
    [textLabel setTextColor:self.detailLabelColor];
    [textLabel setNumberOfLines:0];
    [textLabel.layer setMasksToBounds:false];
    [textLabel sizeToFit];
    [view addSubview:textLabel];
    [view addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-40],
                           [NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5],
                           ]];
    if (self.showBulletOnRight) {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-40]];
        textLabel.textAlignment = NSTextAlignmentRight;
    } else {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:40]];
        textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    // == Image ==
    
    if (timeFrame.image) {
        UIView *backgroundViewForImage = [UIView new];
        [backgroundViewForImage setTranslatesAutoresizingMaskIntoConstraints:false];
        [backgroundViewForImage setBackgroundColor:[UIColor blackColor]];
        [backgroundViewForImage.layer setCornerRadius:10];
        [view addSubview:backgroundViewForImage];
        [view addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:backgroundViewForImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-60],
                               [NSLayoutConstraint constraintWithItem:backgroundViewForImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:130],
                               [NSLayoutConstraint constraintWithItem:backgroundViewForImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5],
                               [NSLayoutConstraint constraintWithItem:backgroundViewForImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]
                               ]];
        
        if (self.showBulletOnRight) {
            [view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundViewForImage attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-40]];
        } else {
            [view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundViewForImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:40]];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:timeFrame.image];
        [imageView.layer setCornerRadius:10];
        [imageView setTranslatesAutoresizingMaskIntoConstraints:false];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [view addSubview:imageView];
        [imageView setTag:imageTag];
        [view addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:backgroundViewForImage attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                               [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:backgroundViewForImage attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                               [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backgroundViewForImage attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                               [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:backgroundViewForImage attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
                               ]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTranslatesAutoresizingMaskIntoConstraints:false];
        [button setBackgroundColor:[UIColor clearColor]];
        button.tag = imageTag;
        [button addTarget:self action:@selector(tapImage:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [view addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-60],
                               [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:130],
                               [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]
                               ]];
        if (self.showBulletOnRight) {
            [view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-40]];
        } else {
            [view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:40]];
        }
    } else {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-40]];
    }
    
    //  == draw the line between the bullets
    UIView *line = [UIView new];
    [line setTranslatesAutoresizingMaskIntoConstraints:false];
    [line setBackgroundColor:self.lineColor];
    [view addSubview:line];
    [self sendSubviewToBack:line];
    [view addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:1],
                           [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:14],
                           [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-14]
                           ]];
    if (self.showBulletOnRight) {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-16.5]];
    } else {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:16.5]];
    }
    
    return view;
}

- (void)tapImage:(UIButton *)button
{
    UIImageView *imageView;
    for (UIView *v in self.subviews) {
        for (UIView *view in v.subviews) {
            if (view.tag == button.tag && [view isKindOfClass:[UIImageView class]]) {
                imageView = (UIImageView *)view;
            }
        }
    }
    
    UIImage *image = imageView.image;
    
    if (image) {
        JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
        imageInfo.image = image;
        
        CGRect imageFrame = AVMakeRectWithAspectRatioInsideRect(image.size, imageView.bounds);
        imageInfo.referenceRect = [self convertRect:imageFrame toView:imageView];
        imageInfo.referenceView = self;
        self.imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
        if (self.imageViewer) {
            [self.imageViewer showFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController transition:JTSImageViewControllerTransition_FromOriginalPosition];
        }
    }
}

@end


@implementation UIBezierPath(BulletType)
    
- (UIBezierPath *)hexagonOfSize:(CGSize)size {
    [self moveToPoint:CGPointMake(size.width / 2, 0)];
    [self addLineToPoint:CGPointMake(size.width, size.height / 3)];
    [self addLineToPoint:CGPointMake(size.width, size.height * 2 / 3)];
    [self addLineToPoint:CGPointMake(size.width / 2, size.height)];
    [self addLineToPoint:CGPointMake(0, size.height * 2 / 3)];
    [self addLineToPoint:CGPointMake(0, size.height / 3)];
    [self closePath];
    return self;
}
    
//    convenience init(diamondOfSize size: CGSize) {
//        self.init()
//        moveToPoint(CGPoint(x: size.width / 2, y: 0))
//        addLineToPoint(CGPoint(x: size.width, y: size.height / 2))
//        addLineToPoint(CGPoint(x: size.width / 2, y: size.height))
//        addLineToPoint(CGPoint(x: 0, y: size.width / 2))
//        closePath()
//    }
//    
//    convenience init(diamondSlashOfSize size: CGSize) {
//        self.init(diamondOfSize: size)
//        moveToPoint(CGPoint(x: 0, y: size.height/2))
//        addLineToPoint(CGPoint(x: size.width, y: size.height / 2))
//    }
//    
//    convenience init(ovalOfSize size: CGSize) {
//        self.init(ovalInRect: CGRect(origin: CGPointZero, size: size))
//    }
//    
//    convenience init(carrotOfSize size: CGSize) {
//        self.init()
//        moveToPoint(CGPoint(x: size.width/2, y: 0))
//        addLineToPoint(CGPoint(x: size.width, y: size.height / 2))
//        addLineToPoint(CGPoint(x: size.width / 2, y: size.height))
//    }
//    
//    convenience init(arrowOfSize size: CGSize) {
//        self.init(carrotOfSize: size)
//        moveToPoint(CGPoint(x: 0, y: size.height/2))
//        addLineToPoint(CGPoint(x: size.width, y: size.height / 2))
//    }


@end

@implementation TimeFrame

- (id)initWithText:(NSString *)text date:(NSDate *)date image:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        self.text = text;
        self.date = date;
        self.image = image;
    }
    return self;
}

@end
