//
//  LFTokenInputView.m
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/11.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "LFTokenInputView.h"

#import "LFDetectingTextField.h"
#import "LFTokenView.h"
#import "LFTokenTableView.h"

#import "LFTokenInputHeader.h"


@interface LFTokenInputView () <LFDetectingTextFieldDelegate, LFTokenViewDelegate>

@property (strong, nonatomic) NSMutableArray <LFToken *>*tokens;
@property (strong, nonatomic) NSMutableArray <LFTokenView *>*tokenViews;

@property (strong, nonatomic) LFDetectingTextField *textField;
@property (strong, nonatomic) UILabel *fieldLabel;
@property (strong, nonatomic) LFTokenTableView *tableView;

@property (assign, nonatomic) CGFloat intrinsicContentHeight;
@property (assign, nonatomic) CGFloat additionalTextFieldYOffset;
@property (assign, nonatomic) CGFloat keyboardHeight;

@property (strong, nonatomic) NSMutableDictionary *stateDict;

@end

@implementation LFTokenInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self repositionViews];
}

- (void)dealloc
{
    if (self.tableView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        self.tableView.filterKey = nil;
    }
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, MAX(44, self.intrinsicContentHeight));
}

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.additionalTextFieldYOffset = 1.f;
    self.delimiter = @",";
    self.stateDict = [NSMutableDictionary dictionaryWithCapacity:4];
    self.tokens = [NSMutableArray arrayWithCapacity:20];
    self.tokenViews = [NSMutableArray arrayWithCapacity:20];
    
    [self.stateDict setObject:LF_DefaultTextColor forKey:titleColorKey(LFTokenControlStateNormal)];
    [self.stateDict setObject:[UIColor whiteColor] forKey:titleColorKey(LFTokenControlStateSelected)];
    [self.stateDict setObject:[UIColor clearColor] forKey:backgroundColorKey(LFTokenControlStateNormal)];
    [self.stateDict setObject:LF_DefaultTextColor forKey:backgroundColorKey(LFTokenControlStateSelected)];
    
    self.textField = [[LFDetectingTextField alloc] initWithFrame:CGRectZero];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.delegate = self;

    [self.textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.textField];
    
    self.fieldLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.fieldLabel.font = self.textField.font;
    self.fieldLabel.textColor = [UIColor lightGrayColor];
    /** 不急，当设置了文字再添加 */
//    [self addSubview:self.fieldLabel];
    self.fieldLabel.hidden = YES;
    
    self.intrinsicContentHeight = LF_STANDARD_ROW_HEIGHT;
    [self repositionViews];
}

#pragma mark - Updating/Repositioning Views

