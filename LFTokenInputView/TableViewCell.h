//
//  TableViewCell.h
//  LFTokenInputView
//
//  Created by LamTsanFeng on 2017/10/24.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TableViewCellDelegate <NSObject>

- (void)didChangeHeightTo:(CGFloat)height;

@end

@interface TableViewCell : UITableViewCell

@property (nonatomic, weak) id<TableViewCellDelegate> tokenInputDelegate;

@end
