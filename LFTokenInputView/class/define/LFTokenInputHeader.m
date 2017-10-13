//
//  LFTokenInputHeader.m
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/11.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "LFTokenInputHeader.h"

CGFloat const LF_HSPACE = 0.0;
CGFloat const LF_TEXT_FIELD_HSPACE = 4.0; // Note: LF_PADDING_X
CGFloat const LF_VSPACE = 4.0;
CGFloat const LF_MINIMUM_TEXTFIELD_WIDTH = 56.0;
CGFloat const LF_PADDING_TOP = 10.0;
CGFloat const LF_PADDING_BOTTOM = 10.0;
CGFloat const LF_PADDING_LEFT = 8.0;
CGFloat const LF_PADDING_RIGHT = 8.0;
CGFloat const LF_STANDARD_ROW_HEIGHT = 24.0;

CGFloat const LF_FIELD_MARGIN_X = 4.0; // Note: LF_PADDING_X

CGFloat const LF_PADDING_X = 4.0;
CGFloat const LF_PADDING_Y = 2.0;

NSString const * LF_TITLE_COLOR = @"LF_TITLE_COLOR";
NSString const * LF_BACKGROUND_COLOR = @"LF_BACKGROUND_COLOR";

NSString * titleColorKey(LFTokenControlState state)
{
    return [NSString stringWithFormat:@"%@_%d", LF_TITLE_COLOR, (int)state];
}

NSString * backgroundColorKey(LFTokenControlState state)
{
    return [NSString stringWithFormat:@"%@_%d", LF_BACKGROUND_COLOR, (int)state];
}

@implementation LFTokenInputHeader

@end
