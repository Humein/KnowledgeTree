//
//  ViewController.m
//  KnowledgeTree
//
//  Created by 鑫鑫 on 2017/4/12.
//  Copyright © 2017年 xinxin. All rights reserved.
//

#import "TreeViewController.h"
#import "NetWorkRequestAPI.h"
#import "TreeModel.h"
#import "TreeViewCell.h"
#import "CreatTreeView.h"
@interface TreeViewController ()

@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) NSMutableArray *cellViewModelArray;
@property(nonatomic,strong) NSMutableArray *levelOneModelArray;

@end

@implementation TreeViewController
#pragma mark - LifteCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor grayColor];
    [self initTableView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
#pragma mark - PrivateMethod
-(void)initTableView{
    self.dataSource = [[NSMutableArray alloc]init];
    self.cellViewModelArray = [[NSMutableArray alloc]init];
    self.levelOneModelArray = [[NSMutableArray alloc]init];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [NetWorkRequestAPI requestTrainTreeWithParameter:nil withSuccess:^(id responseObject) {
        BOOL result = [[responseObject objectForKey:@"result"] boolValue];
        if(result){
            
            NSArray *modelArray = [responseObject objectForKey:@"modelarray"];
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.dataSource addObjectsFromArray:modelArray];
            [weakSelf.levelOneModelArray removeAllObjects];
            [weakSelf.levelOneModelArray addObjectsFromArray:modelArray];
            [weakSelf.cellViewModelArray removeAllObjects];
            [weakSelf.cellViewModelArray addObjectsFromArray:[self generateCellViewModelArrayWithKnowledgeModelArray:modelArray]];
            
            
            CGRect frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
            CreatTreeView *treeView =[[CreatTreeView alloc]initWithFrame:frame dataSource:weakSelf.dataSource  cellViewModelArray:weakSelf.cellViewModelArray levelOneModelArray:weakSelf.levelOneModelArray ];
            [self.view addSubview:treeView];
        }else{
            
        }
    } andFailure:^(NSString *errorMessage) {
        
    }];
}
- (NSArray *)generateCellViewModelArrayWithKnowledgeModelArray:(NSArray *)modelArray{
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    for(TreeModel *model in modelArray){
        TreeViewModel *cellViewModel = [[TreeViewModel alloc]init];
        cellViewModel.knowledgeModel = model;
        cellViewModel.level = [model.level integerValue];
        cellViewModel.openstate = ErrorQuestionCellClose;
        [mArray addObject:cellViewModel];
    }
    return mArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
