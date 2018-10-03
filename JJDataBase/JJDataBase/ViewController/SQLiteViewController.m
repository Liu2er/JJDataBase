//
//  SQLiteViewController.m
//  JJDataBase
//
//  Created by 刘佳杰 on 2018/9/25.
//  Copyright © 2018年 Jiajie.Liu. All rights reserved.
//

#import "SQLiteViewController.h"
#import "DataBaseView.h"
#import "DataBaseModel.h"
#import <sqlite3.h>

@interface SQLiteViewController ()

@property (nonatomic, strong) DataBaseView *baseView;

@property (nonatomic, strong) NSMutableArray <DataBaseModel *> *dataSource;
@property (nonatomic, assign) sqlite3 *sqlite;

@end

@implementation SQLiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self buildBaseView];
    [self openSQLite];
}

- (void)buildBaseView {
    self.baseView = [[DataBaseView alloc] initWithFrame:self.view.bounds];
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

- (void)openSQLite {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"mySQLite.sqlite"];
    
    OSStatus status = sqlite3_open(path.UTF8String, &_sqlite);
    if (status == SQLITE_OK) {
        NSLog(@"打开数据库成功");
        
        const char *sql = "CREATE TABLE IF NOT EXISTS t_shop (id integer PRIMARY KEY, name text NOT NULL, price real);";
        char *errmsg;
        sqlite3_exec(self.sqlite, sql, NULL, NULL, &errmsg);
        
        if (errmsg) {
            NSLog(@"创表失败：%s", errmsg);
        } else {
            NSLog(@"创表成功");
            
            self.baseView.searchBarBlock(@"");
        }
        
    } else {
        NSLog(@"打开数据库失败");
    }
}

- (void)searchWithText:(NSString *)searchText {
    [self.dataSource removeAllObjects];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT name,price FROM t_shop WHERE name LIKE '%%%@%%' OR  price LIKE '%%%@%%' ;", searchText, searchText];
    // ppStmt是用来取出查询结果的
    sqlite3_stmt *ppStmt = NULL;
    OSStatus status = sqlite3_prepare_v2(self.sqlite, sql.UTF8String, -1, &ppStmt, NULL);
    if (status == SQLITE_OK) { // 准备成功 -- SQL语句正确
        while (sqlite3_step(ppStmt) == SQLITE_ROW) { // 成功取出一条数据
            const unsigned char *name = sqlite3_column_text(ppStmt, 0);
            double price = sqlite3_column_double(ppStmt, 1);
            
            DataBaseModel *model = [DataBaseModel new];
            model.name = [NSString stringWithUTF8String:(const char * _Nonnull)name];
            model.price = price;
            [self.dataSource addObject:model];
        }
    }
}

- (void)insertDataWithName:(NSString *)name price:(double)price {
    if (name.length <= 0 || price < 0.1) {
        return;
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_shop(name, price) VALUES ('%@', '%.1f');", name, price];
    char *errmsg;
    sqlite3_exec(self.sqlite, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"插入失败： %s", errmsg);
    } else {
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
