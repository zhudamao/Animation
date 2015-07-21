//
//  MarginView.h
//  Full
//
//  Created by zhudm on 15/6/7.
//  Copyright (c) 2015年 axon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LeftLalbe = 200,
    RightLable =201,
}LableFlag;

typedef NS_ENUM(NSUInteger, MarginState) {
    MarginStateUnkown,
    MarginStateFull,
    MarginStateMid,
    MarginStateLittle,
};

@protocol BannerButtonDelegate <NSObject>
@optional
- (void)promteTotal:(UIButton *)button;
- (void)repayMent:(UIButton *)button;
@end


@interface MarginView : UIView
{
    CAShapeLayer * _circle;
    CATextLayer *  _textLayer;
}
@property (nonatomic,assign) MarginState state;

@property (nonatomic,assign) id <BannerButtonDelegate> delegate;
@property (nonatomic,assign) BOOL dragging;
@property (nonatomic,assign,readonly) CGFloat currentPinValue;

- (void)setAttriButeLable:(NSNumber *)num withLableFalg:(LableFlag)flag;
- (void)doWhenViewScroll:(BOOL)scroll;
- (void)circleDoAnimation;
- (void)setAvailbleCredit:(NSNumber *)pinValue forPullDown:(BOOL)flag;
@end