- (void)repositionViews
{
    CGRect bounds = self.bounds;
    CGFloat rightBoundary = CGRectGetWidth(bounds) - LF_PADDING_RIGHT;
    CGFloat firstLineRightBoundary = rightBoundary;
    
    CGFloat curX = LF_PADDING_LEFT;
    CGFloat curY = LF_PADDING_TOP;
    CGFloat totalHeight = LF_STANDARD_ROW_HEIGHT;
    BOOL isOnFirstLine = YES;
    
    // 左边控件
    if (self.fieldView) {
        CGRect fieldViewRect = self.fieldView.frame;
        fieldViewRect.origin.x = curX + LF_FIELD_MARGIN_X;
        fieldViewRect.origin.y = curY + ((LF_STANDARD_ROW_HEIGHT - CGRectGetHeight(fieldViewRect))/2.0);
        self.fieldView.frame = fieldViewRect;
        
        curX = CGRectGetMaxX(fieldViewRect) + LF_FIELD_MARGIN_X;
    }
    
    // 标签控件
    if (!self.fieldLabel.hidden) {
        CGRect fieldLabelRect = self.fieldLabel.frame;
        fieldLabelRect.origin.x = curX + LF_FIELD_MARGIN_X;
        fieldLabelRect.origin.y = curY + ((LF_STANDARD_ROW_HEIGHT-CGRectGetHeight(fieldLabelRect))/2.0);
        self.fieldLabel.frame = fieldLabelRect;
        
        curX = CGRectGetMaxX(fieldLabelRect) + LF_FIELD_MARGIN_X;
    }
    
    // 右边控件
    if (self.accessoryView) {
        CGRect accessoryRect = self.accessoryView.frame;
        accessoryRect.origin.x = CGRectGetWidth(bounds) - LF_PADDING_RIGHT - CGRectGetWidth(accessoryRect);
        accessoryRect.origin.y = curY + ((LF_STANDARD_ROW_HEIGHT-CGRectGetHeight(accessoryRect))/2.0);
        self.accessoryView.frame = accessoryRect;
        
        firstLineRightBoundary = CGRectGetMinX(accessoryRect) - LF_PADDING_RIGHT;
    }
    
    // tokens 控件
    CGRect tokenRect = CGRectNull;
    for (UIView *tokenView in self.tokenViews) {
        tokenRect = tokenView.frame;
        
        CGFloat tokenBoundary = isOnFirstLine ? firstLineRightBoundary : rightBoundary;
        if (curX + CGRectGetWidth(tokenRect) > tokenBoundary) {
            // 换行
            curX = LF_PADDING_LEFT;
            curY += LF_STANDARD_ROW_HEIGHT+LF_VSPACE;
            totalHeight += LF_STANDARD_ROW_HEIGHT;
            isOnFirstLine = NO;
        }
        
        tokenRect.origin.x = curX;
        // 居中
        tokenRect.origin.y = curY + ((LF_STANDARD_ROW_HEIGHT-CGRectGetHeight(tokenRect))/2.0);
        tokenView.frame = tokenRect;
        
        curX = CGRectGetMaxX(tokenRect) + LF_HSPACE;
    }
    
    // 文本缩进
    curX += LF_TEXT_FIELD_HSPACE;
    CGFloat textBoundary = isOnFirstLine ? firstLineRightBoundary : rightBoundary;
    CGFloat availableWidthForTextField = textBoundary - curX;
    if (availableWidthForTextField < LF_MINIMUM_TEXTFIELD_WIDTH) {
        isOnFirstLine = NO;
        curX = LF_PADDING_LEFT + LF_TEXT_FIELD_HSPACE;
        curY += LF_STANDARD_ROW_HEIGHT + LF_VSPACE;
        totalHeight += LF_STANDARD_ROW_HEIGHT;
        // 调整宽度
        availableWidthForTextField = rightBoundary - curX;
    }
    
    CGRect textFieldRect = self.textField.frame;
    textFieldRect.origin.x = curX;
    textFieldRect.origin.y = curY + self.additionalTextFieldYOffset;;
    textFieldRect.size.width = availableWidthForTextField;
    textFieldRect.size.height = LF_STANDARD_ROW_HEIGHT;
    self.textField.frame = textFieldRect;
    
    CGFloat oldContentHeight = self.intrinsicContentHeight;
    self.intrinsicContentHeight = CGRectGetMaxY(textFieldRect) + LF_PADDING_BOTTOM;
    [self invalidateIntrinsicContentSize];
    CGRect frame = self.frame;
    frame.size.height = self.intrinsicContentSize.height;
    self.frame = frame;
    
    /** 列表位置 */
    if (self.tableView) {
        /** 输入框以下的部分 */
        CGRect inScreenRect = [self.superview convertRect:self.frame toView:nil];
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(inScreenRect), CGRectGetWidth(inScreenRect), [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(inScreenRect) - self.keyboardHeight);
    }
    
    if (oldContentHeight != self.intrinsicContentHeight) {
        if ([self.delegate respondsToSelector:@selector(tokenInputView:didChangeHeightTo:)]) {
            [self.delegate tokenInputView:self didChangeHeightTo:self.intrinsicContentSize.height];
        }
    }

    [self setNeedsDisplay];
}

