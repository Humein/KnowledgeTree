//
//  CreatTreeView.m
//  KnowledgeTree
//
//  Created by 鑫鑫 on 2017/4/25.
//  Copyright © 2017年 xinxin. All rights reserved.
//

#import "CreatTreeView.h"
@interface CreatTreeView()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) NSMutableArray *cellViewModelArray;
@property(nonatomic,strong) NSMutableArray *levelOneModelArray;
@property (nonatomic) BOOL                  sectionFirstLoad;
@end

@implementation CreatTreeView



@end
