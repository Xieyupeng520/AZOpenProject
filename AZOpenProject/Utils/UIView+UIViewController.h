//
//  UIView+UIViewController.h
//  AZOpenProject
//
//  Created by cocozzhang on 2019/2/20.
//  Copyright © 2019 阿曌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (UIViewController)

///view对应的viewController
- (UIViewController*)viewController;

@end

NS_ASSUME_NONNULL_END
