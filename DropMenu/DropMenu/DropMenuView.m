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
//默认cell高度
#define tableViewCellHeight 45.f
//默认最大下拉高度
#define tableViewMaxHeight 315.f
//遮罩颜色
#define bgColor [UIColor colorWithWhite:0.0 alpha:0.3]
//默认未选中文案颜色
#define unselectColor [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]
//默认选中文案颜色
#define selectColor [UIColor colorWithRed:0.02 green:0.81 blue:0.76 alpha:1.0]


static NSString *identifier = @"dropMenuViewId";

@interface DropMenuView () <UITableViewDataSource, UITableViewDelegate>
 //是否显示
@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backGroundView;

@end

@implementation DropMenuView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    //列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //遮罩
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _backGroundView.backgroundColor = bgColor;
    _backGroundView.opaque = NO;
     //事件
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuHidden)];
    [_backGroundView addGestureRecognizer:gesture];
    [self addSubview:_backGroundView];
    [self addSubview:_tableView];
}

#pragma mark - 更新数据源
-(void)reloadData {
    _tableView.rowHeight = self.menuCellHeight ?: tableViewCellHeight;
    CGFloat maxHeight = self.menuMaxHeight?:tableViewMaxHeight;
    CGFloat count = [self.dataSource menu_numberOfRows];
    CGFloat height = count * _tableView.rowHeight  > maxHeight ? maxHeight : count * _tableView.rowHeight ;
    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, height);
    _tableView.scrollEnabled = count * _tableView.rowHeight  > maxHeight ? YES : NO;
    [_tableView reloadData];
}

#pragma mark - 触发下拉事件
- (void)menuShowInSuperView:(UIView *)view {
    if (!_show) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu_positionInSuperView)]) {
            CGPoint position = [self.delegate menu_positionInSuperView];
            self.frame = CGRectMake(position.x, position.y, self.frame.size.width, screenHeight - position.y);
        } else {
            self.frame = CGRectMake(0, 0, self.frame.size.width, screenHeight);
        }
        [view addSubview:self];
    }
    [UIView animateWithDuration:0.2 animations:^{
        _backGroundView.backgroundColor = _show ? [UIColor colorWithWhite:0.0 alpha:0.0] : bgColor;
        if (self.transformImageView) {
            self.transformImageView.transform = _show ? CGAffineTransformMakeRotation(0) : CGAffineTransformMakeRotation(M_PI);
        }
    } completion:^(BOOL finished) {
        if (_show) {
            [self removeFromSuperview];
        }
        _show = !_show;
    }];
    [self reloadData];
}

#pragma mark - 触发收起事件
- (void)menuHidden {
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
    return [self.dataSource menu_numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.dataSource menu_titleForRow:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = self.titleColor ?: unselectColor;
    cell.textLabel.highlightedTextColor = self.titleHightLightColor ?: selectColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([self.titleLabel.text isEqualToString:cell.textLabel.text]) {
        cell.textLabel.textColor = self.titleHightLightColor ?: selectColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.titleLabel.text = [self.dataSource menu_titleForRow:indexPath.row];
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        [self.delegate menu:self  didSelectRowAtIndexPath:indexPath];
        [self menuHidden];
    }
}

@end
