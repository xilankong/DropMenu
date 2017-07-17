//
//  ViewController.m
//  DropMenu
//
//  Created by yanghuang on 2017/6/6.
//  Copyright © 2017年 com.yang. All rights reserved.
//

#import "ViewController.h"
#import "DropMenuView.h"
#import "SectionView.h"

#define screenHeight  [UIScreen mainScreen].bounds.size.height
#define screenWidth   [UIScreen mainScreen].bounds.size.width
#define tableViewHeaderHeight 150
#define tableViewSectionHeight 45
@interface ViewController ()<DropMenuDelegate, DropMenuDataSource, UITableViewDataSource, UITableViewDelegate, SectionViewProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SectionView *sectionView;
@property (nonatomic, strong) DropMenuView *menuView;

@property (nonatomic, strong) NSMutableArray *menuArray;
@end

@implementation ViewController

- (DropMenuView *)menuView {
    if (!_menuView && [self.menuArray count] > 0) {
        _menuView = [[DropMenuView alloc] initWithOrigin:CGPointMake(0, self.tableView.tableHeaderView.frame.size.height + self.sectionView.frame.size.height)];
        _menuView.dataSource = self;
        _menuView.delegate = self;
    }
    return _menuView;
}

- (SectionView *)sectionView {
    if (!_sectionView) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"SectionView" owner:nil options:nil];
        UIView *view = [array lastObject];
        _sectionView = (SectionView *)view;
        _sectionView.delegate = self;
    }
    return _sectionView;
}

- (NSMutableArray *)menuArray {
    if (!_menuArray) {
        _menuArray = [NSMutableArray array];
        FilterTypeModel *model = [[FilterTypeModel alloc]initWithName:@"菜单一" andId:@"one"];
        FilterTypeModel *model2 = [[FilterTypeModel alloc]initWithName:@"菜单二" andId:@"two"];
        FilterTypeModel *model3 = [[FilterTypeModel alloc]initWithName:@"菜单三" andId:@"three"];
        FilterTypeModel *model4 = [[FilterTypeModel alloc]initWithName:@"菜单四" andId:@"four"];
        FilterTypeModel *model5 = [[FilterTypeModel alloc]initWithName:@"菜单五" andId:@"five"];
        FilterTypeModel *model6 = [[FilterTypeModel alloc]initWithName:@"菜单六" andId:@"six"];
        FilterTypeModel *model7 = [[FilterTypeModel alloc]initWithName:@"菜单七" andId:@"seven"];
        FilterTypeModel *model8 = [[FilterTypeModel alloc]initWithName:@"菜单八" andId:@"eight"];
        FilterTypeModel *model9 = [[FilterTypeModel alloc]initWithName:@"菜单九" andId:@"night"];
        FilterTypeModel *model10 = [[FilterTypeModel alloc]initWithName:@"菜单十" andId:@"ten"];
        FilterTypeModel *model11 = [[FilterTypeModel alloc]initWithName:@"菜单十一" andId:@"eleven"];
        [_menuArray addObject:model];
        [_menuArray addObject:model2];
        [_menuArray addObject:model3];
        [_menuArray addObject:model4];
        [_menuArray addObject:model5];
        [_menuArray addObject:model6];
        [_menuArray addObject:model7];
        [_menuArray addObject:model8];
        [_menuArray addObject:model9];
        [_menuArray addObject:model10];
        [_menuArray addObject:model11];
    }
    return _menuArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, tableViewHeaderHeight)];
    v.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = v;
    self.menuView.transformImageView = self.sectionView.arrowImageView;
    self.menuView.titleLabel = self.sectionView.screenLabel;
    [self.menuView reloadData];
    
    self.sectionView.screenLabel.text = ((FilterTypeModel *)self.menuArray[0]).filterName;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}
    
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.sectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableViewSectionHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellInView"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellInView"];
    }
    cell.textLabel.text = @"123456";
    return cell;
}

#pragma mark menuDelegate

- (NSMutableArray<FilterTypeModel *> *)menu_filterDataArray {
    return self.menuArray;
}

- (CGFloat)menu_updateFilterViewPosition {
    if (self.tableView.contentOffset.y + 64 > tableViewHeaderHeight) {
        return tableViewSectionHeight + 64;
    } else {
        return self.tableView.tableHeaderView.frame.size.height + tableViewSectionHeight - self.tableView.contentOffset.y;
    }
}

- (void)menu:(DropMenuView *)menu tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark sectionViewDelegate

- (void)clickAction {
    [self.menuView menuTappedWithSuperView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
    
@end
