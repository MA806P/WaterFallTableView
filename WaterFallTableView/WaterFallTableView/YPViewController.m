//
//  YPViewController.m
//  WaterFallTableView
//
//  Created by qianfeng on 15/7/2.
//  Copyright (c) 2015年 MaYupeng. All rights reserved.
//

#import "YPViewController.h"

#import "YPWaterFallView.h"
#import "YPWaterFallCell.h"

@interface YPViewController () <YPWaterFallViewDelegate, YPWaterFallViewDataSource>


@property(nonatomic,weak) YPWaterFallView * waterFallView;

@end

@implementation YPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    
    YPWaterFallView * waterFallView = [[YPWaterFallView alloc] init];
    waterFallView.frame = self.view.bounds;
    waterFallView.dataSource = self;
    waterFallView.delegate = self;
    
    [self.view addSubview:waterFallView];
    self.waterFallView = waterFallView;
    
    //刷新数据
    //[waterFallView reloadData];
    //不用在这刷新数据, 应该一添加到父视图中的时候就调用这个方法
    
    
}






#pragma mark - 数据源方法

//多少个cell
- (NSInteger)numberOfCellsInWaterFall:(YPWaterFallView *)waterFallView
{
    return 50;
}
//多少列
-(NSInteger)numberOfColumnsInWaterFall:(YPWaterFallView *)waterFallView
{
    return 3;
}

//在index位置, 放什么cell
- (YPWaterFallCell *)waterFall:(YPWaterFallView *)waterFall cellAtIndex:(NSInteger)index
{
    //YPWaterFallCell * cell =[[YPWaterFallCell alloc] init];
    
    YPWaterFallCell * cell = [waterFall dequeueReusableCellWithIdentifier:@"waterFallCell"];
    
    if(cell == nil)
    {
        cell = [[YPWaterFallCell alloc] init];
        cell.identifier = @"waterFallCell";
        
        cell.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(256))/255.0 green:(arc4random_uniform(256))/255.0 blue:(arc4random_uniform(256))/255.0 alpha:1.0] ;
        
        //向cell中添加视图应该放到里面, 放到外面不论缓存池中有没有都会添加, 会重复创建,
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)];
        label.tag = 100;
        
        //label.text = [NSString stringWithFormat:@"%ld",index];
        
        [cell addSubview:label];
    }
    
    UILabel * lab = (UILabel *)[cell viewWithTag:100];
    lab.text = [NSString stringWithFormat:@"%ld",index];
    
    //NSLog(@"%ld %p", index, cell);
    
    return cell;
}


#pragma mark - 代理方法

//给定在index的位置的cell的高度
- (CGFloat)waterFallView:(YPWaterFallView *)waterFallView heightAtIndex:(NSInteger)index
{
    switch (index%3) {
        case 0: return 110;
        case 1: return 150;
        case 2: return 90;
        default: return 120;
    }
}

//确定上下左右的间距
-(CGFloat)waterFallView:(YPWaterFallView *)waterFallView marginForType:(YPWaterFallViewMarginType)type
{
    switch (type) {
        case YPWaterFallViewMarginTypeTop:
        case YPWaterFallViewMarginTypeBottom:
        case YPWaterFallViewMarginTypeLeft:
        case YPWaterFallViewMarginTypeRight:
            return 10;
            
        default:
            return 5;
    }
}

//选中了cell
- (void)waterFallView:(YPWaterFallView *)waterFallView didSelectAtIndex:(NSInteger)index
{
    NSLog(@"选中了地%ld个cell",index);
}




@end
