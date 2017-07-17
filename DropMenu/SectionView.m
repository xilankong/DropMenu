//
//  SectionView.m
//  DropMenu
//
//  Created by huang on 2017/7/17.
//  Copyright © 2017年 com.yang. All rights reserved.
//

#import "SectionView.h"

@implementation SectionView

-(void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)clickAction:(id)sender {
    [self.delegate performSelector:@selector(clickAction) withObject:nil];
}

@end
