//
//  DetailsPageViewController.m
//  TheMovieDB
//
//  Created by 朱大茂 on 15/6/3.
//  Copyright (c) 2015年 zhudm. All rights reserved.
//

#import "DetailsPageView.h"

#define kDefaultImagePagerHeight 375.0f
#define kDefaultTableViewHeaderMargin 95.0f
#define kDefaultImageAlpha 500.0f
#define kDefaultImageScalingFactor 300.0f

@interface KMDetailsPageView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton* imageButton;

@end

@implementation KMDetailsPageView

#pragma mark -
#pragma mark Init Methods

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _imageHeaderViewHeight = kDefaultImagePagerHeight;
    _imageScalingFactor = kDefaultImageScalingFactor;
    _headerImageAlpha = kDefaultImageAlpha;
    _backgroundViewColor = [UIColor clearColor];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
}

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark -
#pragma mark View layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    _navBarFadingOffset = _imageHeaderViewHeight - (_navBarView ?  CGRectGetHeight(_navBarView.frame):0 + kDefaultTableViewHeaderMargin);
    
    if (!self.tableView){
        [self setupTableView];
    };
    
    if (!self.tableView.tableHeaderView)
        [self setupTableViewHeader];
    
    if(!self.imageView)
        [self setupImageView];
    
    if (self.backgroundColor)
        [self setupBackgroundColor];
    
    
    
    //[self setupImageButton];
    
}

#pragma mark -
#pragma mark View Layout Setup Methods

- (void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (self.tableViewSeparatorColor)
        self.tableView.separatorColor = self.tableViewSeparatorColor;
    
    // Add scroll view KVO
    void *context = (__bridge void *)self;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    
    [self addSubview:self.tableView];
}

- (void)setupTableViewHeader
{
    CGRect tableHeaderViewFrame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, self.imageHeaderViewHeight - kDefaultTableViewHeaderMargin);
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:tableHeaderViewFrame];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)setupImageButton
{
    if (!self.imageButton)
        self.imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.imageHeaderViewHeight)];
    [self.imageButton addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.tableHeaderView addSubview:self.imageButton];
}

- (void)setupImageView
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0, self.tableView.frame.size.width, self.imageHeaderViewHeight)];
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self insertSubview:self.imageView belowSubview:self.tableView];
}

- (void)setupBackgroundColor
{
    self.backgroundColor = self.backgroundViewColor;
    self.tableView.backgroundColor = self.backgroundViewColor;
}

- (void)setupImageViewGradient
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.imageView.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor], [(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], nil];
    
    gradientLayer.startPoint = CGPointMake(0.6f, 0.6);
    gradientLayer.endPoint = CGPointMake(0.6f, 1.0f);
    
    self.imageView.layer.mask = gradientLayer;
}

#pragma mark -
#pragma mark Data Refresh

- (void)reloadData;
{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Tableview Delegate and DataSource setters

- (void)setTableViewDataSource:(id<UITableViewDataSource>)tableViewDataSource
{
    _tableViewDataSource = tableViewDataSource;
    self.tableView.dataSource = _tableViewDataSource;
    
}

- (void)setTableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate
{
    _tableViewDelegate = tableViewDelegate;
    self.tableView.delegate = _tableViewDelegate;
}

#pragma mark -
#pragma mark HeaderView Setter

- (void)setNavBarView:(UIView *)headerView
{
    _navBarView = headerView;
}

- (void)hideHeaderImageView:(BOOL)hidden
{
    self.imageView.hidden = hidden;
}

#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // Make sure we are observing this value.
    if (context != (__bridge void *)self) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ((object == self.tableView) &&
        ([keyPath isEqualToString:@"contentOffset"] == YES))
    {
        [self scrollViewDidScrollWithOffset:self.tableView.contentOffset.y];
        return;
    }
}

#pragma mark -
#pragma mark Action Methods

- (void)imageButtonPressed:(UIButton*)buttom
{
    if ([self.delegate respondsToSelector:@selector(detailsPage:imageViewWasSelected:)])
        [self.delegate detailsPage:self imageViewWasSelected:self.imageView];
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset
{
    CGPoint scrollViewDragPoint = [self.delegate detailsPage:self tableViewWillBeginDragging:self.tableView];
    
    if (scrollOffset < 0)
        self.imageView.transform = CGAffineTransformMakeScale(1 - (scrollOffset / self.imageScalingFactor), 1 - (scrollOffset / self.imageScalingFactor));
    else
        self.imageView.transform = CGAffineTransformMakeTranslation(0, -0.3*scrollOffset);
        //self.imageView.transform = CGAffineTransformMakeScale(1+scrollOffset, 1+scrollOffset);
    
    CGFloat alpha = scrollOffset > 0? (kDefaultImageAlpha - scrollOffset)/kDefaultImageAlpha:1;
    self.imageView.alpha = alpha;
    
    if (_navBarView) {
        [self animateNavigationBar:scrollOffset draggingPoint:scrollViewDragPoint];
    }
}

- (void)animateImageView:(CGFloat)scrollOffset draggingPoint:(CGPoint)scrollViewDragPoint alpha:(float)alpha
{
    alpha = scrollOffset > 0? (kDefaultImageAlpha - scrollOffset)/kDefaultImageAlpha:1;
    
    NSLog(@"point is :%@ offset:%f alpha:%f\n",[NSValue valueWithCGPoint:scrollViewDragPoint],scrollOffset,alpha);
    
    [self animateNavigationBar:scrollOffset draggingPoint:scrollViewDragPoint];
    
//    if (scrollOffset > scrollViewDragPoint.y && scrollOffset > kDefaultTableViewHeaderMargin)
//    {
        //[UIView animateWithDuration:0.3 animations:^{
            self.imageView.alpha = alpha;
        //} completion:nil];
//    }
//    else if (scrollOffset <= kDefaultTableViewHeaderMargin)
//    {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.imageView.alpha = 1.0;
//        } completion:nil];
//    }
}

- (void)animateNavigationBar:(CGFloat)scrollOffset draggingPoint:(CGPoint)scrollViewDragPoint
{
    if(scrollOffset > _navBarFadingOffset && _navBarView.alpha == 0.0)
    { //make the navbar appear
        _navBarView.hidden = NO;
        _navBarView.alpha = 0;
    
        [UIView animateWithDuration:0.3 animations:^
         {
             _navBarView.alpha = 1;
         }];
    }
    else if(scrollOffset < _navBarFadingOffset && _navBarView.alpha == 1.0)
    { //make the navbar disappear
        [UIView animateWithDuration:0.3 animations:^{
            _navBarView.alpha = 0;
        } completion: ^(BOOL finished) {
            _navBarView.hidden = YES;
        }];
    }
}

@end