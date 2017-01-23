//
//  MYZItem.h
//  WaterFallView
//
//  Created by 159CaiMini02 on 17/1/23.
//  Copyright © 2017年 myz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MYZItem : NSObject

@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *price;

+ (id)itemWithDict:(NSDictionary *)dict;

@end
