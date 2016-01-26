//
//  YPTableViewCell.h
//  WaterFallShop
//
//  Created by qianfeng on 15/7/5.
//  Copyright (c) 2015年 MaYupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YPShop;

@interface YPTableViewCell : UITableViewCell

@property(nonatomic,strong) YPShop * shop;

+(id)tableViewCellWithTableView:(UITableView *)tableView;


@end
