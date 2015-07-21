//
//  FlowViewCell.h
//  点信宝
//
//  Created by 朱大茂 on 15/6/9.
//  Copyright (c) 2015年 Axon.Tec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerCell.h"

@interface FlowViewCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *cellCollectionView;

@property (nonatomic,retain) NSArray * dataArry;
@property (nonatomic,copy)BannenBlock block;

@end
