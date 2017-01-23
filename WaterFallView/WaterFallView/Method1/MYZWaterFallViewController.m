//
//  MYZWaterFallViewController.m
//  WaterFallView
//
//  Created by 159CaiMini02 on 17/1/23.
//  Copyright © 2017年 myz. All rights reserved.
//

#import "MYZWaterFallViewController.h"
#import "MYZWaterFallView.h"
#import "MYZItemCell.h"
#import "MYZItem.h"

#import "MJRefresh.h"

@interface MYZWaterFallViewController () <MYZWaterFallViewDelegate, MYZWaterFallViewDataSource, MJRefreshBaseViewDelegate>

@property(nonatomic,weak) MYZWaterFallView * waterFallView;
@property(nonatomic,strong) NSMutableArray * items;

@property(nonatomic,weak) MJRefreshFooterView * footerView;
@property(nonatomic,weak) MJRefreshHeaderView * headerView;

@end

@implementation MYZWaterFallViewController

- (NSMutableArray *)items
{
    if(_items == nil)
    {
        NSArray * itemDicts = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2.plist" ofType:nil]];
        NSMutableArray * items = [NSMutableArray array];
        for (NSDictionary * dic in itemDicts)
        {
            MYZItem * item = [MYZItem itemWithDict:dic];
            [items addObject:item];
        }
        _items = items;
    }
    return _items;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor grayColor];
    
    MYZWaterFallView * waterFallView = [[MYZWaterFallView alloc] init];
    waterFallView.frame = self.view.bounds;
    waterFallView.dataSource = self;
    waterFallView.delegate = self;
    // 跟随着父控件的尺寸而自动伸缩
    waterFallView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:waterFallView];
    self.waterFallView = waterFallView;
    
    
    //上下拉加载
    MJRefreshHeaderView * header = [MJRefreshHeaderView header];
    header.scrollView = waterFallView;
    header.delegate = self;
    self.headerView = header;
    
    MJRefreshFooterView * footer = [MJRefreshFooterView footer];
    footer.scrollView = waterFallView;
    footer.delegate = self;
    self.footerView = footer;
    
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //NSLog(@"屏幕旋转.");
    [self.waterFallView reloadData];
}



#pragma mark - 数据源方法

//多少个cell
- (NSInteger)numberOfCellsInWaterFall:(MYZWaterFallView *)waterFallView
{
    return self.items.count;
}
//多少列
-(NSInteger)numberOfColumnsInWaterFall:(MYZWaterFallView *)waterFallView
{
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
    {
        return 3;
    }
    else
    {
        return 5;
    }
}

//在index位置, 放什么cell
- (MYZItemCell *)waterFall:(MYZWaterFallView *)waterFall cellAtIndex:(NSInteger)index
{
    
    MYZItemCell * cell = [MYZItemCell itemCellWithWaterFallView:waterFall];
    cell.item = self.items[index];
    
    return cell;
}


#pragma mark - 代理方法

//给定在index的位置的cell的高度
- (CGFloat)waterFallView:(MYZWaterFallView *)waterFallView heightAtIndex:(NSInteger)index
{
    MYZItem * item = self.items[index];
    CGFloat heightOfCell = waterFallView.widthOfCell * (item.h/item.w);
    return heightOfCell;
}

//确定上下左右的间距
-(CGFloat)waterFallView:(MYZWaterFallView *)waterFallView marginForType:(MYZWaterFallViewMarginType)type
{
    switch (type) {
        case MYZWaterFallViewMarginTypeTop:
        case MYZWaterFallViewMarginTypeBottom:
        case MYZWaterFallViewMarginTypeLeft:
        case MYZWaterFallViewMarginTypeRight:
            return 10;
        default:
            return 5;
    }
}

//选中了cell
- (void)waterFallView:(MYZWaterFallView *)waterFallView didSelectAtIndex:(NSInteger)index
{
    NSLog(@"选中了地%ld个cell",index);
}



#pragma MJRefreshBaseViewDelegate

- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    if([refreshView isKindOfClass:[MJRefreshHeaderView class]])
    {
        //上拉刷新
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            
            NSArray * itemDicts = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil]];
            NSMutableArray * newItems = [NSMutableArray array];
            for (NSDictionary * dic in itemDicts)
            {
                MYZItem * item = [MYZItem itemWithDict:dic];
                [newItems addObject:item];
            }
            [self.items insertObjects:newItems atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newItems.count)]];
            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.waterFallView reloadData];
            [self.headerView endRefreshing];
        });
        
        
    }
    else
    {
        //下拉加载
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            NSArray * itemDicts = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"3.plist" ofType:nil]];
            NSMutableArray * moreItems = [NSMutableArray array];
            for (NSDictionary * dic in itemDicts)
            {
                MYZItem * item = [MYZItem itemWithDict:dic];
                [moreItems addObject:item];
            }
            [self.items addObjectsFromArray:moreItems];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.waterFallView reloadData];
            [self.footerView endRefreshing];
        });
        
    }
}




@end
