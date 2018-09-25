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
#import <sqlite3.h>

static NSString * const kSQLCellIdentifier = @"SQLiteViewControllerTableViewCellIdentifier";

@interface SQLiteViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *priceField;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
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
        [self.dataSource addObject:[NSString stringWithFormat:@"%@: %.1f", self.nameField.text, self.priceField.text.doubleValue]];
        [self.tableView reloadData];
        [self.nameField resignFirstResponder];
        [self.priceField resignFirstResponder];
    }
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
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
    NSString *data = self.dataSource[indexPath.row];
    cell.textLabel.text = [[data componentsSeparatedByString:@":"] firstObject];
    cell.detailTextLabel.text = [[data componentsSeparatedByString:@": "] lastObject];
    return cell;
}

@end
