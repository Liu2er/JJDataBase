//
//  DataBaseMasonryView.m
//  JJDataBase
//
//  Created by 刘佳杰 on 2018/10/4.
//  Copyright © 2018年 Jiajie.Liu. All rights reserved.
//

#import "DataBaseMasonryView.h"
#import "Masonry.h"

static NSString * const kSQLCellIdentifier = @"SQLiteViewControllerTableViewCellIdentifier";

@interface DataBaseMasonryView () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *priceField;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation DataBaseMasonryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self buidupViews];
    }
    return self;
}

- (void)buidupViews {
    _nameLabel = ({
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = @"名字";
        nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:nameLabel];
        nameLabel;
    });
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@50);
        make.width.equalTo(@35);
        make.height.equalTo(@30);
    }];
    
    _nameField = ({
        UITextField *nameField = [UITextField new];
        nameField.backgroundColor = [UIColor whiteColor];
        nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        nameField.placeholder = @"输入商品名字";
        nameField.layer.cornerRadius = 5;
        nameField.layer.borderWidth = 1;
        nameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        nameField.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:nameField];
        nameField;
    });
    
    __weak typeof(self) weakSelf = self;
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(self) self = weakSelf;
        make.left.equalTo(self.nameLabel.mas_right).with.offset(20);
        make.top.equalTo(self.nameLabel.mas_top);
        make.width.equalTo(@200);
        make.height.equalTo(self.nameLabel.mas_height);
    }];
    
    _priceLabel = ({
        UILabel *priceLabel = [UILabel new];
        priceLabel.text = @"价格";
        priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:priceLabel];
        priceLabel;
    });
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(self) self = weakSelf;
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(10);
        make.width.equalTo(self.nameLabel.mas_width);
        make.height.equalTo(self.nameLabel.mas_height);
    }];
    
    _priceField = ({
        UITextField *priceField = [UITextField new];
        priceField.backgroundColor = [UIColor whiteColor];
        priceField.clearButtonMode = UITextFieldViewModeAlways;
        priceField.placeholder = @"输入商品价格";
        priceField.layer.cornerRadius = 5;
        priceField.layer.borderWidth = 1;
        priceField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:priceField];
        priceField;
    });
    
    [self.priceField mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(self) self = weakSelf;
        make.left.equalTo(self.nameField.mas_left);
        make.top.equalTo(self.priceLabel.mas_top);
        make.width.equalTo(self.nameField.mas_width);
        make.height.equalTo(self.priceLabel.mas_height);
    }];
    
    _addBtn = ({
        UIButton *addBtn = [[UIButton alloc] init];
        [addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [addBtn addTarget:self action:@selector(insertDataAction) forControlEvents:UIControlEventTouchUpInside];
        addBtn.layer.cornerRadius = 5;
        addBtn.layer.borderWidth = 1;
        addBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:addBtn];
        addBtn;
    });
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(self) self = weakSelf;
        make.left.equalTo(self.nameField.mas_right).with.offset(20); //with容易写成width，会崩溃
        make.right.equalTo(self.mas_right).with.offset(-20); //不能用self.mas_width，会崩溃
        make.top.equalTo(self.nameField.mas_top).with.offset(15);
        make.bottom.equalTo(self.priceField.mas_bottom).with.offset(-15);
    }];
    
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self addSubview:tableView];
        tableView;
    });
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(self) self = weakSelf;
        make.left.equalTo(@0);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.priceField.mas_bottom).with.offset(20);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    _searchBar = ({
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.frame = CGRectMake(0, 0, 320, 44);
        searchBar.delegate = self;
        _tableView.tableHeaderView = searchBar;
        searchBar;
    });
}

- (void)insertDataAction {
    if (self.insertDataBlock) {
        self.insertDataBlock(self.nameField.text, self.priceField.text.doubleValue);
        [self.tableView reloadData];
        self.nameField.text = @"";
        self.priceField.text = @"";
        [self.nameField resignFirstResponder];
        [self.priceField resignFirstResponder];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.searchBar) {
        self.searchBarBlock(searchText);
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.numberOfRows) {
        return self.numberOfRows();
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSQLCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kSQLCellIdentifier];
    }
    if (self.setCellBlock) {
        self.setCellBlock(cell, indexPath);
    }
    return cell;
}

@end
