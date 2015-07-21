//
//  LoadingView.m
//  TheMovieDB
//
//  Created by 朱大茂 on 15/6/10.
//  Copyright (c) 2015年 iKode Ltd. All rights reserved.
//

#import "LoadingView.h"

#define KActivityWith 56.0f

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha           = 0.f;
        
        _indicator = [[KMActivityIndicator alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - KActivityWith)/2.0, (SCREEN_HEIGHT - KActivityWith)/2.0, KActivityWith, KActivityWith )] ;
        
        _indicator.backgroundColor = [UIColor clearColor];
        [self addSubview:_indicator];
        
        
        _loadIngLable = [[UILabel alloc]initWithFrame:CGRectMake(20, _indicator.bottom + 8, SCREEN_WIDTH - 40.0, 20)];
        _loadIngLable.textAlignment = NSTextAlignmentCenter;
        _loadIngLable.font = [UIFont fontWithName:@"GillSans-Light" size:18];
        _loadIngLable.backgroundColor = [UIColor clearColor];
        _loadIngLable.textColor = [UIColor whiteColor];
        [self addSubview:_loadIngLable];
        
        
    }
    return self;
}


- (void)startAnimation
{
    [UIView animateWithDuration:1.f animations:^{
        self.alpha = 0.75f;
    }];
    
    _loadIngLable.text = @"Loading";
    [_indicator startAnimating];

}

- (void)showErrorMessage:(NSString *)msg{

    _loadIngLable.text = msg;
    
    [self performSelector:@selector(hideSelf) withObject:nil afterDelay:1];
}

- (void)hideSelf{
    [UIView animateWithDuration:0.75f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_indicator stopAnimating];
        [self removeFromSuperview];
    }];
}

@end
