//
//  DataBaseAutoLayoutView.h
//  JJDataBase
//
//  Created by 刘佳杰 on 2018/10/4.
//  Copyright © 2018年 Jiajie.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataBaseAutoLayoutView : UIView

@property (nonatomic, strong) void (^setCellBlock)(UITableViewCell *cell, NSIndexPath *indexPath);
@property (nonatomic, strong) NSInteger (^numberOfRows)(void);
@property (nonatomic, strong) void (^searchBarBlock)(NSString *searchText);
@property (nonatomic, strong) void (^insertDataBlock)(NSString *name, double price);

@end
