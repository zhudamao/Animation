//
//  BannerCell.m
//  点信宝
//
//  Created by 朱大茂 on 15/6/9.
//  Copyright (c) 2015年 Axon.Tec. All rights reserved.
//

#import "BannerCell.h"

@implementation BannerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - reWrite the setter method
- (void)setBannerInfo:(NSDictionary *)bannerInfo{
    if (_bannerInfo != bannerInfo){
        if (_bannerView == nil) {
            NSArray * info = [bannerInfo objectForKey:@"info"];
            NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:info.count+2];
            
            if (info.count > 1) {
                for (int i = 0; i < info.count; i++) {
                    NSDictionary * item = info[i];
                    SGFocusImageItem * imageItem = [[SGFocusImageItem alloc]initWithDict:item tag:2015+i ];
                    [itemArray addObject:imageItem];
                }
                
                [itemArray insertObject:itemArray[info.count -1] atIndex:0];
                [itemArray addObject:itemArray[0]];
            }
            
            _bannerView = [[SGFocusImageFrame alloc]initWithFrame:self.bounds delegate:self imageItems:itemArray];
            [_bannerView scrollToIndex:2];
            [self.contentView addSubview:_bannerView];
        }
        [self setNeedsLayout];
        _bannerInfo = bannerInfo;
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - SGFocusImageFrameDelegate
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item{
    

}

@end
