//
//  MYZItemCell.h
//  WaterFallView
//
//  Created by 159CaiMini02 on 17/1/23.
//  Copyright © 2017年 myz. All rights reserved.
//

#import "MYZWaterFallCell.h"

@class MYZWaterFallView, MYZItem;

@interface MYZItemCell : MYZWaterFallCell

@property (nonatomic, strong) MYZItem * item;

+ (id)itemCellWithWaterFallView:(MYZWaterFallView *)waterFallView;

@end
