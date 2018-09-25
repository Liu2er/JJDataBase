//
//  UIScreen+Adaptive.h
//  JJDataBase
//
//  Created by 刘佳杰 on 2018/9/25.
//  Copyright © 2018年 Jiajie.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#endif

@interface UIScreen (Adaptive)
/**
 *  same as [UIScreen mainScreen].bounds.size.width
 *
 */
+ (CGFloat)width;

/**
 * same as [UIScreen mainScreen].bounds.size.height
 *
 */
+ (CGFloat)height;
/**
 * the screen enlarge scale relative to original width 320
 *
 */
+ (CGFloat)scale;

+ (CGFloat)statusBarHeight;

+ (CGFloat)statusBarMargin;

+ (CGFloat)sensorHeight;

+ (CGFloat)homeIndicatorHeight;

+ (CGFloat)homeIndicatorWidth;

+ (CGFloat)homeIndicatorLeft;

+ (CGFloat)homeIndicatorRight;

+ (BOOL)iPhoneX;

@end
