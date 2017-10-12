//
//  ViewController.m
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/11.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "ViewController.h"
#import "LFTokenInputView.h"

@interface ViewController () <LFTokenInputViewDelegate, LFTokenInputViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LFTokenInputView *tokenInputView = [[LFTokenInputView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 44)];
    tokenInputView.fieldName = @"To:";
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addTarget:self action:@selector(onFieldInfoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    tokenInputView.fieldView = infoButton;
    tokenInputView.placeholderText = @"Enter a name";
    UIButton *contactAddButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [contactAddButton addTarget:self action:@selector(onAccessoryContactAddButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    tokenInputView.accessoryView = contactAddButton;
    tokenInputView.drawBottomBorder = YES;
    
    tokenInputView.delegate = self;
    tokenInputView.dataSource = self;
    
    [tokenInputView beginEditing];
    
    [self.view addSubview:tokenInputView];
}

#pragma mark - LFTokenInputViewDelegate

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Demo Button Actions


- (void)onFieldInfoButtonTapped:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Field View Button"
                                                        message:@"这是一个按钮，可以设置为其他视图"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


- (void)onAccessoryContactAddButtonTapped:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Accessory View Button"
                                                        message:@"这是一个按钮，可以设置为其他视图"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


@end
