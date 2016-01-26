//
//  YPWaterFallView.h
//  WaterFallTableView
//
//  Created by qianfeng on 15/7/2.
//  Copyright (c) 2015年 MaYupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YPWaterFallView, YPWaterFallCell;


//设置枚举值, 用来判断设置间距
typedef enum
{
    YPWaterFallViewMarginTypeTop,
    YPWaterFallViewMarginTypeBottom,
    YPWaterFallViewMarginTypeRight,
    YPWaterFallViewMarginTypeLeft,
    YPWaterFallViewMarginTypeColumn, //每一列
    YPWaterFallViewMarginTypeRow //每一行
    
} YPWaterFallViewMarginType;



/**
 *  数据源方法
 */
@protocol YPWaterFallViewDataSource <NSObject>

//数据源方法,必须实现,告诉有多少数据,显示什么
@required

/** 用来设置一共有多少个数据 */
- (NSInteger)numberOfCellsInWaterFall:(YPWaterFallView *)waterFallView;

/** 用来得到index位置的cell */
- (YPWaterFallCell *)waterFall:(YPWaterFallView *)waterFall cellAtIndex:(NSInteger)index;


@optional

/** 用来设置一共显示多少列, 默认的为3列 */
- (NSInteger)numberOfColumnsInWaterFall:(YPWaterFallView *)waterFallView;

@end



/**
 *  代理方法
 */
@protocol YPWaterFallViewDelegate <UIScrollViewDelegate>

@optional

/** 用来设置index位置的cell的高度 , 可选的,默认值为70 */
- (CGFloat)waterFallView:(YPWaterFallView *)waterFallView heightAtIndex:(NSInteger)index;

/** 用来设置上下左右的间距, 根据枚举值来判断, 默认值上下左右行列都为10 */
-(CGFloat)waterFallView:(YPWaterFallView *)waterFallView marginForType:(YPWaterFallViewMarginType)type;


/** 选中的第index的cell */
- (void)waterFallView:(YPWaterFallView *)waterFallView didSelectAtIndex:(NSInteger)index;


@end



@interface YPWaterFallView : UIScrollView


/** 数据源 */
@property(nonatomic,assign) id<YPWaterFallViewDataSource> dataSource;

/** 代理 */
@property(nonatomic,assign) id<YPWaterFallViewDelegate> delegate;


/** 刷新数据, 调用这个方法就会重新调用数据源 代理方法, 刷新数据 */
- (void)reloadData;


/** 根据identifier 从缓存池中取出cell */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;


@end
