//
//  YPShopController.m
//  WaterFallShop
//
//  Created by qianfeng on 15/7/4.
//  Copyright (c) 2015年 MaYupeng. All rights reserved.
//

#import "YPShopController.h"
#import "YPWaterFallView.h"
#import "YPShop.h"
#import "YPShopCell.h"

#import "MJExtension.h"
#import "MJRefresh.h"

@interface YPShopController ()<YPWaterFallViewDataSource, YPWaterFallViewDelegate , MJRefreshBaseViewDelegate>

@property(nonatomic,weak) YPWaterFallView * waterFallView;
@property(nonatomic,strong) NSMutableArray * shops;

@property(nonatomic,weak) MJRefreshFooterView * footerView;
@property(nonatomic,weak) MJRefreshHeaderView * headerView;


@end

@implementation YPShopController


-(NSMutableArray *)shops
{
    if(_shops == nil)
    {
        NSArray * shops = [YPShop objectArrayWithFilename:@"2.plist"];
        _shops = [NSMutableArray arrayWithArray:shops];
    }
    return _shops;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor grayColor];
    
    YPWaterFallView * waterFallView = [[YPWaterFallView alloc] init];
    waterFallView.frame = self.view.bounds;
    waterFallView.dataSource = self;
    waterFallView.delegate = self;
    
    //// 跟随着父控件的尺寸而自动伸缩
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
- (NSInteger)numberOfCellsInWaterFall:(YPWaterFallView *)waterFallView
{
    return self.shops.count;
}
//多少列
-(NSInteger)numberOfColumnsInWaterFall:(YPWaterFallView *)waterFallView
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
- (YPWaterFallCell *)waterFall:(YPWaterFallView *)waterFall cellAtIndex:(NSInteger)index
{
    
    YPShopCell * cell = [YPShopCell shopCellWithWaterFallView:waterFall];
    cell.shop = self.shops[index];
    
    return cell;
}


#pragma mark - 代理方法

//给定在index的位置的cell的高度
- (CGFloat)waterFallView:(YPWaterFallView *)waterFallView heightAtIndex:(NSInteger)index
{
    YPShop * shop = self.shops[index];
    
    CGFloat heightOfCell = waterFallView.widthOfCell * (shop.h/shop.w);
    
    return heightOfCell;
    
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



#pragma MJRefreshBaseViewDelegate

- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    if([refreshView isKindOfClass:[MJRefreshHeaderView class]])
    {
        //NSLog(@"上拉刷新");
        
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            
            NSArray * newShops = [YPShop objectArrayWithFilename:@"1.plist"];
            [self.shops insertObjects:newShops atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newShops.count)]];
            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.waterFallView reloadData];
            [self.headerView endRefreshing];
        });
        
        
    }
    else
    {
        //NSLog(@"下拉加载");
        
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            NSArray * moreShops = [YPShop objectArrayWithFilename:@"3.plist"];
            [self.shops addObjectsFromArray:moreShops];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.waterFallView reloadData];
            [self.footerView endRefreshing];
        });
        
    }
}





@end
