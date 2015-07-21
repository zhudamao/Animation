//
//  MarginView.m
//  Full
//
//  Created by zhudm on 15/6/7.
//  Copyright (c) 2015年 axon. All rights reserved.
//

#import "MarginView.h"
#import "CATextLayer+NumberJump.h"

#define KShowFadeHight 62.5f
#define KCircleRadius  173.0f
#define KMaxPinValue   10000.0f

@implementation MarginView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _state = MarginStateFull;
        [self _initFadeView];
        [self createCircle];
    }
    return self;
}

- (void)createCircle{
    if (_circle) {
        return;
    }
// the circle can change
    CAGradientLayer * gradLayer = [CAGradientLayer layer];
    gradLayer.frame = CGRectMake((SCREEN_WIDTH - KCircleRadius - 10.0)/2.0, NavigationBar_HEIGHT + 4, KCircleRadius+10.0f, KCircleRadius);
    gradLayer.colors = @[(__bridge id)[UIColor greenColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor];
    gradLayer.startPoint = CGPointMake(0, 1);
    gradLayer.endPoint = CGPointMake(1, 0);
    gradLayer.locations = @[@0.2f,@0.5];
    
    _circle = [CAShapeLayer layer];
    _circle.strokeColor = [UIColor whiteColor].CGColor;
    _circle.lineWidth = 5.0f;
    _circle.fillMode = kCAFillModeForwards;
    _circle.fillColor = nil;
    
    gradLayer.mask = _circle;
    
    //gradLayer.backgroundColor = [UIColor orangeColor].CGColor;
// the white cicle in back
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(gradLayer.bounds.size.width/2.0, KCircleRadius/2.0 + 5) radius:KCircleRadius/2.0 startAngle:M_PI/4*3 endAngle:2*M_PI+M_PI_4 clockwise:YES];
    CAShapeLayer * circleWhite = [CAShapeLayer layer];
    circleWhite.strokeColor = [UIColor whiteColor].CGColor;
    circleWhite.fillColor = [UIColor clearColor].CGColor;
    circleWhite.lineWidth = 6.0f;
    circleWhite.path = path.CGPath;
    
    circleWhite.position = CGPointMake((CGRectGetWidth(self.frame) - KCircleRadius -10 )/2.0 , (KCircleRadius -36.0)/2.0  );
    
    [self.layer addSublayer:circleWhite];
    [self.layer addSublayer:gradLayer];
// can use credit big Lable;
    if (_textLayer == nil) {
        _textLayer = [CATextLayer layer];
        _textLayer.frame = CGRectMake((CGRectGetWidth(self.frame) - KCircleRadius )/2.0, 135, KCircleRadius, 60.0f);
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        _textLayer.font = (__bridge CFStringRef)[UIFont systemFontOfSize:40].fontName;
        _textLayer.fontSize = 58.0f;
        _textLayer.backgroundColor = [UIColor clearColor].CGColor;
        _textLayer.alignmentMode = kCAAlignmentCenter;
        
        _textLayer.string = @"----";
        
        [self.layer addSublayer:_textLayer];
    }
// the text alay use
    CATextLayer * textUseLayer = [CATextLayer layer];
    textUseLayer.frame =  CGRectMake((CGRectGetWidth(self.frame) - KCircleRadius/2.0 )/2.0, 115, KCircleRadius/2.0, 30.0f);
    textUseLayer.backgroundColor = [UIColor clearColor].CGColor;
    textUseLayer.font = (__bridge CFStringRef)[UIFont systemFontOfSize:18.0].fontName;
    textUseLayer.fontSize = 18.0f;
    textUseLayer.alignmentMode = kCAAlignmentCenter;
    textUseLayer.foregroundColor = [UIColor whiteColor].CGColor;
    textUseLayer.opacity = 0.5f;
    textUseLayer.contentsScale = [UIScreen mainScreen].scale;
    textUseLayer.string = @"可用额度";
    [self.layer addSublayer:textUseLayer];
}

- (void)_initFadeView{
    UIView * fadeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), KShowFadeHight)];
    fadeView.backgroundColor = [UIColor orangeColor];
    fadeView.layer.shadowColor = [UIColor blackColor].CGColor;
    fadeView.layer.shadowOffset = CGSizeMake(0, -1);
    fadeView.layer.shadowOpacity = 0.7f;
    fadeView.layer.shadowRadius = 1.8f;
    fadeView.tag = 2048;
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
    lineLayer.opacity = 0.5f;
    lineLayer.frame = CGRectMake(SCREEN_WIDTH/2.0, 0, 0.5, KShowFadeHight);
    [fadeView.layer addSublayer:lineLayer];
    
    for (int i = 0 ; i < 2 ; i++) {
        UIButton * fadeButton = [[UIButton alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH /2.0, 2, SCREEN_WIDTH/2.0, KShowFadeHight)];
        [fadeButton addTarget:self action:@selector(fakeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        fadeButton.tag = 2000 + i;
        fadeButton.backgroundColor = [UIColor clearColor];
        [fadeView addSubview:fadeButton];
        
        
        UILabel * bigLable = [[UILabel alloc]initWithFrame:fadeButton.frame];;
        bigLable.textAlignment = NSTextAlignmentCenter;
        bigLable.lineBreakMode = NSLineBreakByWordWrapping;
        bigLable.numberOfLines = 0;
        [fadeView insertSubview:bigLable belowSubview:fadeButton];
        
        bigLable.tag = 200 + i;
    }
    [self addSubview:fadeView];
    [self setAttriButeLable:@1234 withLableFalg:LeftLalbe];
    [self setAttriButeLable:@5678 withLableFalg:RightLable];
}


#pragma mark - Action
- (void)fakeButtonPress:(UIButton *)button{
    if (button.tag == 2000) {
        if (_delegate && [_delegate respondsToSelector:@selector(promteTotal:)]) {
            [_delegate promteTotal:button];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(repayMent:)]) {
            [_delegate repayMent:button];
        }
    }
}


