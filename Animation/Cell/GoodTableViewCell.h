//
//  GoodTableViewCell.h
//  点信宝
//
//  Created by 朱大茂 on 15/6/9.
//  Copyright (c) 2015年 Axon.Tec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *goodImage;
@property (strong, nonatomic) IBOutlet UILabel *goodDetail;
@property (strong, nonatomic) IBOutlet UILabel *goodPrice;
@property (strong, nonatomic) IBOutlet UIImageView *goodIcon;

@property (strong, nonatomic) IBOutlet UILabel *goodSaleNum;
@end
