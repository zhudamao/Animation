//
//  ViewController.m
//  Full
//
//  Created by zhudm on 15/6/7.
//  Copyright (c) 2015年 axon. All rights reserved.
//

#import "RootController.h"
#import "MarginView.h"
#import "LoadingView.h"
#import "UserCenterController.h"


#define KDefaultHeadHight 298.0f
#define KSuspensionHight  33.5f

@interface ViewController ()
{
    CGFloat beginY;
    MarginView * _marginView;
    UIRefreshControl * _refreshControl;
    LoadingView * _loadView;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.alwaysBounceVertical = YES;

    [self setUpSubViews];
    [self setUpFakeNav];
    [self setupTableView];
    //
    
    if (_loadView == nil) {
        _loadView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_loadView];
        [_loadView startAnimation];
    }
    
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:5.0];
}

- (void)hideLoadingView{
    [_loadView hideSelf];
    _loadView = nil;
    [_marginView setAvailbleCredit:@5678 forPullDown:NO];
    [_marginView circleDoAnimation];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_marginView doWhenViewScroll:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}



// marginView and the moving Nav View && suspendView
- (void)setUpSubViews{
    if (_marginView == nil) {
        _marginView = [[MarginView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KDefaultHeadHight)];
        
        _marginView.backgroundColor = [UIColor darkGrayColor];
        _marginView.clipsToBounds = YES;
        self.tableView.tableHeaderView = _marginView;
    }
    
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0,  -NavigationBar_HEIGHT, SCREEN_WIDTH,  NavigationBar_HEIGHT)];
    navView.backgroundColor = [UIColor orangeColor];
    navView.tag = 2015;
    
    [self.view addSubview:navView];
    
    UIView * suspendView = [[UIView alloc]initWithFrame:CGRectMake(0,  NavigationBar_HEIGHT, SCREEN_WIDTH, KSuspensionHight)];
    suspendView.alpha = 0.0f;
    suspendView.backgroundColor = [UIColor darkGrayColor];
    suspendView.tag = 2016;
    [self.view addSubview:suspendView];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showFullMargin:)];
    [suspendView addGestureRecognizer:tap];
}

// set refesh View
- (void)setupTableView
{
    if (!_refreshControl)
    {
        _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, 44)];
        [_refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:_refreshControl];
    }
}

// the really Nav View
- (void)setUpFakeNav{
    UIView * fakeNav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  NavigationBar_HEIGHT)];
    fakeNav.backgroundColor = [UIColor clearColor];
    
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 44)];
    lable.font = [UIFont boldSystemFontOfSize:22.0f];
    
    lable.text = @"点信宝";
    
    CGPoint point = fakeNav.center;
    point.y += 10;
    lable.center = point;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    UIButton * userButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    userButton.showsTouchWhenHighlighted = YES;
    [userButton addTarget:self action:@selector(jumpToUserCenter:) forControlEvents:UIControlEventTouchUpInside];
    
    userButton.center = CGPointMake(SCREEN_WIDTH - 30 , NavigationBar_HEIGHT/2.0 + 10);
    
    
    [fakeNav addSubview:userButton];
    [fakeNav addSubview:lable];
    
    [self.view addSubview:fakeNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showFullMargin:(UITapGestureRecognizer *)tap{
    if (_marginView.state == MarginStateLittle) {
        [self.tableView setContentOffset:CGPointZero animated:YES];
        _marginView.state = MarginStateFull;
        [_marginView circleDoAnimation];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;

    switch (section) {
        case 0:
            rowNum = 2;
            break;
        case 1:
            rowNum = 4;
        default:
            break;
    }
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * indentify = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }
    
    cell.textLabel.text = [@(indexPath.row) stringValue];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHight =  100.0f;
    
    switch (indexPath.section) {
        case 0:
            {
                if (indexPath.row == 0) {
                    rowHight = 100.0f;
                }else{
                    rowHight = 110.0f;
                }
            }
            break;
        case 1:
            rowHight = 150.0f;
            break;
        default:
            break;
    }
    return rowHight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }

    UILabel * sectinLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 75, 30)];
    sectinLabel.text = @"人气推荐";
    sectinLabel.font = [UIFont  boldSystemFontOfSize:18.0f];
    sectinLabel.backgroundColor = [UIColor clearColor];
    sectinLabel.textColor = [UIColor darkTextColor];
    
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
    [sectionView addSubview:sectinLabel];
    sectionView.clipsToBounds = YES;
//    sectionView.backgroundColor = [UIColor whiteColor];
    
    CALayer * layer = [CALayer layer];
    layer.frame = CGRectMake(10,25.0, 75, 2.5f);
    layer.backgroundColor = [UIColor orangeColor].CGColor;
    [sectionView.layer addSublayer:layer];
    
    return sectionView;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    footView.backgroundColor = [UIColor whiteColor];
//    
//    return footView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10.0f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0f;
    }
    
    return 32.0f;
}

