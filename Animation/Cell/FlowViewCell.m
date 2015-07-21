//
//  FlowViewCell.m
//  点信宝
//
//  Created by 朱大茂 on 15/6/9.
//  Copyright (c) 2015年 Axon.Tec. All rights reserved.
//

#import "FlowViewCell.h"
#import "CollectionViewCell.h"

#define KResueIndentify  @"KResueIndentify"

@implementation FlowViewCell

- (void)awakeFromNib {
    [self.cellCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil]forCellWithReuseIdentifier:KResueIndentify];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setDataArry:(NSArray *)dataArry{
    if (_dataArry != dataArry) {
        _dataArry = dataArry;
        [self.cellCollectionView reloadData];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArry? _dataArry.count:0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:KResueIndentify forIndexPath:indexPath];
    
    NSDictionary * cellInfo = _dataArry[indexPath.row];
    
#warning left for Model
    
    cell.layer.cornerRadius = 5.0f;
    cell.layer.masksToBounds = YES;
    
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(71, 62);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * cellInfo = _dataArry[indexPath.row];
    
    if (_block ) {
        _block(cellInfo);
    }
}

@end
