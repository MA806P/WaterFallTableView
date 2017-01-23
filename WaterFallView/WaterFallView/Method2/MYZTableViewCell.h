//
//  MYZTableViewCell.h
//  WaterFallView
//
//  Created by 159CaiMini02 on 17/1/23.
//  Copyright © 2017年 myz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYZItem;

@interface MYZTableViewCell : UITableViewCell

@property(nonatomic,strong) MYZItem * item;

+ (id)tableViewCellWithTableView:(UITableView *)tableView;

@end
