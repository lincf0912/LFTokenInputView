//
//  LFTokenInputHeader.h
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/11.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFTokenInputType.h"

extern CGFloat const LF_HSPACE;
extern CGFloat const LF_TEXT_FIELD_HSPACE; // Note: LF_PADDING_X
extern CGFloat const LF_VSPACE;
extern CGFloat const LF_MINIMUM_TEXTFIELD_WIDTH;
extern CGFloat const LF_PADDING_TOP;
extern CGFloat const LF_PADDING_BOTTOM;
extern CGFloat const LF_PADDING_LEFT;
extern CGFloat const LF_PADDING_RIGHT;
extern CGFloat const LF_STANDARD_ROW_HEIGHT;

extern CGFloat const LF_FIELD_MARGIN_X; // Note: LF_PADDING_X

extern CGFloat const LF_PADDING_X;
extern CGFloat const LF_PADDING_Y;

extern NSString * const LF_UNSELECTED_LABEL_FORMAT;
extern NSString const * LF_TITLE_COLOR;
extern NSString const * LF_BACKGROUND_COLOR;

#define LF_DefaultTextColor [UIColor colorWithRed:0.0823 green:0.4941 blue:0.9843 alpha:1.0]
extern NSString * titleColorKey(LFTokenControlState state);

extern NSString * backgroundColorKey(LFTokenControlState state);

@interface LFTokenInputHeader : NSObject

@end
