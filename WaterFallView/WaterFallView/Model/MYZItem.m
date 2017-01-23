//
//  MYZItem.m
//  WaterFallView
//
//  Created by 159CaiMini02 on 17/1/23.
//  Copyright © 2017年 myz. All rights reserved.
//

#import "MYZItem.h"

@implementation MYZItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.w = [dict[@"w"] floatValue];
        self.h = [dict[@"h"] floatValue];
        self.img = dict[@"img"];
        self.price = dict[@"price"];
    }
    
    return self;
}

+ (id)itemWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


@end
