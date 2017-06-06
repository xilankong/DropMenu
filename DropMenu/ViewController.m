//
//  ViewController.m
//  DropMenu
//
//  Created by yanghuang on 2017/6/6.
//  Copyright © 2017年 com.yang. All rights reserved.
//

#import "ViewController.h"
#import "DropMenuView.h"

@interface ViewController ()<DropMenuDelegate, DropMenuDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (nonatomic, strong) DropMenuView *menuView;
@property (nonatomic, strong) NSMutableArray *menuArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filterLabel.text = ((FilterTypeModel *)self.menuArray[0]).filterName;
    [self.menuView reloadData];
}

-(NSMutableArray<FilterTypeModel *> *)menu_filterDataArray {
    return self.menuArray;
}

-(void)menu:(DropMenuView *)menu tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)filterAction:(id)sender {
    [self.menuView menuTappedWithSuperView:self.view];
}

- (DropMenuView *)menuView {
    if (!_menuView && [self.menuArray count] > 0) {
        _menuView = [[DropMenuView alloc] initWithOrigin:CGPointMake(0, self.filterView.frame.origin.y + self.filterView.frame.size.height)];
        _menuView.transformImageView = self.arrowImage;
        _menuView.titleLabel = self.filterLabel;
        _menuView.dataSource = self;
        _menuView.delegate = self;
    }
    return _menuView;
}

-(NSMutableArray *)menuArray {
    if (!_menuArray) {
        _menuArray = [NSMutableArray array];
        FilterTypeModel *model = [[FilterTypeModel alloc]initWithName:@"菜单一" andId:@"one"];
        FilterTypeModel *model2 = [[FilterTypeModel alloc]initWithName:@"菜单二" andId:@"two"];
        FilterTypeModel *model3 = [[FilterTypeModel alloc]initWithName:@"菜单三" andId:@"three"];
        FilterTypeModel *model4 = [[FilterTypeModel alloc]initWithName:@"菜单四" andId:@"four"];
        [_menuArray addObject:model];
        [_menuArray addObject:model2];
        [_menuArray addObject:model3];
        [_menuArray addObject:model4];
    }
    return _menuArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
