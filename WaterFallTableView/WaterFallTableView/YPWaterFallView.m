//
//  YPWaterFallView.m
//  WaterFallTableView
//
//  Created by qianfeng on 15/7/2.
//  Copyright (c) 2015年 MaYupeng. All rights reserved.
//

#define YPWaterFallViewDefaultCellHeight 70
#define YPWaterFallViewDefaultMargin 10
#define YPWaterFallViewDefaultNumberOfColumns 3


#import "YPWaterFallView.h"
#import "YPWaterFallCell.h"

@interface YPWaterFallView ()

/** 用数组来保存每个cell的frame值, 有顺序的用数组来保存 */
@property(nonatomic,strong) NSMutableArray * cellFrames;


/** 用字典来存放某个位置对应的 正在展示的 cell, key值为位置的索引号,value为cell */
@property(nonatomic,strong) NSMutableDictionary * displaysCells;


/** 缓存池, 随机的使用set, 用于存放离开屏幕的cell, 在数据源中用到 */
@property(nonatomic,strong) NSMutableSet * reusableCells;


@end

@implementation YPWaterFallView


- (NSMutableArray *)cellFrames
{
    if (_cellFrames == nil) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}


-(NSMutableDictionary *)displaysCells
{
    if (_displaysCells == nil) {
        _displaysCells = [NSMutableDictionary dictionary];
    }
    
    return _displaysCells;
}


-(NSMutableSet *)reusableCells
{
    if(_reusableCells == nil)
    {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}


/**
 *  刷新数据
 */
-(void)reloadData
{
    //调用数据源方法得到cell的总数, 必须实现的方法, 不需要去判断是否实现了
    NSInteger numberOfCells = [self.dataSource numberOfCellsInWaterFall:self];
    
    
    //询问数据源一共有多少列
    NSInteger numberOfColumns = [self numberOfColumns];
    
    
    //间距
    CGFloat topM = [self marginForType:YPWaterFallViewMarginTypeTop];
    CGFloat bottomM = [self marginForType:YPWaterFallViewMarginTypeBottom];
    CGFloat leftM = [self marginForType:YPWaterFallViewMarginTypeLeft];
    CGFloat rightM = [self marginForType:YPWaterFallViewMarginTypeRight];
    CGFloat columnM = [self marginForType:YPWaterFallViewMarginTypeColumn];
    CGFloat rowM = [self marginForType:YPWaterFallViewMarginTypeRow];
    
    
    //宽度, 瀑布流的每个cell的宽度都是一样的
    CGFloat widthOfCell = (self.frame.size.width - leftM - rightM - (numberOfColumns-1)*columnM)/numberOfColumns;
    //注意numberOfColumns,numberOfCells 别混淆了
    
    
    
    //用一个数组来存放所有列的最大Y值, 初始值设为0
    CGFloat maxYOfColumns[numberOfColumns];
    for (int i=0; i<numberOfColumns; i++)
    {
        maxYOfColumns[i]=0.0;
    }
    
    
    //得到每个cell的frame值
    for (int i=0; i<numberOfCells; i++)
    {
    
        //询问代理在i位置上的cell的高度
        CGFloat heightOfCell = [self heightAtIndex:i];
        
        //此时cell的宽高都有了, 只要确定,xy就可以了,
        //每次添加cell到view中,总是添加到所有列中最短的后面
        
        //找到最短列的最大y值
        //先给定最短的列为第0列, 第一次添加cell就放到第一位,然后更改所在列的最大y值
        NSInteger cellColumn = 0;
        CGFloat maxYOfShortColumn = maxYOfColumns[cellColumn];
        
        for (int j=1; j<numberOfColumns; j++)
        {
            if(maxYOfColumns[j]<maxYOfShortColumn)
            {
                cellColumn=j;
                maxYOfShortColumn = maxYOfColumns[j];
            }
        }
        
        //确定了那一列最短cellColumn 和 最短列的最大的Y值maxYOfShortColumn, 就可以计算cell的xy值了
        
        CGFloat xOfCell = leftM + (widthOfCell+columnM)*cellColumn;
        //NSLog(@"%d = %.1lf %.1lf %.1lf ",i, leftM,widthOfCell, columnM);
        CGFloat yOfCell = 0.0;
        if(maxYOfShortColumn == 0.0)
        {
            yOfCell = topM; //如果添加到首行, y值就为顶部间距;
        }
        else
        {
            yOfCell = maxYOfShortColumn + rowM;
        }
        
        
        //将在i位置的cell的frame值存储在数组中
        CGRect cellFrame = CGRectMake(xOfCell, yOfCell, widthOfCell, heightOfCell);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        
        //更新最短那列的maxY的值
        maxYOfColumns[cellColumn] = CGRectGetMaxY(cellFrame);
        
        
        //显示cell
        //YPWaterFallCell * cell = [self.dataSource waterFall:self cellAtIndex:i];
        //cell.frame = cellFrame ;
        //[self addSubview:cell];
        //在这里问数据源要cell, 不好,
        //因为一直循环有多少数据就要多少,一下都创建完了不论显示不显示,性能不好
        
        
    }
    
    //设置scrollview的contentSize
    //先得到最长的那一列
    CGFloat contentH = maxYOfColumns[0];
    for (int i=1; i<numberOfColumns; i++)
    {
        if(contentH < maxYOfColumns[i])
        {
            contentH = maxYOfColumns[i];
        }
    }
    contentH += bottomM;
    self.contentSize = CGSizeMake(375, contentH);
    
    
    
    
}

/**
 *  当scrollView滚动时也会调用这个方法
 *  当scrollview滚动时, 再问数据源要数据, 显示多少要多少,
 *  超出屏幕的从字典中删除, 放到缓冲池中
 */

//当view加载出来的时候会调用两次
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //NSLog(@"layoutSubviews %ld",self.subviews.count);
    
    //向数据源索要对应位置的cell
    
    NSInteger numberOfCells = self.cellFrames.count;
    
    for (int i=0; i<numberOfCells; i++)
    {
        //获得i位置的cell的frame
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        
        //YPWaterFallCell * cell = [self.dataSource waterFall:self cellAtIndex:i];
        //cell.frame = cellFrame;
        //[self addSubview:cell];
        //NSLog(@"%d",i);
        //这个方法只要一滚动就会循环numberOfCells这么多次, 一动全部循环
        
        //改进创建一个字典, 用来存放创建的cell, 循环时判断i位置有没有cell
        //有cell就使用, 没有再创建
        
        //取出字典的 key: @(i) 对应的value
        YPWaterFallCell * cell = self.displaysCells[@(i)];
        // [self.displaysCells valueForKey:[NSString stringWithFormat:@"%d",i]];
        
        
        
        //判读cell的frame在不在屏幕上
        if([self isInScreen:cellFrame])
        {
            //如果在页面上, 再判读啊字典中对应的位置有没有对应的cell,没有问数据源要
            //如果有则不用管, 因为已经显示在屏幕上了
            if(cell == nil)
            {
                cell = [self.dataSource waterFall:self cellAtIndex:i];
                cell.frame = cellFrame;
                [self addSubview:cell];
                
                //存放到字典中
                //[self.displaysCells setValue:cell forKey:[NSString stringWithFormat:@"%d",i]];
                self.displaysCells[@(i)] = cell;
            }
        }
        else  //如果i位置上对应的cell的frame不在屏幕上, 说明滚动离开屏幕, 回收放到字典中
        {
            if(cell)
            {
                //将cell从scrollView中移除
                [cell removeFromSuperview];
                [self.displaysCells removeObjectForKey:@(i)];
                
                //放到缓存池
                [self.reusableCells addObject:cell];
                
            }
        }
        
    }

    //NSLog(@"%ld",self.subviews.count);
    
}


