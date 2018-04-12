//
//  LFToken.m
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/11.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "LFToken.h"

@implementation LFToken

- (id)initWithDisplayText:(NSString *)displayText context:(NSObject *)context
{
    self = [super init];
    if (self) {
        self.displayText = displayText;
        self.context = context;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    LFToken *otherObject = (LFToken *)object;
    if (otherObject.context || self.context) {
        return [otherObject.context isEqual:self.context] || (otherObject.context == self.context);
    }
    if ([otherObject.displayText isEqualToString:self.displayText]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash
{
    return self.displayText.hash + self.context.hash;
}

@end
