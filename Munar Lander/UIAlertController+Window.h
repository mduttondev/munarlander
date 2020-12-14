//
//  UIAlertController+Window.h
//  Munar lander
//
//  Created by Matthew Dutton on 12/14/20.
//  Copyright © 2020 Matthew Dutton. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Window)

- (void)show;
- (void)show:(BOOL)animated;

@end

@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *alertWindow;

@end

NS_ASSUME_NONNULL_END
