//
//  DAMessageLabel.h
//  TribeIPhone
//
//  Created by kita on 13-4-22.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAMessageLabel : UILabel
-(DAMessageLabel *)initWithContent:(NSString *)content font:(UIFont *)font breakMode:(NSLineBreakMode)breakMode maxFrame:(CGRect)maxFrame;
@end
