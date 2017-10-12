//
//  LFTokenTableView.h
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/12.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LFTokenInputView, LFToken;

@interface LFTokenTableView : UITableView

/** 独立控件，与LFTokenInputView互相持有，减少LFTokenInputView展示负担 */
@property (weak, nonatomic) LFTokenInputView *tokenInputView;

/** 过滤数据源关键字 */
@property (copy, nonatomic) NSString *filterKey;

/** 获取首个过滤结果 */
- (LFToken *)getFirstFilterToken;

@end
