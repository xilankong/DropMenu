//
//  DropMenuView.h
//  
//  下拉菜单
//  Created by yanghuang on 16/4/11.
//  Copyright © yanghuang All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropMenuView;

#pragma mark - 协议
@protocol DropMenuDelegate <NSObject>

@required
//出现位置
- (CGPoint)menu_positionInSuperView;
//点击事件
- (void)menu:(DropMenuView *)menu  didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - 数据源
@protocol DropMenuDataSource <NSObject>

@required
//设置title
- (NSString *)menu_titleForRow:(NSInteger)row;
//设置size
- (NSInteger)menu_numberOfRows;

@end

#pragma mark - 下拉菜单

@interface DropMenuView : UIView

@property (nonatomic, assign) CGFloat menuCellHeight;
@property (nonatomic, assign) CGFloat menuMaxHeight;
@property (nonatomic, strong) UIColor *titleHightLightColor;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *transformImageView;
@property (nonatomic, weak) id<DropMenuDataSource> dataSource;
@property (nonatomic, weak) id<DropMenuDelegate> delegate;

- (void)reloadData;
- (void)menuHidden;
- (void)menuShowInSuperView:(UIView *)view;


@end
