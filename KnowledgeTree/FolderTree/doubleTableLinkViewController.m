//
//  doubleTableLinkViewController.m
//  KnowledgeTree
//
//  Created by 鑫鑫 on 2018/5/28.
//  Copyright © 2018年 xinxin. All rights reserved.
//

#import "doubleTableLinkViewController.h"
#define StatusBarHeight (0 ? 44.f : 20.f)
#define StatusBarAndNavigationBarHeight (0 ? 88.f : 64.f)
#define TabbarHeight (0 ? (49.f + 34.f) : (49.f))
#define BottomSafeAreaHeight (0 ? (34.f) : (0.f))

@interface doubleTableLinkViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView * leftTableView;

@property (nonatomic, strong) UITableView * rightTableView;
// 滑到了第几组
@property (nonatomic, strong) NSIndexPath * currentIndexPath;
//用来处理leftTableView的cell的点击事件引起的rightTableView的滑动和用户拖拽rightTableView的事件冲突
@property (nonatomic, assign) BOOL isSelected;

@end


@implementation doubleTableLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.view  addSubview:self.leftTableView];
    [self.view  addSubview:self.rightTableView];
    
}

#pragma mark -- Getter

- (UITableView *)leftTableView{
    
    if (_leftTableView == nil) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, [UIScreen mainScreen].bounds.size.width / 3.0, [UIScreen mainScreen].bounds.size.height - StatusBarHeight) style:UITableViewStyleGrouped];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{
    
    if (_rightTableView == nil) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 3.0, StatusBarHeight, [UIScreen mainScreen].bounds.size.width / 3.0 * 2, [UIScreen mainScreen].bounds.size.height - StatusBarHeight) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
    }
    return _rightTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