#pragma  mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    
    UIView * navView = [self.view viewWithTag:2015];
    UIView * suspendView = [self.view viewWithTag:2016];
    if (offset > 0 || offset <= KDefaultHeadHight - 64.0 - KSuspensionHight) {
        navView.alpha =   offset >  NavigationBar_HEIGHT? 1: offset /64.0;
        CGRect frame = navView.frame;
        frame.origin.y = offset >  NavigationBar_HEIGHT? 0 :- NavigationBar_HEIGHT + offset;
        navView.frame = frame;
        suspendView.alpha = offset > KDefaultHeadHight - 128 - KSuspensionHight? (offset - KDefaultHeadHight + 128 + KSuspensionHight) / NavigationBar_HEIGHT :0 ;
    }

    _marginView.dragging = scrollView.dragging;
    
    if (offset < 0 && offset >= -60.0 ) {
        if (scrollView.contentInset.top) {
            return;
        }
        
        float percent = 1 - fabsf(offset)/60.0;
        [_marginView setAvailbleCredit: [NSNumber numberWithFloat:percent*_marginView.currentPinValue] forPullDown:YES];
    }
    
   //NSLog(@"%f",offset);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    beginY = scrollView.contentOffset.y;
    [_marginView doWhenViewScroll:YES];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // NSLog(@"%s",__FUNCTION__);
    CGFloat nowOffsetY = scrollView.contentOffset.y;
    
    if (scrollView.dragging || scrollView.decelerating) {
        return;
    }
    
    if (nowOffsetY < 0) { // fix the down pull bug
        return;
    }
    
    if (_marginView && _marginView.state == MarginStateFull) {
        if (nowOffsetY - beginY > KDefaultHeadHight/4.0) {
            targetContentOffset ->y = KDefaultHeadHight -  NavigationBar_HEIGHT ;
        }else if ( nowOffsetY - beginY <=  KDefaultHeadHight/4.0){
            targetContentOffset ->y = 0;
        }
    }else if (_marginView.state == MarginStateLittle){
        if ( beginY - nowOffsetY > KDefaultHeadHight/4.0) {
            targetContentOffset ->y = 0;
        }else if (nowOffsetY <= KDefaultHeadHight -  NavigationBar_HEIGHT &&  nowOffsetY - beginY <=  KDefaultHeadHight/4.0){
            targetContentOffset ->y = KDefaultHeadHight -  NavigationBar_HEIGHT ;
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   // NSLog(@"%s",__FUNCTION__);
    
    CGFloat EndOffsetY = scrollView.contentOffset.y;
    
    CGFloat distance = beginY - EndOffsetY;
    
    
    if ( distance >=0 && distance >  KDefaultHeadHight/4.0)
        _marginView.state = MarginStateFull;
    else if (distance < 0 && fabsf(distance) > KDefaultHeadHight/4.0)
        _marginView.state = MarginStateLittle;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    //NSLog(@"%s",__FUNCTION__);
    do {
        CGFloat EndOffsetY = scrollView.contentOffset.y;
        
        if (EndOffsetY == 0 || EndOffsetY == KDefaultHeadHight -  NavigationBar_HEIGHT) {
            break;
        }
        
        if (EndOffsetY >= KDefaultHeadHight/4.0*3 + KSuspensionHight) {
            break;
        }
        
        if (EndOffsetY < 0) { // fix the down pull bug
            break;
        }
        
        if (_marginView.state == MarginStateLittle && EndOffsetY >= KDefaultHeadHight/4.0 ) {
            [UIView animateWithDuration:0.2 animations:^{
                [scrollView setContentOffset:CGPointMake(0, KDefaultHeadHight -  NavigationBar_HEIGHT) animated:NO];
            }];
        }else if (_marginView.state == MarginStateFull){
            [UIView animateWithDuration:0.2 animations:^{
                [scrollView setContentOffset:CGPointZero animated:NO];
            }];
        }
    }while (0) ;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   // NSLog(@"%s",__FUNCTION__);
    
    do {
        
        CGFloat EndOffsetY = scrollView.contentOffset.y;
        
        BOOL up = EndOffsetY > beginY;
        
        if (EndOffsetY > 0 && EndOffsetY < KDefaultHeadHight -  NavigationBar_HEIGHT) {
            if (EndOffsetY >= KDefaultHeadHight/4.0 && up ) {
                _marginView.state = MarginStateLittle;
                [UIView animateWithDuration:0.2 animations:^{
                    [scrollView setContentOffset:CGPointMake(0, KDefaultHeadHight -  NavigationBar_HEIGHT) animated:NO];
                }];
            }else{
                _marginView.state = MarginStateFull;
                [UIView animateWithDuration:0.2 animations:^{
                    [scrollView setContentOffset:CGPointZero animated:NO];
                }];
            }
        }
        
        if (_marginView.state == MarginStateFull && !_refreshControl.refreshing) {
            [_marginView circleDoAnimation];
        }
    } while (0);
}

#pragma mark - refreshAction
- (void)refreshFeed{
    [self performSelector:@selector(stopActive) withObject:nil afterDelay:5];
}

- (void)stopActive{
    [_marginView setAvailbleCredit:@6678 forPullDown:NO];
    [_refreshControl endRefreshing];
    if (_marginView.state == MarginStateFull && !_refreshControl.refreshing) {
        [_marginView circleDoAnimation];
    }
}

#pragma mark - Private Method 
- (void)jumpToUserCenter:(UIButton *)button{
    UserCenterController * userCtrl = [[UserCenterController alloc]init];
    
    [self.navigationController pushViewController:userCtrl animated:YES];
}
@end
