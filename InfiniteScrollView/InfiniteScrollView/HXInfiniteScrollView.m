//
//  HXInfiniteScrollView.m
//  无尽的滚动
//
//  Created by 谢俊伟 on 6/18/15.
//  Copyright (c) 2015 谢俊伟. All rights reserved.
//

#import "HXInfiniteScrollView.h"
#import <Masonry.h>
#import "UIView+JWMasonryConstraint.h"

static NSTimeInterval defaultAutoScrollInterval=5;
static BOOL defaultShouldAutoScroll=YES;
static BOOL defaultScrollableForSinglePage=NO;
static BOOL defaultShouldStartAutoScrollAfterDragging=YES;

@interface HXInfiniteScrollView ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSArray *views;//内容
@property(nonatomic,strong)NSArray *contentContainerViews;//3个容器,用于存放内容
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic,assign) NSInteger currentPageIndex;
@property(nonatomic,assign) NSInteger numberOfPages;
@end

@implementation HXInfiniteScrollView

#pragma mark - Designated init

-(instancetype)initWithDataSource:(NSArray *)dataSource contentViewCreationBlock:(HXInfiniteScrollViewContentViewCreationBlock)creationBlock{
    self=[super init];
    if (self) {
        NSAssert(dataSource.count>0, @"至少要有1个元素!1个元素都没有还滚个球啊?");
        self.numberOfPages=dataSource.count;
        if (dataSource.count==1) {
            id dataModel=[dataSource firstObject];
            NSMutableArray *newDataSource=[NSMutableArray new];
            [newDataSource addObject:dataModel];
            [newDataSource addObject:dataModel];
            [newDataSource addObject:dataModel];
            dataSource=newDataSource;
        }
        else if (dataSource.count==2){
            id firstDataModel=[dataSource firstObject];
            id lastDataModel=[dataSource lastObject];
            NSMutableArray *newDataSource=[NSMutableArray new];
            [newDataSource addObject:firstDataModel];
            [newDataSource addObject:lastDataModel];
            [newDataSource addObject:firstDataModel];
            [newDataSource addObject:lastDataModel];
            dataSource=newDataSource;
        }
        
        NSMutableArray *views=[NSMutableArray new];
        for (id dataModel in dataSource) {
            UIView *contentView = creationBlock(dataModel);
            [views addObject:contentView];
        }
        self.views=views;
        
        self.autoScrollInterval=defaultAutoScrollInterval;
        self.shouldAutoScroll=defaultShouldAutoScroll;
        self.shouldStartAutoScrollAfterDragging=defaultShouldStartAutoScrollAfterDragging;
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    
    self.currentPageIndex=0;
    
    UIScrollView *scrollView=[UIScrollView new];
    self.scrollView=scrollView;
    
    if (self.numberOfPages==1) {
        scrollView.scrollEnabled=defaultScrollableForSinglePage;
    }
    
    scrollView.pagingEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=NO;
    
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView.superview);
    }];
    
    UIView *contentView = [UIView new];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.height.equalTo(contentView.superview);
        make.width.equalTo(contentView.superview).multipliedBy(self.contentContainerViews.count);
    }];
    
    //调试用
    //[self addNumberToViews:self.views];
    
    [contentView makeEqualWidthViews:self.contentContainerViews];
    
    //页码
    UIPageControl *pageControl=[UIPageControl new];
    self.pageControl=pageControl;
    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.3];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.userInteractionEnabled = NO;
    pageControl.hidesForSinglePage = YES;
    pageControl.currentPage = 0;
    pageControl.numberOfPages=self.numberOfPages;
    [self addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pageControl.superview);
        make.bottom.equalTo(pageControl.superview);
        make.height.equalTo(@20);
    }];
}

#pragma mark - Public Method

-(void)stopAutoScroll{
    self.shouldAutoScroll=NO;
}

-(void)startAutoScroll{
    self.shouldAutoScroll=YES;
}

