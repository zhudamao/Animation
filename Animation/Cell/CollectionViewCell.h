//
//  CollectionViewCell.h
//  点信宝
//
//  Created by 朱大茂 on 15/6/9.
//  Copyright (c) 2015年 Axon.Tec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *adLable;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;

@end
