//
//  LoadingView.h
//  TheMovieDB
//
//  Created by 朱大茂 on 15/6/10.
//  Copyright (c) 2015年 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMActivityIndicator.h"

@interface LoadingView : UIView
{
    KMActivityIndicator * _indicator;
    UILabel * _loadIngLable;
}

- (void)startAnimation;
- (void)showErrorMessage:(NSString *)msg;
- (void)hideSelf;

@end
