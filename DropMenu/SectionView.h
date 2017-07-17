//
//  SectionView.h
//  DropMenu
//
//  Created by huang on 2017/7/17.
//  Copyright © 2017年 com.yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionViewProtocol <NSObject>

- (void)clickAction;

@end

@interface SectionView : UIView
    
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenLabel;
@property (weak, nonatomic) id<SectionViewProtocol> delegate;

@end
