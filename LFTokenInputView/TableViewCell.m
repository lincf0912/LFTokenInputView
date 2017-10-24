//
//  TableViewCell.m
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/24.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "TableViewCell.h"
#import "LFTokenInputView.h"

@interface TableViewCell () <LFTokenInputViewDelegate, LFTokenInputViewDataSource>

@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    LFTokenInputView *tokenInputView = [[LFTokenInputView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    tokenInputView.fieldName = @"To:";
    tokenInputView.placeholderText = @"Enter a name";
    UIButton *contactAddButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [contactAddButton addTarget:self action:@selector(onAccessoryContactAddButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    tokenInputView.accessoryView = contactAddButton;
    tokenInputView.drawBottomBorder = YES;
    
    tokenInputView.delegate = self;
    tokenInputView.dataSource = self;
    
    [self.contentView addSubview:tokenInputView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)onAccessoryContactAddButtonTapped:(UIButton *)sender
{
    NSLog(@"click accessoryView");
}

- (LFToken *)tokenInputView:(LFTokenInputView *)view tokenForText:(NSString *)text
{
    if (text.length) {
        LFToken *match = [[LFToken alloc] initWithDisplayText:text context:nil];
        return match;
    }
    return nil;
}

#pragma mark - LFTokenInputViewDataSource
/** 提供列表数据源 */
- (NSArray <LFToken *>*)dataSourceInTokenInputView:(LFTokenInputView *)view
{
    NSMutableArray *datas = @[].mutableCopy;
    for (NSInteger i = 0 ; i < 30; i++) {
        LFToken *token = [[LFToken alloc] initWithDisplayText:[NSString stringWithFormat:@"Jack_%d", (int)i] context:@"abc"];
        [datas addObject:token];
    }
    return [datas copy];
}

@end