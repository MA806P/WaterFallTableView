//
//  MYZTableViewCell.m
//  WaterFallView
//
//  Created by 159CaiMini02 on 17/1/23.
//  Copyright © 2017年 myz. All rights reserved.
//

#import "MYZTableViewCell.h"
#import "MYZItem.h"
#import "UIImageView+WebCache.h"

@interface MYZTableViewCell ()

@property(nonatomic,strong) UIImageView * imgView;

@end

@implementation MYZTableViewCell


+(id)tableViewCellWithTableView:(UITableView *)tableView
{
    MYZTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[MYZTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cllID"];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIImageView * imgView = [[UIImageView alloc] init];
        [self addSubview:imgView];
        self.imgView = imgView;
    }
    return self;
}


-(void)setItem:(MYZItem *)item
{
    _item = item;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
}

-(void)layoutSubviews
{
    self.imgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-10);
}


@end
