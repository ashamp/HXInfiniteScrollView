# HXInfiniteScrollView
无限滚动组件封装

特点
1.一句话就可以生成1个无限滚动视图
2.使用AutoLayout构建,全自适应,内容页自动跟随滚动视图变化,无需任何frame调整

//用法:
    HXInfiniteScrollView *infiniteScrollView=[[HXInfiniteScrollView alloc]initWithDataSource:@[@"数据1",@"数据2",@"数据3",@"数据4"] contentViewCreationBlock:^UIView *(id dataModel) {
    
        UILabel *label=[UILabel new];
        
        label.backgroundColor=[UIColor randomColor];
        
        label.text=(NSString *)dataModel;
        
        return label;
        
    }];
    
    infiniteScrollView.frame=CGRectMake(100, 100, 200, 100);
    
    [self.view addSubview:infiniteScrollView];
    
