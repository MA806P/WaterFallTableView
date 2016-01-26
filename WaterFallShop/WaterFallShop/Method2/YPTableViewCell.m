//
//  YPTableViewCell.m
//  WaterFallShop
//
//  Created by qianfeng on 15/7/5.
//  Copyright (c) 2015年 MaYupeng. All rights reserved.
//

#import "YPTableViewCell.h"
#import "UIImageView+WebCache.h"

#import "YPShop.h"

@interface YPTableViewCell ()

@property(nonatomic,strong) UIImageView * imgView;

@end

@implementation YPTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+(id)tableViewCellWithTableView:(UITableView *)tableView
{
    YPTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[YPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cllID"];
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


-(void)setShop:(YPShop *)shop
{
    _shop = shop;
    
//    UIImageView * imgView = [[UIImageView alloc] init];
//    imgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [imgView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
//    [self.contentView addSubview:imgView];

    [self.imgView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
}


-(void)layoutSubviews
{
    self.imgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-10);
}







@end
