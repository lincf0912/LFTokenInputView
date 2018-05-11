//
//  LFTokenView.m
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/11.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "LFTokenView.h"
#import "LFTokenInputHeader.h"

@interface LFTokenView ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UILabel *label;

@property (copy, nonatomic) NSString *displayText;

@property (strong, nonatomic) NSMutableDictionary *stateDict;

@end

@implementation LFTokenView

@synthesize selected = _selected;

- (id)initWithToken:(LFToken *)token
{
    return [self initWithToken:token delimiter:@","];
}

- (id)initWithToken:(LFToken *)token delimiter:(NSString *)delimiter
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _token = token;
        _delimiter = delimiter;
        self.backgroundColor = [UIColor clearColor];
        self.stateDict = @{}.mutableCopy;
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundView.layer.cornerRadius = 3.0;
        [self addSubview:self.backgroundView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.font = [UIFont systemFontOfSize:17.0];
        self.label.textColor = LF_DefaultTextColor;
        self.label.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
        
        self.displayText = token.displayText;
        
        
        NSString *labelString = self.displayText;
        if (self.delimiter) {
            labelString = [labelString stringByAppendingString:self.delimiter];
        }
        NSMutableAttributedString *attrString =
        [[NSMutableAttributedString alloc] initWithString:labelString
                                               attributes:@{NSFontAttributeName : self.label.font,
                                                            NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
        NSRange tintRange = [labelString rangeOfString:token.displayText];
        
        [attrString setAttributes:@{NSForegroundColorAttributeName : self.label.tintColor}
                            range:tintRange];
        self.label.attributedText = attrString;
        [self.label sizeToFit];
        
        // Listen for taps
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        [self addGestureRecognizer:tapRecognizer];
        
        [self setNeedsLayout];
        
    }
    return self;
}

- (BOOL)resignFirstResponder
{
    [self setSelected:NO animated:YES];
    return [super resignFirstResponder];    
}

- (CGSize)intrinsicContentSize
{
    CGSize labelIntrinsicSize = self.label.intrinsicContentSize;
    return CGSizeMake(labelIntrinsicSize.width+(2.0*LF_PADDING_X), labelIntrinsicSize.height+(2.0*LF_PADDING_X));
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize fittingSize = CGSizeMake(size.width-(2.0*LF_PADDING_X), size.height-(2.0*LF_PADDING_X));
    CGSize labelSize = [self.label sizeThatFits:fittingSize];
    return CGSizeMake(labelSize.width+(2.0*LF_PADDING_X), labelSize.height+(2.0*LF_PADDING_X));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    self.backgroundView.frame = bounds;
    
    CGRect labelFrame = self.label.frame;
    labelFrame.size.height = LF_STANDARD_ROW_HEIGHT;
    labelFrame.origin.x = (self.frame.size.width-labelFrame.size.width)/2;
    labelFrame.origin.y = (self.frame.size.height-labelFrame.size.height)/2;
    
    self.label.frame = labelFrame;
}

#pragma mark - Taps

-(void)handleTapGestureRecognizer:(id)sender
{
    [self.delegate tokenViewDidSelected:self];
}

- (void)editingDidEnd
{
    
}

#pragma mark - setter/getter

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.label.font = font;
}

- (BOOL)isSelected
{
    return _selected;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (_selected == selected) {
        return;
    }
    _selected = selected;
    
    if (selected) {
        [self becomeFirstResponder];
    }
    
    LFTokenControlState state = (selected ? LFTokenControlStateSelected : LFTokenControlStateNormal);
    
    UIColor *titleColor = [self titleColorForState:state];
    UIColor *backgroundColor = [self backgroundColorForState:state];
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self setTitleColor:titleColor forState:state];
            [self setBackgroundColor:backgroundColor forState:state];
        }];
    } else {
        [self setTitleColor:titleColor forState:state];
        [self setBackgroundColor:backgroundColor forState:state];
    }
}

/** 文字颜色 */
- (void)setTitleColor:(UIColor *)color forState:(LFTokenControlState)state
{
    UIColor *tintColor = color ?: LF_DefaultTextColor;
    NSString *key = titleColorKey(state);
    if (color) {
        [self.stateDict setObject:color forKey:key];
    } else {
        [self.stateDict removeObjectForKey:key];
    }
    
    BOOL setColor = NO;
    if (state == LFTokenControlStateSelected && self.selected) {
        /** 设置选中颜色 */
        setColor = YES;
    } else if (state == LFTokenControlStateNormal && !self.selected) {
        /** 设置正常颜色 */
        setColor = YES;
    }
    
    if (setColor) {
        self.label.textColor = tintColor;
        
        NSString *labelString = self.displayText;
        if (!self.selected && self.delimiter) {
            labelString = [labelString stringByAppendingString:self.delimiter];
        }
        
        NSMutableAttributedString *attrString =
        [[NSMutableAttributedString alloc] initWithString:labelString
                                               attributes:@{NSFontAttributeName : self.label.font,
                                                            NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
        NSRange tintRange = [attrString.string rangeOfString:self.displayText];
        
        [attrString setAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}
                            range:NSMakeRange(0, attrString.length)];
        
        [attrString setAttributes:@{NSForegroundColorAttributeName : tintColor}
                            range:tintRange];
        self.label.attributedText = attrString;
    }
    
}
/** 背景颜色 */
- (void)setBackgroundColor:(UIColor *)color forState:(LFTokenControlState)state
{
    UIColor *tintColor = color ?: [UIColor clearColor];
    NSString *key = backgroundColorKey(state);
    if (color) {
        [self.stateDict setObject:color forKey:key];
    } else {
        [self.stateDict removeObjectForKey:key];
    }
    
    BOOL setColor = NO;
    if (state == LFTokenControlStateSelected && self.selected) {
        /** 设置选中颜色 */
        setColor = YES;
    } else if (state == LFTokenControlStateNormal && !self.selected) {
        /** 设置正常颜色 */
        setColor = YES;
    }
    
    if (setColor) {
        self.backgroundView.backgroundColor = tintColor;
    }
}

- (UIColor *)titleColorForState:(LFTokenControlState)state
{
    NSString *key = titleColorKey(state);
    return [self.stateDict objectForKey:key];
}
- (UIColor *)backgroundColorForState:(LFTokenControlState)state
{
    NSString *key = backgroundColorKey(state);
    return [self.stateDict objectForKey:key];
}

#pragma mark - UIKeyInput protocol

- (BOOL)hasText
{
    return YES;
}

- (void)insertText:(NSString *)text
{
    [self.delegate tokenViewDidDeleted:self replaceWithText:text];
}

- (void)deleteBackward
{
    [self.delegate tokenViewDidDeleted:self replaceWithText:nil];
}

- (UIKeyboardType)keyboardType
{
    return UIKeyboardTypeEmailAddress;
}

- (UITextAutocorrectionType)autocorrectionType
{
    return UITextAutocorrectionTypeNo;
}

- (UITextAutocapitalizationType)autocapitalizationType
{
    return UITextAutocapitalizationTypeNone;
}

#pragma mark - First Responder (needed to capture keyboard)

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
