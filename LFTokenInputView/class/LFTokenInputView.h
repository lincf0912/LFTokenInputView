//
//  LFTokenInputView.h
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/11.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFToken.h"
#import "LFTokenInputType.h"

@protocol LFTokenInputViewDelegate, LFTokenInputViewDataSource;

@interface LFTokenInputView : UIView

/** 代理 */
@property (weak, nonatomic) id <LFTokenInputViewDelegate> delegate;
/**
 * 实现数据源代理自动生成列表，可不实现
 * 注意：提供数据源的LFToken.context 必须为NSString类型，否则请参照LFTokenTableView自行实现
 */
@property (weak, nonatomic) id <LFTokenInputViewDataSource> dataSource;

/** 一个可选的视图显示在输入框左边 */
@property (strong, nonatomic) UIView *fieldView;
/** 一个可选的视图显示在输入框右边 */
@property (strong, nonatomic) UIView *accessoryView;
/** 可以在第一行显示选项的文本（如“To：”） */
@property (copy, nonatomic) NSString *fieldName;
/** 占位符 */
@property (copy, nonatomic) NSString *placeholderText;
/** 分隔符 */
@property (copy, nonatomic) NSString *delimiter; // default is ','
/** 文字颜色 */
- (void)setTokenTitleColor:(UIColor *)color forState:(LFTokenControlState)state;
/** 背景颜色 */
- (void)setTokenBackgroundColor:(UIColor *)color forState:(LFTokenControlState)state;

- (UIColor *)tokenTitleColorForState:(LFTokenControlState)state;
- (UIColor *)tokenBackgroundColorForState:(LFTokenControlState)state;


@property(strong, nonatomic) UIColor *textColor;            // default is nil. use opaque black
@property(strong, nonatomic) UIFont *font;                 // default is nil. use system font 12 pt
/** 键盘类型 */
@property (assign, nonatomic) UIKeyboardType keyboardType; // default is UIKeyboardTypeEmailAddress
/** 首字母是否大写 */
@property (assign, nonatomic) IBInspectable UITextAutocapitalizationType autocapitalizationType; // default is UITextAutocorrectionTypeNo
/** 是否纠错 */
@property (assign, nonatomic) IBInspectable UITextAutocorrectionType autocorrectionType; // default is UITextAutocapitalizationTypeNone
/** 底部分割线 */
@property (assign, nonatomic) IBInspectable BOOL drawBottomBorder;

/** 当前所有对象 */
@property (strong, nonatomic) NSArray <LFToken *>*allTokens;
/** 是否编辑状态 */
@property (readonly, nonatomic, getter = isEditing) BOOL editing;

- (void)addToken:(LFToken *)token;
- (void)removeToken:(LFToken *)token;

/* 取消所选 */
- (void)unselectAllTokenViewsAnimated:(BOOL)animated;

/** 激活编辑 */
- (void)beginEditing;
/** 放弃编辑 */
- (void)endEditing;

@end

@protocol LFTokenInputViewDelegate <NSObject>

@optional

/**
 * token选中情况下被点击
 */
- (void)tokenInputView:(LFTokenInputView *)view didSelectedToken:(LFToken *)token;
/**
 * 当文本域文本被改变时调用
 */
- (void)tokenInputView:(LFTokenInputView *)view didChangeText:(NSString *)text;
/**
 * 在添加token时调用
 */
- (void)tokenInputView:(LFTokenInputView *)view didAddToken:(LFToken *)token;
/**
 * 当token被移除时调用
 */
- (void)tokenInputView:(LFTokenInputView *)view didRemoveToken:(LFToken *)token;
/**
 * 当用户按下回车键（return）时调用，返回一个token，若返回nil，不接受。
 */
- (LFToken *)tokenInputView:(LFTokenInputView *)view tokenForText:(NSString *)text;
/**
 * 当视图更新了自己的高度。如果你是不使用自动布局，你应该使用这方法来更新
 */
- (void)tokenInputView:(LFTokenInputView *)view didChangeHeightTo:(CGFloat)height;

@end

@protocol LFTokenInputViewDataSource <NSObject>

@required
/** 提供列表数据源 */
- (NSArray <LFToken *>*)dataSourceInTokenInputView:(LFTokenInputView *)view;

@end


