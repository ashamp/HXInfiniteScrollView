//
//  ExamplView.m
//  InfiniteScrollView
//
//  Created by 谢俊伟 on 6/24/15.
//  Copyright (c) 2015 XieJunwei. All rights reserved.
//

#import "ExamplView.h"

#import <Masonry.h>

@interface ExamplView ()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subtitleLabel;
@end

@implementation ExamplView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    UILabel *titleLabel=[UILabel new];
    self.titleLabel=titleLabel;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
    }];
    
    UILabel *subtitleLabel=[UILabel new];
    self.subtitleLabel=subtitleLabel;
    [self addSubview:subtitleLabel];
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
    }];
}

-(void)setDataModel:(ExampleViewDataModel *)dataModel{
    self.titleLabel.text=dataModel.title;
    self.subtitleLabel.text=dataModel.subtitle;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
