//
//  UIColor+HXRandomColor.m
//  HXMall
//
//  Created by MacBook on 6/21/15.
//  Copyright (c) 2015 HXQC. All rights reserved.
//

#import "UIColor+HXRandomColor.h"

@implementation UIColor (HXRandomColor)
+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
