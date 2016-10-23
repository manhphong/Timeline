//
//  TimeLineView.h
//  CalendarApp
//
//  Created by Jiang Hao on 2/7/2016.
//  Copyright © 2016 shampire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTSImageViewController.h"

@interface TimeFrame : NSObject

typedef enum {
    Pending,
    Rejected,
    Accepted,
} EventStatus;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) EventStatus status;

- (id)initWithText:(NSString *)text dateTime:(NSDate *)date avatar:(UIImage *)image status:(EventStatus)status;

@end

@interface TimeLineView : UIView

typedef enum {
    Circle,
    Hexagon,
    Diamond,
    DiamondSlash,
    Carrot,
    Arrow
} BulletType;

@property (nonatomic, strong) NSMutableArray<TimeFrame *> *timeFrames;
@property (nonatomic, strong) UIColor *lineColor, *titleLabelColor, *detailLabelColor;
@property (nonatomic, assign) BulletType bulletType;
@property (nonatomic, assign) BOOL showBulletOnRight;
@property (nonatomic, strong) JTSImageViewController *imageViewer;

- (id)initWithBulletType:(BulletType)bulletType timeFrames:(NSArray<TimeFrame *> *)timeFrames;

@end

@interface UIBezierPath(BulletType)

- (UIBezierPath *)hexagonOfSize:(CGSize)size;

@end
