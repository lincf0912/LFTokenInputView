//
//  LFTokenInputType.h
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/11.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#ifndef LFTokenInputType_h
#define LFTokenInputType_h

typedef NS_OPTIONS(NSUInteger, LFTokenControlState) {
    LFTokenControlStateNormal       = 0,
    LFTokenControlStateSelected     = 1 << 0,                  // flag usable by app (see below)
};

#endif /* LFTokenInputType_h */
