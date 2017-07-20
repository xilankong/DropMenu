//
//  DropMenuView.h
//
//  下拉菜单
//  Created by yanghuang on 16/4/11.
//  Copyright © yanghuang All rights reserved.
//

#import "DropMenuView.h"

#define screenHeight  [UIScreen mainScreen].bounds.size.height
#define screenWidth   [UIScreen mainScreen].bounds.size.width
//cell高度
#define tableViewCellHeight 45.f
//最大下拉高度
#define tableViewMaxHeight 315.f

#define bgColor [UIColor colorWithWhite:0.0 alpha:0.3]

#define unselectColor [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]

#define selectColor [UIColor colorWithRed:0.02 green:0.81 blue:0.76 alpha:1.0]


static NSString *identifier = @"dropMenuViewId";

@interface DropMenuView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL show; //是否显示
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSMutableArray *menuArray;

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DropMenuView

- (NSMutableArray<FilterTypeModel *> *)menuArray {
    if (!_menuArray) {
        _menuArray = [NSMutableArray array];
    }
    _menuArray = [self.dataSource menu_filterDataArray];
    return _menuArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //列表
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = tableViewCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //遮罩
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        _backGroundView.backgroundColor = bgColor;
        _backGroundView.opaque = NO;
        
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuHide)];
        [_backGroundView addGestureRecognizer:gesture];
        [self addSubview:_backGroundView];
        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark - 更新数据源
-(void)reloadData {
    CGFloat height = [self.menuArray count] * tableViewCellHeight > tableViewMaxHeight ? tableViewMaxHeight : [_menuArray count] * tableViewCellHeight;
    _tableView.frame = CGRectMake(_origin.x, 0, self.frame.size.width, height);
    _tableView.scrollEnabled = [_menuArray count] * tableViewCellHeight > tableViewMaxHeight ? YES : NO;
    
    [_tableView reloadData];
}

#pragma mark - 触发下拉事件
- (void)menuShowInSuperView:(UIView *)view {
    if (!_show) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu_filterViewPosition)]) {
            CGPoint position = [self.delegate menu_filterViewPosition];
            self.frame = CGRectMake(position.x, position.y, screenWidth, screenHeight - position.y);
        } else {
            self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        }
        [view addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            _backGroundView.backgroundColor = bgColor;
            if (self.transformImageView) {
                self.transformImageView.transform = CGAffineTransformMakeRotation(M_PI);
            }
        } completion:^(BOOL finished) {
            _show = !_show;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            if (self.transformImageView) {
                self.transformImageView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            _show = !_show;
        }];
    }
    [self reloadData];
}

#pragma mark - 触发收起事件
- (void)menuHide {
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
        [self menuHide];
    }
}

@end
