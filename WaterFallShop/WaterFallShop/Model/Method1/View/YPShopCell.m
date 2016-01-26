//
//  YPShopCell.m
//  WaterFallShop
//
//  Created by qianfeng on 15/7/4.
//  Copyright (c) 2015年 MaYupeng. All rights reserved.
//

#import "YPShopCell.h"
#import "YPWaterFallView.h"
#import "YPShop.h"

#import "UIImageView+WebCache.h"

@interface YPShopCell ()

@property(nonatomic,weak) UIImageView * imgView;
@property(nonatomic,weak) UILabel * priceLab;

@end

@implementation YPShopCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UIImageView * imageView11 = [[UIImageView alloc] init];
        [self addSubview:imageView11];
        self.imgView = imageView11;
        
        
        UILabel * priceLab = [[UILabel alloc] init];
        priceLab.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        priceLab.textColor = [UIColor whiteColor];
        priceLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:priceLab];
        self.priceLab = priceLab;
    }
    return self;
}



+(id)shopCellWithWaterFallView:(YPWaterFallView *)waterFallView
{
    YPShopCell * cell = [waterFallView dequeueReusableCellWithIdentifier:@"shopCell"];
    
    if(cell == nil)
    {
        cell = [[YPShopCell alloc] init];
        cell.identifier = @"shopCell";
    }
    return cell;
}


-(void)setShop:(YPShop *)shop
{
        _shop = shop;
    
        self.priceLab.text = shop.price;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgView.frame = self.bounds;
    self.priceLab.frame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
}



@end
