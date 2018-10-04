//
//  DataBaseAutoLayoutView.m
//  JJDataBase
//
//  Created by 刘佳杰 on 2018/10/4.
//  Copyright © 2018年 Jiajie.Liu. All rights reserved.
//

#import "DataBaseAutoLayoutView.h"
#import "UIView+Layout.h"
#import "UIScreen+Adaptive.h"

static NSString * const kSQLCellIdentifier = @"SQLiteViewControllerTableViewCellIdentifier";

@interface DataBaseAutoLayoutView () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *priceField;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation DataBaseAutoLayoutView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self buidupViews];
    }
    return self;
}

/*
 AutoLayout要点：
 1、设置view的translatesAutoresizingMaskIntoConstraints = NO；
 2、创建NSLayoutConstraint对象（constraintWithItem或VFL）；
 3、将创建好的NSLayoutConstraint对象add到view的父view上（注意）；
 */
- (void)buidupViews {
    _nameLabel = ({
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = @"名字";
        nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:nameLabel];
        nameLabel;
    });
    
    NSLayoutConstraint *nameLabelLeft = [NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20];
    NSLayoutConstraint *nameLabelTop = [NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:50];
    NSLayoutConstraint *nameLabelWidth = [NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35];
    NSLayoutConstraint *nameLabelHeight = [NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30];
    [self addConstraints:@[nameLabelLeft, nameLabelTop, nameLabelWidth, nameLabelHeight]];
    
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
    
    NSLayoutConstraint *nameFieldTop = [NSLayoutConstraint constraintWithItem:_nameField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_nameLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *nameFieldHeight = [NSLayoutConstraint constraintWithItem:_nameField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30];
    [self addConstraints:@[nameFieldTop, nameFieldHeight]];
    
    _priceLabel = ({
        UILabel *priceLabel = [UILabel new];
        priceLabel.text = @"价格";
        priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:priceLabel];
        priceLabel;
    });
    
    NSLayoutConstraint *priceLabelLeft = [NSLayoutConstraint constraintWithItem:_priceLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_nameLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *priceLabelTop = [NSLayoutConstraint constraintWithItem:_priceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
    NSLayoutConstraint *priceLabelWidth = [NSLayoutConstraint constraintWithItem:_priceLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_nameLabel attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *priceLabelHeight = [NSLayoutConstraint constraintWithItem:_priceLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_nameLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self addConstraints:@[priceLabelLeft, priceLabelTop, priceLabelWidth, priceLabelHeight]];
    
    _priceField = ({
        UITextField *priceField = [UITextField new];
        priceField.backgroundColor = [UIColor whiteColor];
        priceField.clearButtonMode = UITextFieldViewModeAlways;
        priceField.placeholder = @"输入商品价格";
        priceField.layer.cornerRadius = 5;
        priceField.layer.borderWidth = 1;
        priceField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:priceField];
        
        priceField.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:priceField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_nameField attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:priceField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_priceLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:priceField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_nameField attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:priceField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_nameField attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        [self addConstraints:@[left, top, width, height]];
        
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
        
        addBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:addBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_nameField attribute:NSLayoutAttributeTop multiplier:1.0 constant:15];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:addBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_priceField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15];
        [self addConstraints:@[top, bottom]];
        
        addBtn;
    });
    
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self addSubview:tableView];
        
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_priceField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraints:@[left, top, right, bottom]];
        
        tableView;
    });
    
    _searchBar = ({
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.frame = CGRectMake(0, 0, 320, 44);
        searchBar.delegate = self;
        _tableView.tableHeaderView = searchBar;
        searchBar;
    });
    
    // 用VFL语言添加约束
    CGFloat nameFieldW = [UIScreen mainScreen].bounds.size.width - 20 - 35 - 15 - 20 - 70 - 20;
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[nameLabel(35)]-15-[nameField(nameFieldW)]-20-[addBtn(70)]-20-|" options:0 metrics:@{@"nameFieldW" : @(nameFieldW)} views:@{@"nameLabel" : _nameLabel, @"nameField" : _nameField, @"addBtn" : _addBtn}];
    [self addConstraints:constraints];
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
