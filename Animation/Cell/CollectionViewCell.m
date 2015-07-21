//
//  CollectionViewCell.m
//  点信宝
//
//  Created by 朱大茂 on 15/6/9.
//  Copyright (c) 2015年 Axon.Tec. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    self.adLable.layer.cornerRadius = 5.0f;
    self.adLable.layer.masksToBounds = YES;
}

@end
