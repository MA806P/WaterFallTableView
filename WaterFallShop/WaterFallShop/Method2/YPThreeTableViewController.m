//
//  YPThreeTableViewController.m
//  WaterFallShop
//
//  Created by qianfeng on 15/7/5.
//  Copyright (c) 2015年 MaYupeng. All rights reserved.
//

#define MARGIN 10
#define COLUMN_WIDTH (self.view.frame.size.width - 4*MARGIN)/3


#import "YPThreeTableViewController.h"
#import "YPShop.h"
#import "YPTableViewCell.h"

#import "MJExtension.h"
#import "UIImageView+WebCache.h"


@interface YPThreeTableViewController ()<UITableViewDataSource, UITableViewDelegate>


/** 保存用来,全部要显示的数据 */
@property(nonatomic,strong) NSMutableArray * shopsData;

/** 三个tableView的数据源，装在一个数组里, 数组里有三个小数组 */
@property(nonatomic,strong) NSMutableArray * threeDataArray;

/** 用来保存三个tableview的数组 */
@property(nonatomic,strong) NSMutableArray * tableViews;

@end

@implementation YPThreeTableViewController


-(NSMutableArray *)shopsData
{
    if(_shopsData == nil)
    {
        NSArray * shops = [YPShop objectArrayWithFilename:@"1.plist"];
        _shopsData = [NSMutableArray arrayWithArray:shops];
    }
    return _shopsData;
}

-(NSMutableArray *)threeDataArray
{
    if (_threeDataArray == nil)
    {
        _threeDataArray = [NSMutableArray array];
        for (int i=0; i<3; i++)
        {
            NSMutableArray * partArray = [NSMutableArray array];
            [_threeDataArray addObject:partArray];
        }
    }
    return _threeDataArray;
}

-(NSMutableArray *)tableViews
{
    if(_tableViews == nil)
    {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    //刷新数据
    [self reloadData];
    //创建三个tableView
    [self createTableViews];
    
}


- (void)reloadData
{
    //刷新前清空三个数组
    //[self.threeDataArray removeAllObjects];
    self.threeDataArray = nil;
    
    //分别记录三个tableView目前长度，即三列数据的分别长度
    CGFloat columnLength[3]={0};
    
    
    //根据每列的长度,将总的数据,分别添加到三个数组里面,(每次都添加到最短的那列)
    
    for (YPShop * shop in self.shopsData)
    {
        //找出最短的那一列
        CGFloat shortColumnLength = columnLength[0];
        int shortColumn = 0;
        for (int i=1; i<3; i++)
        {
            if(shortColumnLength > columnLength[i])
            {
                shortColumnLength = columnLength[i];
                shortColumn = i ;
            }
        }
        
        //找到了那列最短之后, 将数据添加到最短的那列,
        [self.threeDataArray[shortColumn] addObject:shop];
        
        //更新最短那列的长度, 根据比例和每列的宽度来计算高度
        columnLength[shortColumn] += (shop.h/shop.w)*COLUMN_WIDTH+MARGIN ;
        
    }
    
    
//    for(int i=0;i<3;i++)
//    {
//        NSLog(@"%d = %lf",i,columnLength[i]);
//    }
    
}


//创建三个tableView
-(void)createTableViews
{
    for (int i=0; i<3; i++)
    {
        CGRect rect = CGRectMake(i*(COLUMN_WIDTH+MARGIN)+MARGIN, MARGIN, COLUMN_WIDTH, self.view.frame.size.height);
        UITableView * tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:tableView];
        
        [self.tableViews addObject:tableView];
    }
    
}



#pragma - mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //得到是那个,tableView
    NSInteger index = [self.tableViews indexOfObject:tableView];
    
    return [self.threeDataArray[index] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self.tableViews indexOfObject:tableView];
    NSArray * shops = self.threeDataArray[index];
    YPShop * shop = shops[indexPath.row];
    
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell"];
//    
//    if(cell==nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopCell"];
//    }
//    
//    UIImageView * imgView = [[UIImageView alloc] init];
//    imgView.frame = CGRectMake(0, 0, COLUMN_WIDTH, (shop.h/shop.w)*COLUMN_WIDTH);
//    [imgView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
//    
//    [cell.contentView addSubview:imgView];

    
    YPTableViewCell * cell = [YPTableViewCell tableViewCellWithTableView:tableView];
    cell.shop = shop;
    
    return cell;
}


#pragma - mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self.tableViews indexOfObject:tableView];
    NSArray * shops = self.threeDataArray[index];
    YPShop * shop = shops[indexPath.row];
    
    return (shop.h/shop.w)*COLUMN_WIDTH+MARGIN ;
}


//三个tableView一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //只要滚动，就调用，无论拖动，还是惯性滑动，只要在滚动，就不断调用这个方法
    //获取当前滚动的scrollView即tableView
    CGPoint offset = scrollView.contentOffset;
    for (UITableView * tableView in self.tableViews) {
        if (tableView == scrollView)
            continue;
        tableView.contentOffset = offset;
    }
}



@end