#pragma mark Override

-(void)removeFromSuperview{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [super removeFromSuperview];
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    if (self.superview) {
        //只有有确切的superview时才开始滚动
        [self autoScrollToNextPage];
        [self scrollToFirstPage];
        self.scrollView.delegate=self;
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopAutoScroll];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAutoScroll) object:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.shouldStartAutoScrollAfterDragging) {
        [self performSelector:@selector(startAutoScroll) withObject:nil afterDelay:self.autoScrollInterval*2];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%s",__func__);
    CGPoint offset = self.scrollView.contentOffset;
    
    if (offset.x<=0) {
//        NSLog(@"左滑");
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self setupContentViews];
    }
    if ( offset.x+ CGRectGetWidth(self.frame)>=self.scrollView.contentSize.width) {
//        NSLog(@"右滑");
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self setupContentViews];
    }
}

#pragma mark - Content Management

-(void)setupContentViews{
//    self.pageLabel.text=[NSString stringWithFormat:@"第%@页",@(self.currentPageIndex)];
    
    //总页数为2时需要特殊处理
    if (self.numberOfPages==2) {
        self.pageControl.currentPage=self.currentPageIndex%2;
    }
    else{
        self.pageControl.currentPage=self.currentPageIndex;
    }
    
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    
    UIView *leftContainerView=[self.contentContainerViews objectAtIndex:0];
    [self addContentViewAtIndex:previousPageIndex toContainer:leftContainerView];

    UIView *middleContainerView=[self.contentContainerViews objectAtIndex:1];
    [self addContentViewAtIndex:self.currentPageIndex toContainer:middleContainerView];
    
    UIView *rightContainerView=[self.contentContainerViews objectAtIndex:2];
    [self addContentViewAtIndex:rearPageIndex toContainer:rightContainerView];
    
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    
}

-(void)addContentViewAtIndex:(NSInteger)index toContainer:(UIView *)container{
    [[container subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *contentView=self.views[index];
    [container addSubview:contentView];
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView.superview);
    }];
}

-(void)scrollToFirstPage{
    self.currentPageIndex=0;
    [self setupContentViews];
}

-(void)autoScrollToNextPage{
    [self performSelector:@selector(autoScrollToNextPage) withObject:nil afterDelay:self.autoScrollInterval];
    if (self.shouldAutoScroll) {
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width*2, 0) animated:YES];
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;{
    if(currentPageIndex == -1) {
        return self.views.count - 1;
    } else if (currentPageIndex == self.views.count) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark - Getter Setter

-(void)setAutoScrollInterval:(NSTimeInterval)autoScrollInterval{
    if (autoScrollInterval<=0) {
        autoScrollInterval=MAXFLOAT;
        self.shouldAutoScroll=NO;
    }
    if (autoScrollInterval<1) {
        autoScrollInterval=1;
    }
    _autoScrollInterval=autoScrollInterval;
}

-(NSArray *)contentContainerViews{
    if (_contentContainerViews==nil) {
        NSMutableArray *contentContainerViews=[NSMutableArray new];
        for (NSInteger index=0; index<3; index++) {
            UIView *contentContainerView=[UIView new];
            [contentContainerViews addObject:contentContainerView];
        }
        _contentContainerViews=contentContainerViews;
    }
    return _contentContainerViews;
}

-(void)setScrollableForSinglePage:(BOOL)scrollableForSinglePage{
    _scrollableForSinglePage=scrollableForSinglePage;
    if (self.numberOfPages==1) {
        self.scrollView.scrollEnabled=scrollableForSinglePage;
    }
}

//调试用的
#pragma mark - Debug

-(void)addNumberToViews:(NSArray *)views{
    NSInteger count  =  0;
    for (UIView *view in views) {
        UILabel *label = [UILabel new];
        label.text = [NSString stringWithFormat:@"%@",@(count)];
        count++;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(label.superview);
        }];
    }
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
