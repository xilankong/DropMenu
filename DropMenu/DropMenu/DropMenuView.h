//
//  DropMenuView.h
//  
//  下拉菜单
//  Created by yanghuang on 16/4/11.
//  Copyright © yanghuang All rights reserved.
//

#import "FilterTypeModel.h"
#import <UIKit/UIKit.h>
@class DropMenuView;

#pragma mark - 协议
@protocol DropMenuDelegate <NSObject>

@required
- (void)menu:(DropMenuView *)menu tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - 数据源

@protocol DropMenuDataSource <NSObject>

//防止下拉错位
- (CGFloat)menu_updateFilterViewPosition;

@required

- (NSMutableArray<FilterTypeModel *> *)menu_filterDataArray;

@end

#pragma mark - 下拉菜单

@interface DropMenuView : UIView

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *transformImageView;

@property (nonatomic, weak) id<DropMenuDataSource> dataSource;
@property (nonatomic, weak) id<DropMenuDelegate> delegate;

- (void)reloadData;
- (void)backgroundTapped;
- (void)menuTappedWithSuperView:(UIView *)view;

- (DropMenuView *)initWithOrigin:(CGPoint)origin;


@end
