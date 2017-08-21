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
@interface TreeViewController ()<QuestionTableViewCellDelegate>

@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) NSMutableArray *cellViewModelArray;
@property(nonatomic,strong) NSMutableArray *levelOneModelArray;
@property(nonatomic,strong) CreatTreeView *treeView;
@property(nonatomic,strong)UIScrollView * backScrollView;

@end

@implementation TreeViewController
-(UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
        _backScrollView.showsVerticalScrollIndicator=NO;
        _backScrollView.showsHorizontalScrollIndicator=NO;
        _backScrollView.bounces=YES;
        _backScrollView.backgroundColor = [UIColor whiteColor];
        _backScrollView.contentSize=CGSizeMake(_backScrollView.frame.size.width, _backScrollView.frame.size.height);
        
    }
    return _backScrollView;
}
#pragma mark - LifteCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor grayColor];
    [self.view addSubview:self.backScrollView];
    
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
            weakSelf.treeView =[[CreatTreeView alloc]initWithFrame:frame dataSource:weakSelf.dataSource  cellViewModelArray:weakSelf.cellViewModelArray levelOneModelArray:weakSelf.levelOneModelArray];
            [weakSelf valueBlcokClick];
            [weakSelf.backScrollView addSubview:weakSelf.treeView];
            [weakSelf RemakeContentSize];

        }else{
            
        }
    } andFailure:^(NSString *errorMessage) {
        
    }];
}
-(void)RemakeContentSize{
    
    [self.treeView.tableView reloadData];
    
//    self.pointsTreeView.sd_layout
//    .topSpaceToView(self.moduleView,10)
//    .widthIs(self.backScrollView.width)
//    .heightIs(self.pointsTreeView.tableView.contentSize.height+self.pointsTreeView.headTitle.height);
//    
    
    _backScrollView.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    _backScrollView.contentSize=CGSizeMake(_backScrollView.frame.size.width, self.treeView.tableView.contentSize.height+10+self.backScrollView.contentSize.height+40+46);
    
    
    
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

-(void)valueBlcokClick{
    __weak typeof(self) weakSelf = self;

    _treeView.valueBlcok = ^(NSString *value) {
//        TODO Click Action
        NSLog(@"value====%@",value);
        [weakSelf RemakeContentSize];

    };
    
    _treeView.cellClickBlcok = ^(NSInteger row) {
        [weakSelf RemakeContentSize];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
