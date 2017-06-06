//
//  DropMenuView.h
//
//  下拉菜单
//  Created by yanghuang on 16/4/11.
//  Copyright © yanghuang All rights reserved.
//

#import "DropMenuView.h"

#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
//cell高度
#define tableViewCellHeight 45.f
//最大下拉高度
#define tableViewMaxHeight 315.f

#define bgColor [UIColor colorWithWhite:0.0 alpha:0.3]

#define unselectColor [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]

#define selectColor [UIColor colorWithRed:0.02 green:0.81 blue:0.76 alpha:1.0]


static NSString *identifier = @"Cell";

@interface DropMenuView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL show; //是否显示
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *menuArray;

@end

@implementation DropMenuView

- (NSMutableArray<FilterTypeModel *> *)menuArray {
    if (!_menuArray) {
        _menuArray = [NSMutableArray array];
    }
    _menuArray = [self.dataSource menu_filterDataArray];
    return _menuArray;
}

#pragma mark - 初始化 根据位置
- (DropMenuView *)initWithOrigin:(CGPoint)origin {
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - origin.y)];
    if (self) {
        _origin = origin;
        _height = [self.menuArray count] * tableViewCellHeight > tableViewMaxHeight ? tableViewMaxHeight : [_menuArray count] * tableViewCellHeight;
        
        //列表
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, 0, self.frame.size.width, _height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = tableViewCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = [_menuArray count] * tableViewCellHeight > tableViewMaxHeight ? YES : NO;
        
        //遮罩
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, 0, self.frame.size.width, self.frame.size.height)];
        _backGroundView.backgroundColor = bgColor;
        _backGroundView.opaque = NO;
        
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
        [_backGroundView addGestureRecognizer:gesture];
        [self addSubview:_backGroundView];
        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark - 更新数据源
-(void)reloadData {
    _tableView.frame = CGRectMake(_origin.x, 0, self.frame.size.width, [self.menuArray count] * tableViewCellHeight);
    [_tableView reloadData];
}

#pragma mark - 触发下拉事件
- (void)menuTappedWithSuperView:(UIView *)view {
    if (!_show) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu_updateFilterViewPosition)]) {
            //防止错位
            CGFloat positionY = [self.dataSource menu_updateFilterViewPosition];
            self.frame = CGRectMake(0, positionY, SCREEN_WIDTH, SCREEN_HEIGHT - positionY);
        }

        NSUInteger index = 0;
        for (FilterTypeModel *model in _menuArray) {
            if ([model.filterName isEqualToString:self.titleLabel.text]) {
                index = [_menuArray indexOfObject:model];
            }
        }
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [view addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            _backGroundView.backgroundColor = bgColor;
            if (self.transformImageView) {
                self.transformImageView.transform = CGAffineTransformMakeRotation(M_PI);
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            if (self.transformImageView) {
                self.transformImageView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    _show = !_show;
}

#pragma mark - 触发收起事件
- (void)backgroundTapped {
    if (_show) {
        [UIView animateWithDuration:0.2 animations:^{
            _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            if (self.transformImageView) {
                self.transformImageView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished) {
            _show = !_show;
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - 代理、数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSource menu_filterDataArray] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    FilterTypeModel *model = [self.dataSource menu_filterDataArray][indexPath.row];
    cell.textLabel.text = model.filterName;
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = unselectColor;
    cell.textLabel.highlightedTextColor = selectColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([self.titleLabel.text isEqualToString:cell.textLabel.text]) {
        cell.textLabel.textColor = selectColor;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FilterTypeModel *model = [self.dataSource menu_filterDataArray][indexPath.row];
    self.titleLabel.text = model.filterName;
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate menu:self tableView:tableView didSelectRowAtIndexPath:indexPath];
        [self backgroundTapped];
    }
}

@end
