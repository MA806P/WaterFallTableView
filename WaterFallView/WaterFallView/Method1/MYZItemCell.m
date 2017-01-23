//
//  MYZItemCell.m
//  WaterFallView
//
//  Created by 159CaiMini02 on 17/1/23.
//  Copyright © 2017年 myz. All rights reserved.
//

#import "MYZItemCell.h"
#import "MYZWaterFallView.h"
#import "MYZItem.h"
#import "UIImageView+WebCache.h"

@interface MYZItemCell ()

@property(nonatomic,weak) UIImageView * imgView;
@property(nonatomic,weak) UILabel * priceLab;

@end

@implementation MYZItemCell


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



+ (id)itemCellWithWaterFallView:(MYZWaterFallView *)waterFallView
{
    MYZItemCell * cell = [waterFallView dequeueReusableCellWithIdentifier:@"ItemCell"];
    
    if(cell == nil)
    {
        cell = [[MYZItemCell alloc] init];
        cell.identifier = @"ItemCell";
    }
    return cell;
}


- (void)setItem:(MYZItem *)item
{
    _item = item;
    
    self.priceLab.text = item.price;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"loading"]];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgView.frame = self.bounds;
    self.priceLab.frame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
}


@end
