//
//  LFDetectingTextField.m
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/11.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "LFDetectingTextField.h"

@implementation LFDetectingTextField

@dynamic delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Listen for the deleteBackward method from UIKeyInput protocol
- (void)deleteBackward
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidDelete:)]) {
        [self.delegate textFieldDidDelete:self];
    }
    
    // Call super afterwards, so the -text property will return text
    // prior to the delete
    [super deleteBackward];
}

// iOS 8.0后 deleteBackward 方法无效
// http://stackoverflow.com/a/25862878/9849
// 重写方法
- (BOOL)keyboardInputShouldDelete:(UITextField *)textField {
    BOOL shouldDelete = YES;
    
    if ([UITextField instancesRespondToSelector:_cmd]) {
        BOOL (*keyboardInputShouldDelete)(id, SEL, UITextField *) = (BOOL (*)(id, SEL, UITextField *))[UITextField instanceMethodForSelector:_cmd];
        
        if (keyboardInputShouldDelete) {
            shouldDelete = keyboardInputShouldDelete(self, _cmd, textField);
        }
    }
    
    if (![textField.text length] && [[[UIDevice currentDevice] systemVersion] intValue] >= 8) {
        [self deleteBackward];
    }
    
    return shouldDelete;
}

// 重写父类代理
- (void)setDelegate:(id <LFDetectingTextFieldDelegate>)delegate
{
    [super setDelegate:delegate];
}

@end
