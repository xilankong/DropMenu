//
//  FilterTypeModel.h
//  DropMenu
//
//  Created by yanghuang on 2017/6/6.
//  Copyright © 2017年 com.yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterTypeModel : NSObject

@property (nonatomic, copy) NSString *filterName;
@property (nonatomic, copy) NSString *filterId;

- (instancetype)initWithName:(NSString *)filterName andId:(NSString *)filterId;

@end
