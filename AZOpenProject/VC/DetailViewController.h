//
//  DetailViewController.h
//  AZOpenProject
//
//  Created by cocozzhang on 2019/2/21.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property(nonatomic, assign) int index; //当前vc对应下标

- (instancetype)initWithIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
