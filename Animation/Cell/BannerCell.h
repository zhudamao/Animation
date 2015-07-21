//
//  BannerCell.h
//  点信宝
//
//  Created by 朱大茂 on 15/6/9.
//  Copyright (c) 2015年 Axon.Tec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

typedef void (^BannenBlock) (NSDictionary *);

@interface BannerCell : UITableViewCell <SGFocusImageFrameDelegate>
{
    SGFocusImageFrame * _bannerView;
}

@property (nonatomic,retain)NSDictionary * bannerInfo;
@property (nonatomic,copy)BannenBlock  block;


@end
