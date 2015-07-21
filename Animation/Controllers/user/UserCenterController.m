//
//  UserCenterController.m
//  点信宝
//
//  Created by 朱大茂 on 15/6/10.
//  Copyright (c) 2015年 Axon.Tec. All rights reserved.
//

#import "UserCenterController.h"

@interface UserCenterController ()
{
    NSArray * _menuTitles;
}
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户中心";
    
    [self _initDataSource];
    [self _initSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Method
- (void)_initDataSource{
    if (!_menuTitles) {
        _menuTitles = @[@"手机认证",@"实名认证",@"收货地址",@"我的订单",@"优惠红包",@"心愿盒子",@"我的收藏"];
    }
}

- (void) _initSubView{

    self.tableView.scrollEnabled = NO;
    
//    if (IOS_VERSION > 7.0) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
}


#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 0;
    
    switch (section) {
        case 0:
            rowNum = 3;
            break;
        case 1:
            rowNum = 4;
            break;
        default:
            break;
    }
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indenfify = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indenfify];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenfify];
    }
    
    cell.textLabel.text = [@(indexPath.row) stringValue];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

@end
