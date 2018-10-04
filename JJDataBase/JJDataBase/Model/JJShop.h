//
//  JJShop.h
//  JJDataBase
//
//  Created by 刘佳杰 on 2018/10/3.
//  Copyright © 2018年 Jiajie.Liu. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface JJShop : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double price;

@end
