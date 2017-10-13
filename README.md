# LFTokenInputView

* 类似原生邮件的输入框

## Installation 安装

* CocoaPods：pod 'LFTokenInputView'
* 手动导入：将LFTokenInputView\class文件夹拽入项目中，导入头文件：#import "LFTokenInputView.h"

## 调用代码

LFTokenInputView *tokenInputView = [[LFTokenInputView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 44)];
tokenInputView.fieldName = @"To:";
tokenInputView.placeholderText = @"Enter a name";
tokenInputView.drawBottomBorder = YES;

tokenInputView.delegate = self;
tokenInputView.dataSource = self;


## 图片展示

![image](https://github.com/lincf0912/LFTokenInputView/blob/master/ScreenShots/screenshot.gif)
