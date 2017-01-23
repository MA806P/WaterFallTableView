//
//  MYZThreeTableViewController.m
//  WaterFallView
//
//  Created by 159CaiMini02 on 17/1/23.
//  Copyright © 2017年 myz. All rights reserved.
//

#define MARGIN 10
#define COLUMN_WIDTH (self.view.frame.size.width - 4*MARGIN)/3


#import "MYZThreeTableViewController.h"
#import "MYZItem.h"
#import "MYZTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface MYZThreeTableViewController () <UITableViewDataSource, UITableViewDelegate>

/** 保存用来,全部要显示的数据 */
@property(nonatomic,strong) NSMutableArray * itemsData;

/** 三个tableView的数据源，装在一个数组里, 数组里有三个小数组 */
@property(nonatomic,strong) NSMutableArray * threeDataArray;

/** 用来保存三个tableview的数组 */
@property(nonatomic,strong) NSMutableArray * tableViews;

@end

@implementation MYZThreeTableViewController


- (NSMutableArray *)itemsData
{
    if(_itemsData == nil)
    {
        NSArray * itemDicts = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil]];
        NSMutableArray * items = [NSMutableArray array];
        for (NSDictionary * dic in itemDicts)
        {
            MYZItem * item = [MYZItem itemWithDict:dic];
            [items addObject:item];
        }
        _itemsData = items;
    }
    return _itemsData;
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


- (void)viewDidLoad
{
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
    
    for (MYZItem * item in self.itemsData)
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
        [self.threeDataArray[shortColumn] addObject:item];
        
        //更新最短那列的长度, 根据比例和每列的宽度来计算高度
        columnLength[shortColumn] += (item.h/item.w)*COLUMN_WIDTH+MARGIN ;
        
    }
}


//创建三个tableView
-(void)createTableViews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat y = 64;
    CGFloat h = self.view.frame.size.height - y - 49;
    CGFloat w = COLUMN_WIDTH;
    
    for (int i=0; i<3; i++)
    {
        CGFloat x = i*(COLUMN_WIDTH+MARGIN)+MARGIN;
        
        CGRect rect = CGRectMake(x, y, w, h);
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
    MYZItem * shop = shops[indexPath.row];

    MYZTableViewCell * cell = [MYZTableViewCell tableViewCellWithTableView:tableView];
    cell.item = shop;
    
    return cell;
}


#pragma - mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self.tableViews indexOfObject:tableView];
    NSArray * items = self.threeDataArray[index];
    MYZItem * item = items[indexPath.row];
    
    return (item.h/item.w)*COLUMN_WIDTH+MARGIN ;
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
