//
//  ViewController.m
//  InfiniteScrollView
//
//  Created by 谢俊伟 on 6/24/15.
//  Copyright (c) 2015 XieJunwei. All rights reserved.
//

#import "ViewController.h"

#import "HXInfiniteScrollView.h"

#import "UIColor+HXRandomColor.h"

#import "ExamplView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //用法1
    HXInfiniteScrollView *infiniteScrollView=[[HXInfiniteScrollView alloc]initWithDataSource:@[@"数据1",@"数据2",@"数据3",@"数据4"] contentViewCreationBlock:^UIView *(id dataModel) {
        UILabel *label=[UILabel new];
        label.backgroundColor=[UIColor randomColor];
        label.text=(NSString *)dataModel;
        return label;
    }];
    infiniteScrollView.frame=CGRectMake(100, 100, 200, 100);
    [self.view addSubview:infiniteScrollView];
    
    //用法2
    
    ExampleViewDataModel *dataModel1=[ExampleViewDataModel new];
    dataModel1.title=@"标题1";
    dataModel1.subtitle=@"内容1";
    
    ExampleViewDataModel *dataModel2=[ExampleViewDataModel new];
    dataModel2.title=@"标题2";
    dataModel2.subtitle=@"内容2";
    
    ExampleViewDataModel *dataModel3=[ExampleViewDataModel new];
    dataModel3.title=@"标题3";
    dataModel3.subtitle=@"内容3";
    
    ExampleViewDataModel *dataModel4=[ExampleViewDataModel new];
    dataModel4.title=@"标题4";
    dataModel4.subtitle=@"内容4";
    
    NSArray *dataSource=@[dataModel1,dataModel2,dataModel3,dataModel4];
    
    HXInfiniteScrollView *example=[[HXInfiniteScrollView alloc]initWithDataSource:dataSource contentViewCreationBlock:^UIView *(id dataModel) {
        ExamplView *exampleView=[ExamplView new];
        exampleView.dataModel=dataModel;
        exampleView.backgroundColor=[UIColor randomColor];
        return exampleView;
    }];
    example.frame=CGRectMake(100, 320, 200, 100);
    [self.view addSubview:example];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