- (void)updatePlaceholderTextVisibility
{
    if (self.tokens.count > 0) {
        self.textField.placeholder = nil;
    } else {
        self.textField.placeholder = self.placeholderText;
    }
}

#pragma mark - setter

- (void)setDataSource:(id<LFTokenInputViewDataSource>)dataSource
{
    _dataSource = dataSource;
    if ([self.dataSource respondsToSelector:@selector(dataSourceInTokenInputView:)]) {
        LFTokenTableView *tableView = [[LFTokenTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        /** 创建关系 */
        tableView.tokenInputView = self;
        self.tableView = tableView;
        [self repositionViews];
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.textField.font = font;
    self.fieldLabel.font = font;
    if (!self.fieldLabel.hidden) {
        [self.fieldLabel sizeToFit];
        [self repositionViews];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textField.textColor = textColor;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    self.textField.keyboardType = _keyboardType;
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType
{
    _autocapitalizationType = autocapitalizationType;
    self.textField.autocapitalizationType = _autocapitalizationType;
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType
{
    _autocorrectionType = autocorrectionType;
    self.textField.autocorrectionType = _autocorrectionType;
}

- (void)setFieldName:(NSString *)fieldName
{
    if (_fieldName == fieldName) {
        return;
    }
    NSString *oldFieldName = _fieldName;
    _fieldName = fieldName;
    
    self.fieldLabel.text = _fieldName;
    [self.fieldLabel sizeToFit];
    BOOL showField = (_fieldName.length > 0);
    self.fieldLabel.hidden = !showField;
    if (showField && !self.fieldLabel.superview) {
        [self addSubview:self.fieldLabel];
    } else if (!showField && self.fieldLabel.superview) {
        [self.fieldLabel removeFromSuperview];
    }
    
    if (oldFieldName == nil || ![oldFieldName isEqualToString:fieldName]) {
        [self repositionViews];
    }
}

- (void)setFieldView:(UIView *)fieldView
{
    if (_fieldView == fieldView) {
        return;
    }
    [_fieldView removeFromSuperview];
    _fieldView = fieldView;
    [_fieldView sizeToFit];
    if (_fieldView != nil) {
        [self addSubview:_fieldView];
    }
    [self repositionViews];
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    if (_placeholderText == placeholderText) {
        return;
    }
    _placeholderText = placeholderText;
    [self updatePlaceholderTextVisibility];
}

- (void)setAccessoryView:(UIView *)accessoryView
{
    if (_accessoryView == accessoryView) {
        return;
    }
    [_accessoryView removeFromSuperview];
    _accessoryView = accessoryView;
    [_accessoryView sizeToFit];
    if (_accessoryView != nil) {
        _accessoryView.hidden = YES;
        [self addSubview:_accessoryView];
    }
    [self repositionViews];
}


- (void)setDrawBottomBorder:(BOOL)drawBottomBorder
{
    if (_drawBottomBorder == drawBottomBorder) {
        return;
    }
    _drawBottomBorder = drawBottomBorder;
    [self setNeedsDisplay];
}

/** 文字颜色 */
- (void)setTokenTitleColor:(UIColor *)color forState:(LFTokenControlState)state
{
    NSString *key = titleColorKey(state);
    if (color) {
        [self.stateDict setObject:color forKey:key];
    } else {
        [self.stateDict removeObjectForKey:key];
    }
    for (LFTokenView *tokenView in self.tokenViews) {
        [tokenView setTitleColor:color forState:state];
        [tokenView setBackgroundColor:color forState:state];
    }
}
/** 背景颜色 */
- (void)setTokenBackgroundColor:(UIColor *)color forState:(LFTokenControlState)state
{
    NSString *key = backgroundColorKey(state);
    if (color) {
        [self.stateDict setObject:color forKey:key];
    } else {
        [self.stateDict removeObjectForKey:key];
    }
    for (LFTokenView *tokenView in self.tokenViews) {
        [tokenView setTitleColor:color forState:state];
        [tokenView setBackgroundColor:color forState:state];
    }
}

- (UIColor *)tokenTitleColorForState:(LFTokenControlState)state
{
    NSString *key = titleColorKey(state);
    return [self.stateDict objectForKey:key];
}
- (UIColor *)tokenBackgroundColorForState:(LFTokenControlState)state
{
    NSString *key = backgroundColorKey(state);
    return [self.stateDict objectForKey:key];
}

#pragma mark - Drawing
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.drawBottomBorder) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGRect bounds = self.bounds;
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextSetLineWidth(context, 0.5);
        
        CGContextMoveToPoint(context, 0, bounds.size.height);
        CGContextAddLineToPoint(context, CGRectGetWidth(bounds), bounds.size.height);
        CGContextStrokePath(context);
    }
}

#pragma mark - Editing

- (BOOL)isEditing
{
    return self.textField.editing;
}


- (void)beginEditing
{
    [self.textField becomeFirstResponder];
}


- (void)endEditing
{
    [self.textField resignFirstResponder];
}

#pragma mark - Token selection

- (void)selectTokenView:(LFTokenView *)tokenView animated:(BOOL)animated
{
    [tokenView setSelected:YES animated:animated];
    for (LFTokenView *otherTokenView in self.tokenViews) {
        if (otherTokenView != tokenView) {
            [otherTokenView setSelected:NO animated:animated];
        }
    }
}

- (void)unselectAllTokenViewsAnimated:(BOOL)animated
{
    for (LFTokenView *tokenView in self.tokenViews) {
        [tokenView setSelected:NO animated:animated];
    }
}

#pragma mark - Adding / Removing Tokens

- (void)addToken:(LFToken *)token
{
    BOOL ok = [self __addToken:token];
    if (ok) {
        [self __updateContain];
    }
}

- (BOOL)__addToken:(LFToken *)token
{
    if ([self.tokens containsObject:token]) {
        return NO;
    }
    
    [self.tokens addObject:token];
    LFTokenView *tokenView = [[LFTokenView alloc] initWithToken:token delimiter:self.delimiter];
    tokenView.font = self.font;
    tokenView.delegate = self;
    
    /** 设置颜色 */
    UIColor *titleColor_Nor = [self tokenTitleColorForState:LFTokenControlStateNormal];
    [tokenView setTitleColor:titleColor_Nor forState:LFTokenControlStateNormal];
    UIColor *titleColor_Sel = [self tokenTitleColorForState:LFTokenControlStateSelected];
    [tokenView setTitleColor:titleColor_Sel forState:LFTokenControlStateSelected];
    
    UIColor *backgroundColor_Nor = [self tokenBackgroundColorForState:LFTokenControlStateNormal];
    [tokenView setBackgroundColor:backgroundColor_Nor forState:LFTokenControlStateNormal];
    UIColor *backgroundColor_Sel = [self tokenBackgroundColorForState:LFTokenControlStateSelected];
    [tokenView setBackgroundColor:backgroundColor_Sel forState:LFTokenControlStateSelected];
    
    CGSize intrinsicSize = tokenView.intrinsicContentSize;
    tokenView.frame = CGRectMake(0, 0, intrinsicSize.width, intrinsicSize.height);
    [self.tokenViews addObject:tokenView];
    [self addSubview:tokenView];
    if ([self.delegate respondsToSelector:@selector(tokenInputView:didAddToken:)]) {
        [self.delegate tokenInputView:self didAddToken:token];
    }
    
    return YES;
}

- (void)removeToken:(LFToken *)token
{
    BOOL ok = [self __removeToken:token];
    if (ok) {
        [self __updateContain];
    }
}

- (BOOL)__removeToken:(LFToken *)token
{
    NSInteger index = [self.tokens indexOfObject:token];
    if (index == NSNotFound) {
        return NO;
    }
    LFTokenView *tokenView = self.tokenViews[index];
    [tokenView removeFromSuperview];
    [self.tokenViews removeObjectAtIndex:index];
    LFToken *removedToken = self.tokens[index];
    [self.tokens removeObjectAtIndex:index];
    if ([self.delegate respondsToSelector:@selector(tokenInputView:didRemoveToken:)]) {
        [self.delegate tokenInputView:self didRemoveToken:removedToken];
    }
    return YES;
}

- (void)__updateContain
{
    // Clearing text programmatically doesn't call this automatically
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
    
    [self updatePlaceholderTextVisibility];
    [self repositionViews];
}

- (NSArray *)allTokens
{
    return [self.tokens copy];
}

- (void)setAllTokens:(NSArray<LFToken *> *)allTokens
{
    NSArray *tokens = [self allTokens];
    for (LFToken *token in tokens) {
        [self __removeToken:token];
    }
    
    for (LFToken *token in allTokens) {
        [self __addToken:token];
    }
    
    [self __updateContain];
}

- (void)tokenizeTextfieldText
{
    LFToken *token = nil;
    NSString *text = self.textField.text;
    if (text.length > 0) {
//  使用匹配结果第一个数据
//        if (self.tableView) {
//            token = [self.tableView getFirstFilterToken];
//        }
        if (token == nil) {
            if ([self.delegate respondsToSelector:@selector(tokenInputView:tokenForText:)]) {
                token = [self.delegate tokenInputView:self tokenForText:text];
            }
        }
        
        if (token != nil) {
            [self addToken:token];
            self.textField.text = @"";
            [self textFieldDidChange:self.textField];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.accessoryView.hidden = NO;
    if ([self.delegate respondsToSelector:@selector(tokenInputViewShouldBeginEditing:)]) {
        [self.delegate tokenInputViewShouldBeginEditing:self];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.text.length) {
        [self tokenizeTextfieldText];
    }
    self.tableView.filterKey = nil;
    self.accessoryView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(tokenInputViewShouldEndEditing:)]) {
        [self.delegate tokenInputViewShouldEndEditing:self];
    }
    return YES;
}

#pragma mark - Text Field Changes

- (void)textFieldDidChange:(id)sender
{
    self.tableView.filterKey = self.textField.text;
    if ([self.delegate respondsToSelector:@selector(tokenInputView:didChangeText:)]) {
        [self.delegate tokenInputView:self didChangeText:self.textField.text];
    }
}

#pragma mark - LFDetectingTextFieldDelegate

- (void)textFieldDidDelete:(UITextField *)textField
{
    if (textField.text.length == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LFTokenView *tokenView = self.tokenViews.lastObject;
            if (tokenView && !tokenView.selected) {
                [self selectTokenView:tokenView animated:YES];
                [self.textField resignFirstResponder];
            }
        });
    }
}

#pragma mark - LFTokenViewDelegate

- (void)tokenViewDidDeleted:(LFTokenView *)tokenView replaceWithText:(NSString *)replacementText
{
    // 激活输入框
    [self.textField becomeFirstResponder];
    
    /** 回车恢复原状 */
    if ([replacementText isEqualToString:@"\n"]) {
        return;
    }
    
    if (replacementText.length > 0) {
        // 替换内容
        self.textField.text = replacementText;
        [self textFieldDidChange:self.textField];
    }
    // 删除对象
    [self removeToken:tokenView.token];
}

- (void)tokenViewDidSelected:(LFTokenView *)tokenView
{
    if (tokenView.selected) {
        if ([self.delegate respondsToSelector:@selector(tokenInputView:didSelectedToken:)]) {
            [self.delegate tokenInputView:self didSelectedToken:tokenView.token];
        }
    }
    [self selectTokenView:tokenView animated:YES];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self tokenizeTextfieldText];
    return NO;
}

#pragma mark - 键盘通知
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [self keyboardWillChanged:aNotification];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self keyboardWillChanged:aNotification];
}

- (void)keyboardWillChanged:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.keyboardHeight = height;
    
    CGRect inScreenRect = [self.superview convertRect:self.frame toView:nil];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(inScreenRect), CGRectGetWidth(inScreenRect), [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(inScreenRect) - self.keyboardHeight);
}

@end
