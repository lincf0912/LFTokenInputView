//
//  LFTokenTableView.m
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/12.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "LFTokenTableView.h"
#import "LFTokenInputView.h"

static NSString * LFTokenTableViewCellIdentifier = @"LFTokenTableViewCell";

@interface LFTokenTableView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray <LFToken *>*tokens;
@property (strong, nonatomic) NSArray <LFToken *>*filteredTokens;

@end

@implementation LFTokenTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (void)customInit
{
    self.backgroundColor = [UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:249.f/255.f alpha:1.f];
    self.delegate = self;
    self.dataSource = self;
}

/** 获取首个过滤结果 */
- (LFToken *)getFirstFilterToken
{
    return self.filteredTokens.firstObject;
}

#pragma mark - setter
- (void)setTokenInputView:(LFTokenInputView *)tokenInputView
{
    _tokenInputView = tokenInputView;
    /** 必须存在这个代理方法，否则该类不会创建 */
    self.tokens = [_tokenInputView.dataSource dataSourceInTokenInputView:_tokenInputView];
    self.filteredTokens = nil;
}

- (void)setFilterKey:(NSString *)filterKey
{
    _filterKey = filterKey;
    if (filterKey.length == 0){
        self.filteredTokens = nil;
        [self removeFromSuperview];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.displayText contains[cd] %@", filterKey];
        self.filteredTokens = [self.tokens filteredArrayUsingPredicate:predicate];
        if (self.superview == nil) {
            [[UIApplication sharedApplication].keyWindow addSubview:self];
        }
    }
    [self reloadData];
    if (self.filteredTokens.count) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredTokens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LFTokenTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:LFTokenTableViewCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    LFToken *token = self.filteredTokens[indexPath.row];
    cell.textLabel.text = token.displayText;
    if ([token.context isKindOfClass:[NSString class]]) {
        cell.detailTextLabel.text = (NSString *)token.context;
    }
    if ([self.tokenInputView.allTokens containsObject:token]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LFToken *token = self.filteredTokens[indexPath.row];
    [self.tokenInputView addToken:token];
}

@end
