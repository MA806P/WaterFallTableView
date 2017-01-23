//
//  MYZWaterFallView.h
//  WaterFallView
//
//  Created by 159CaiMini02 on 17/1/23.
//  Copyright © 2017年 myz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYZWaterFallCell, MYZWaterFallView;


//设置枚举值, 用来判断设置间距
typedef enum
{
    MYZWaterFallViewMarginTypeTop,
    MYZWaterFallViewMarginTypeBottom,
    MYZWaterFallViewMarginTypeRight,
    MYZWaterFallViewMarginTypeLeft,
    MYZWaterFallViewMarginTypeColumn, //每一列
    MYZWaterFallViewMarginTypeRow //每一行
    
} MYZWaterFallViewMarginType;



/**
 *  数据源方法
 */
@protocol MYZWaterFallViewDataSource <NSObject>

//数据源方法,必须实现,告诉有多少数据,显示什么
@required

/** 用来设置一共有多少个数据 */
- (NSInteger)numberOfCellsInWaterFall:(MYZWaterFallView *)waterFallView;

/** 用来得到index位置的cell */
- (MYZWaterFallCell *)waterFall:(MYZWaterFallView *)waterFall cellAtIndex:(NSInteger)index;


@optional

/** 用来设置一共显示多少列, 默认的为3列 */
- (NSInteger)numberOfColumnsInWaterFall:(MYZWaterFallView *)waterFallView;

@end



/**
 *  代理方法
 */
@protocol MYZWaterFallViewDelegate <UIScrollViewDelegate>

@optional

/** 用来设置index位置的cell的高度 , 可选的,默认值为70 */
- (CGFloat)waterFallView:(MYZWaterFallView *)waterFallView heightAtIndex:(NSInteger)index;

/** 用来设置上下左右的间距, 根据枚举值来判断, 默认值上下左右行列都为10 */
-(CGFloat)waterFallView:(MYZWaterFallView *)waterFallView marginForType:(MYZWaterFallViewMarginType)type;

/** 选中的第index的cell */
- (void)waterFallView:(MYZWaterFallView *)waterFallView didSelectAtIndex:(NSInteger)index;


@end



@interface MYZWaterFallView : UIScrollView

/** 数据源 */
@property(nonatomic,assign) id<MYZWaterFallViewDataSource> dataSource;

/** 代理 */
@property(nonatomic,assign) id<MYZWaterFallViewDelegate> delegate;


/** 刷新数据, 调用这个方法就会重新调用数据源 代理方法, 刷新数据 */
- (void)reloadData;


/** 根据identifier 从缓存池中取出cell */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;


/** cell的宽度, 根据宽度比例,计算cell的高度 */
- (CGFloat)widthOfCell;

@end
