//
//  CoreDataViewController.m
//  JJDataBase
//
//  Created by 刘佳杰 on 2018/9/25.
//  Copyright © 2018年 Jiajie.Liu. All rights reserved.
//

#import "CoreDataViewController.h"
#import "DataBaseMasonryView.h"
#import "JJShop.h"
#import <CoreData/CoreData.h>

@interface CoreDataViewController ()

@property (nonatomic, strong) DataBaseMasonryView *baseView;
@property (nonatomic, strong) NSMutableArray <JJShop *> *dataSource;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation CoreDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildBaseView];
    [self setUpCoreData];
}

- (void)buildBaseView {
    self.baseView = [[DataBaseMasonryView alloc] initWithFrame:self.view.bounds];
    self.baseView.backgroundColor = [UIColor redColor];
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
        JJShop *model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", model.price];
    };
}

- (void)setUpCoreData {    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 持久化存储调度器
    // 持久化，把数据保存到一个文件，而不是内存
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];    
    // 告诉Coredata数据库的名字和路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"myCoreData.sqlite"];
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:path] options:nil error:nil];
    
    context.persistentStoreCoordinator = store;
    self.context = context;
    
    self.baseView.searchBarBlock(@"Iphone2");
}

- (void)insertDataWithName:(NSString *)name price:(double)price {
    if (name.length <= 0 || price < 0.1) {
        return;
    }
    
    JJShop *model = (JJShop *)[NSEntityDescription insertNewObjectForEntityForName:@"JJShop" inManagedObjectContext:self.context];
    model.name = name;
    model.price = price;
    [self.dataSource addObject:model];
    
    // 直接保存数据库
    NSError *error = nil;
    [self.context save:&error];
    
    if (error) {
        NSLog(@"插入失败: %@",error);
    }
}

- (void)searchWithText:(NSString *)searchText {
    if (searchText.length == 0) {
        return;
    }
    [self.dataSource removeAllObjects];
    
    // 1.FectchRequest 抓取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"JJShop"];
    
    // 2.设置过滤条件
    // 查找name为searchText的那一条
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name LIKE[cd] '*%@*'", searchText, searchText];
    request.predicate = pre;
    
    // 3.设置排序
    // 身高的升序排序
//    NSSortDescriptor *heigtSort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
//    request.sortDescriptors = @[heigtSort];
    
    
    // 4.执行请求
    NSError *error = nil;
    NSArray *models = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查询失败: %@",error);
    }
    
    for (JJShop *model in models) {
        [self.dataSource addObject:model];
    }
}

- (NSMutableArray<JJShop *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
