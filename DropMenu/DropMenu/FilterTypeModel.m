//
//  FilterTypeModel.m
//  DropMenu
//
//  Created by yanghuang on 2017/6/6.
//  Copyright © 2017年 com.yang. All rights reserved.
//

#import "FilterTypeModel.h"

@implementation FilterTypeModel

- (instancetype)initWithName:(NSString *)filterName andId:(NSString *)filterId
{
    self = [super init];
    if (self) {
        self.filterId = filterId;
        self.filterName = filterName;
    }
    return self;
}

@end
