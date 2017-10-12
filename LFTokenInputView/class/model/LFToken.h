//
//  LFToken.h
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/11.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFToken : NSObject

/** 显示名称 */
@property (copy, nonatomic) NSString *displayText;
/** 御用对象 */
@property (strong, nonatomic) NSObject *context;

- (id)initWithDisplayText:(NSString *)displayText context:(NSObject *)context;

@end
