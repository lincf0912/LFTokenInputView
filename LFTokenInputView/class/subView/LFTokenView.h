//
//  LFTokenView.h
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/11.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFToken.h"
#import "LFTokenInputType.h"

@protocol LFTokenViewDelegate;

@interface LFTokenView : UIView <UIKeyInput>

/** 代理 */
@property (weak, nonatomic) id <LFTokenViewDelegate> delegate;

@property(strong, nonatomic) UIFont *font;            // default is nil (system font 17 plain)
/** 分隔符 */
@property (readonly, copy, nonatomic) NSString *delimiter; // default is ','

/** 设置选中 */
@property (assign, nonatomic) BOOL selected;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

/** 文字颜色 */
- (void)setTitleColor:(UIColor *)color forState:(LFTokenControlState)state;
/** 背景颜色 */
- (void)setBackgroundColor:(UIColor *)color forState:(LFTokenControlState)state;

- (UIColor *)titleColorForState:(LFTokenControlState)state;
- (UIColor *)backgroundColorForState:(LFTokenControlState)state;

/** 初始化 */
- (id)initWithToken:(LFToken *)token;
- (id)initWithToken:(LFToken *)token delimiter:(NSString *)delimiter;

@end

@protocol LFTokenViewDelegate <NSObject>

@required
- (void)tokenViewDidDeleted:(LFTokenView *)tokenView replaceWithText:(NSString *)replacementText;
- (void)tokenViewDidSelected:(LFTokenView *)tokenView;

@end
