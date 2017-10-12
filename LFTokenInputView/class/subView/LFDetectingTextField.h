//
//  LFDetectingTextField.h
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/11.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFDetectingTextFieldDelegate;

@interface LFDetectingTextField : UITextField <UIKeyInput>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-property-type"
@property (weak, nonatomic) id <LFDetectingTextFieldDelegate> delegate;
#pragma clang diagnostic pop

@end

@protocol LFDetectingTextFieldDelegate <UITextFieldDelegate>

/** 异步线程 */
- (void)textFieldDidDelete:(UITextField *)textField;

@end