//这个方法是给数据源用的
-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    
    /**
     *  block对于其变量都会形成strong reference，就会形成 strong reference 循环，造成内存泄露，
     *  为了防止这种情况发生，在block外部应该创建一个week（__block） reference。
     */
    
    __block  YPWaterFallCell * reusableCell = nil ;
    
    
    //在集合中找到带有相同标识的cell
    [self.reusableCells enumerateObjectsUsingBlock:^(YPWaterFallCell * cell, BOOL *stop) {
        
        if([cell.identifier isEqualToString:identifier])
        {
            reusableCell = cell;
            * stop = YES;
        }
    }];
    
    //从缓存池中找到了cell后, 从集合中移除,
    //__block  YPWaterFallCell * reusableCell 指针指向cell, 不会被销毁
    if(reusableCell)
    {
        [self.reusableCells removeObject:reusableCell];
    }
    
    return reusableCell;
}


#pragma 私有方法

//先判断数据源方法是否实现, 若实现询问数据源一共有多少列,否则返回默认的3列
- (NSInteger)numberOfColumns
{
    if([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterFall:)])
    {
        return [self.dataSource numberOfColumnsInWaterFall:self];
    }
    else { return YPWaterFallViewDefaultNumberOfColumns; }
}

//询问代理获得在index位置的cell的高度, 若没有返回默认值70
- (CGFloat)heightAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(waterFallView:heightAtIndex:)]) {
        return [self.delegate waterFallView:self heightAtIndex:index];
    }
    else { return YPWaterFallViewDefaultCellHeight; }
}


//询问代理cell之间的间距, 若没有返回默认值10
- (CGFloat)marginForType:(YPWaterFallViewMarginType)type
{
    if([self.delegate respondsToSelector:@selector(waterFallView:marginForType:)])
    {
        return [self.delegate waterFallView:self marginForType:type];
    }
    else { return YPWaterFallViewDefaultMargin; }
}


//判断frame, 是否在屏幕中
-(BOOL)isInScreen:(CGRect)frame
{
    //注意scrollView的contentOffset 和 contentSize
    return (CGRectGetMaxY(frame) > self.contentOffset.y) &&
        (CGRectGetMinY(frame) < self.contentOffset.y + self.frame.size.height);
}


#pragma mark - 点击事件处理

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //如果代理中没有方法直接返回
    if (![self.delegate respondsToSelector:@selector(waterFallView:didSelectAtIndex:)])  return;
    
    UITouch * touch = [touches anyObject]; //多点触控任取一个触控对象
    CGPoint point = [touch locationInView:self]; //要写self, 不要写touch.view = cell
    
    
    //从显示在屏幕上的cell中找到, 包含触控点的那个cell
    __block NSNumber * selectIndex = nil;
    [self.displaysCells enumerateKeysAndObjectsUsingBlock:^(id key, YPWaterFallCell * cell, BOOL *stop) {
       
        //可能触控点, 在间隙位置, 
        if(CGRectContainsPoint(cell.frame, point))
        {
            selectIndex = key;
            *stop = YES;
        }
    }];
    
    //如果找到, 调用代理方法
    if(selectIndex)
    {
        [self.delegate waterFallView:self didSelectAtIndex:[selectIndex integerValue]];
    }
}


-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}



@end






