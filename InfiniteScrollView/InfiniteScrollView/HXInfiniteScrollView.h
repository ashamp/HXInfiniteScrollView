//
//  HXInfiniteScrollView.h
//  无尽的滚动
//
//  Created by 谢俊伟 on 6/18/15.
//  Copyright (c) 2015 谢俊伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView *(^HXInfiniteScrollViewContentViewCreationBlock)(id dataModel);

@interface HXInfiniteScrollView : UIView

@property(nonatomic,assign)NSTimeInterval autoScrollInterval;//defalut 5

@property(nonatomic,assign)BOOL shouldAutoScroll;//defalut YES

@property(nonatomic,assign)BOOL scrollableForSinglePage;//defalut NO

@property(nonatomic,assign)BOOL shouldStartAutoScrollAfterDragging;//defalut YES

-(instancetype)initWithDataSource:(NSArray *)dataSource contentViewCreationBlock:(HXInfiniteScrollViewContentViewCreationBlock)creationBlock;

-(void)stopAutoScroll;

-(void)startAutoScroll;

@end