- (void)setAttriButeLable:(NSNumber *)num withLableFalg:(LableFlag)flag{
    UIView * fadeView = [self viewWithTag:2048];
    
    do {
        if (fadeView == nil) {
            break;
        }
            
        UILabel * lable = (UILabel *)[fadeView viewWithTag:flag];
        
        if ([lable isKindOfClass:[UILabel class]]) {
            NSUInteger length =  num.stringValue.length;
            if (!num.integerValue) {
                
                NSString * tempString = @"总额度: ----\n提升额度";
                
                if (flag == RightLable) {
                    tempString = @"待还款: ----\n立即还款";
                }
                
                NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:tempString];
                
                NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor whiteColor],NSKernAttributeName:@1};
                [string setAttributes:attribute range:NSMakeRange(0, 5)];
                
                attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor yellowColor]};
                [string setAttributes:attribute range:NSMakeRange(5, 4)];
                
                attribute = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor],NSKernAttributeName:@1.3};
                [string setAttributes:attribute range:NSMakeRange(9, 5)];
                
                lable.attributedText = string;
                
                break;
            }else{
                NSString * tempString = [NSString stringWithFormat:@"总额度: %@\n提升额度",num];
                
                if (flag == RightLable) {
                    tempString = [NSString stringWithFormat:@"待还款: %@\n立即还款",num];
                }
                
                NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:tempString];
                
                NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor whiteColor],NSKernAttributeName:@1};
                [string setAttributes:attribute range:NSMakeRange(0, 5)];
                
                attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor yellowColor]};
                [string setAttributes:attribute range:NSMakeRange(5, length)];
                
                attribute = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor],NSKernAttributeName:@1.3};
                [string setAttributes:attribute range:NSMakeRange(5 + length, 5)];
                
                lable.attributedText = string;
            }
        }
    } while (0);
}


- (void)doWhenViewScroll:(BOOL)scroll{
    UIView * fadeView = [self viewWithTag:2048];
    
    if (!fadeView) {
        return;
    }
    if (scroll) {
        if (fadeView.top == CGRectGetHeight(self.bounds)) {
            return;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            fadeView.top = CGRectGetHeight(self.bounds);
        }];
    }else{
        if (fadeView.top == CGRectGetHeight(self.bounds) - KShowFadeHight) {
            return;
        }
        
        if (self.state == MarginStateLittle || self.dragging) {
            return;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            fadeView.top = CGRectGetHeight(self.bounds) - KShowFadeHight;
        }];
    }

}

- (void)setAvailbleCredit:(NSNumber *)pinValue forPullDown:(BOOL)flag
{
    CGFloat value = pinValue.floatValue/KMaxPinValue ;
    
    if (value < 0) {
        value = 0.0f;
    }else if (value > 1.0){
        value = 1.0f;
    }
    
    if (!flag) {
        _currentPinValue = pinValue.floatValue;
    }
    
    _textLayer.string = [NSString stringWithFormat:@"%ld",(long)pinValue.integerValue];
    if (flag && _currentPinValue < pinValue.floatValue ) {
        return;
    }
    
    CGFloat endAngel = (M_PI/4.0*3+1.5*M_PI*value) < (M_PI/4.0*3)? (M_PI/4.0*3):(M_PI/4.0*3+1.5*M_PI*value) ;
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter: CGPointMake((KCircleRadius+10.0f)/2.0, KCircleRadius/2.0 + 5) radius:KCircleRadius/2.0 startAngle:M_PI/4.0*3 endAngle:endAngel clockwise:YES];
    _circle.path = path.CGPath;
}


- (void)circleDoAnimation{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.3;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    pathAnimation.fromValue = @(1);
    pathAnimation.toValue = @(0);
    pathAnimation.autoreverses = YES;
    pathAnimation.delegate = self;
    
    [_textLayer jumpNumberWithDuration:0.7 fromNumber:0 toNumber:_currentPinValue];
    [_circle addAnimation:pathAnimation forKey:@"strokeEnd"];
}

#pragma mark - AnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self doWhenViewScroll:NO];
}

@end
