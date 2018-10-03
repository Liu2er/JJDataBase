//
//  SQLiteViewController.m
//  JJDataBase
//
//  Created by 刘佳杰 on 2018/9/25.
//  Copyright © 2018年 Jiajie.Liu. All rights reserved.
//

#import "SQLiteViewController.h"
#import "UIView+Layout.h"
#import "UIScreen+Adaptive.h"
#import "DataBaseModel.h"
#import <sqlite3.h>

static NSString * const kSQLCellIdentifier = @"SQLiteViewControllerTableViewCellIdentifier";

@interface SQLiteViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *priceField;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray <DataBaseModel *> *dataSource;
@property (nonatomic, assign) sqlite3 *sqlite;

@end

@implementation SQLiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameField = ({
        UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, 200, 30)];
        nameField.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:nameField];
        nameField;
    });
    
    self.priceField = ({
        UITextField *priceField = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, 200, 30)];
        priceField.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:priceField];
        priceField;
    });
    
    self.addBtn = ({
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.nameField.right + 20, self.nameField.bottom - 17, 50, 40)];
        [addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(insertData) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addBtn];
        addBtn;
    });
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.priceField.bottom + 20, [UIScreen width], [UIScreen height] - (self.priceField.bottom + 20)) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.view addSubview:tableView];
        tableView;
    });
    
    // 增加搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, 320, 44);
    searchBar.delegate = self;
    self.searchBar = searchBar;
    self.tableView.tableHeaderView = searchBar;
    
    self.view.backgroundColor = [UIColor redColor];
    
    
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
            [self searchBar:self.searchBar textDidChange:@""];
        }
        
    } else {
        NSLog(@"打开数据库失败");
    }
}

- (void)insertData {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_shop(name, price) VALUES ('%@', '%.1f');", self.nameField.text, self.priceField.text.doubleValue];
    char *errmsg;
    sqlite3_exec(self.sqlite, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"插入失败： %s", errmsg);
    } else {
        DataBaseModel *model = [DataBaseModel new];
        model.name = self.nameField.text;
        model.price = self.priceField.text.doubleValue;
        [self.dataSource addObject:model];
        [self.tableView reloadData];
        [self.nameField resignFirstResponder];
        [self.priceField resignFirstResponder];
    }
}

- (NSMutableArray<DataBaseModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
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
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSQLCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kSQLCellIdentifier];
    }
    DataBaseModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", model.price];
    return cell;
}

@end
