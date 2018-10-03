//
//  FMDBViewController.m
//  JJDataBase
//
//  Created by 刘佳杰 on 2018/10/3.
//  Copyright © 2018年 Jiajie.Liu. All rights reserved.
//

#import "FMDBViewController.h"
#import "DataBaseView.h"
#import "DataBaseModel.h"
#import "FMDB.h"

@interface FMDBViewController ()

@property (nonatomic, strong) DataBaseView *baseView;
@property (nonatomic, strong) NSMutableArray <DataBaseModel *> *dataSource;
@property (nonatomic, strong) FMDatabase *db;

@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildBaseView];
    [self openFMDB];
}

- (void)buildBaseView {
    self.baseView = [[DataBaseView alloc] initWithFrame:self.view.bounds];
    self.baseView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.baseView];
    
    __weak typeof(self) weakSelf = self;
    self.baseView.searchBarBlock = ^(NSString *searchText) {
        __strong typeof(self) self = weakSelf;
        [self searchWithText:searchText];
    };
    
    self.baseView.insertDataBlock = ^(NSString *name, double price) {
        __strong typeof(self) self = weakSelf;
        [self insertDataWithName:name price:price];
    };
    
    self.baseView.numberOfRows = ^NSInteger {
        __strong typeof(self) self = weakSelf;
        return self.dataSource.count;
    };
    
    self.baseView.setCellBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath) {
        __strong typeof(self) self = weakSelf;
        DataBaseModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", model.price];
    };
}

- (void)openFMDB {
    //1、打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"mySQLite.sqlite"];
    self.db = [FMDatabase databaseWithPath:path];
    BOOL openResult = [self.db open];
    if (!openResult) {
        NSLog(@"打开数据库失败");
        return;
    }
    
    //2、创表
    NSString *sql = @"CREATE TABLE IF NOT EXISTS t_shop (id integer PRIMARY KEY, name text NOT NULL, price real);";
    BOOL createResult = [self.db executeUpdate:sql];
    if (!createResult) {
        NSLog(@"创表失败");
        return;
    }
    
    NSLog(@"创表成功");
    self.baseView.searchBarBlock(@"");
}

- (void)insertDataWithName:(NSString *)name price:(double)price {
    if (name.length <= 0 || price < 0.1) {
        return;
    }
    
    BOOL insertResult = [self.db executeUpdateWithFormat:@"INSERT INTO t_shop(name, price) VALUES (%@, %f);", name, price];
    if (!insertResult) {
        NSLog(@"插入失败");
    } else {
        DataBaseModel *model = [DataBaseModel new];
        model.name = name;
        model.price = price;
        [self.dataSource addObject:model];
    }
}

- (void)searchWithText:(NSString *)searchText {
    [self.dataSource removeAllObjects];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT name,price FROM t_shop WHERE name LIKE '%%%@%%' OR  price LIKE '%%%@%%' ;", searchText, searchText];
    
    FMResultSet *set = [self.db executeQuery:sql];
    while (set.next) {
        NSString *name = [set stringForColumn:@"name"];
        double price = [set doubleForColumn:@"price"];
        
        DataBaseModel *model = [DataBaseModel new];
        model.name = name;
        model.price = price;
        [self.dataSource addObject:model];
    }
}

- (NSMutableArray<DataBaseModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
