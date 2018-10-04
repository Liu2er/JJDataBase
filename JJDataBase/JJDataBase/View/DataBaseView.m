//
//  DataBaseView.m
//  JJDataBase
//
//  Created by 刘佳杰 on 2018/10/3.
//  Copyright © 2018年 Jiajie.Liu. All rights reserved.
//

#import "DataBaseView.h"
#import "UIView+Layout.h"
#import "UIScreen+Adaptive.h"

static NSString * const kSQLCellIdentifier = @"SQLiteViewControllerTableViewCellIdentifier";

@interface DataBaseView () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *priceField;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation DataBaseView

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
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 35, 30)];
        nameLabel.text = @"名字";
        nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:nameLabel];
        nameLabel;
    });
    
    _nameField = ({
        UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(_nameLabel.right + 15, _nameLabel.top, 200, _nameLabel.height)];
        nameField.backgroundColor = [UIColor whiteColor];
        nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        nameField.placeholder = @"输入商品名字";
        nameField.layer.cornerRadius = 5;
        nameField.layer.borderWidth = 1;
        nameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:nameField];
        nameField;
    });
    
    _priceLabel = ({
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 10, _nameLabel.width, _nameLabel.height)];
        priceLabel.text = @"价格";
        priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:priceLabel];
        priceLabel;
    });
    
    _priceField = ({
        UITextField *priceField = [[UITextField alloc] initWithFrame:CGRectMake(_nameField.left, _priceLabel.top, _nameField.width, _priceLabel.height)];
        priceField.backgroundColor = [UIColor whiteColor];
        priceField.clearButtonMode = UITextFieldViewModeAlways;
        priceField.placeholder = @"输入商品价格";
        priceField.layer.cornerRadius = 5;
        priceField.layer.borderWidth = 1;
        priceField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:priceField];
        priceField;
    });
    
    _addBtn = ({
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.nameField.right + 20, self.nameField.bottom - 17, 100, 40)];
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
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.priceField.bottom + 20, [UIScreen width], [UIScreen height] - (self.priceField.bottom + 20)) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self addSubview:tableView];
        tableView;
    });
    
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
