//
//  YPShopCell.h
//  WaterFallShop
//
//  Created by qianfeng on 15/7/4.
//  Copyright (c) 2015年 MaYupeng. All rights reserved.
//

#import "YPWaterFallCell.h"
@class YPShop , YPWaterFallView;

@interface YPShopCell : YPWaterFallCell


@property(nonatomic,strong) YPShop * shop;


+(id)shopCellWithWaterFallView:(YPWaterFallView *)waterFallView;


@end
