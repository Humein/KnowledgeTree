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
@interface TreeViewController ()<UITableViewDelegate,UITableViewDataSource,QuestionTableViewCellDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) NSMutableArray *cellViewModelArray;
@property(nonatomic,strong) NSMutableArray *levelOneModelArray;
@end

@implementation TreeViewController
#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.separatorColor = UICOLOR_RGB_Alpha(0xdcdcdc, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UICOLOR_RGB_Alpha(0xffffff, 1);
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark - LifteCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor grayColor];
    [self initTableView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellViewModelArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TreeViewCell";
    TreeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TreeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    TreeViewModel *cellViewModel = [self.cellViewModelArray objectAtIndex:indexPath.row];
    [cell refreshCellWithViewModel:cellViewModel];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TreeViewCell heightForCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TreeViewModel *cellViewModel = [self.cellViewModelArray objectAtIndex:indexPath.row];
    
    if(cellViewModel.openstate == ErrorQuestionCellClose){
        cellViewModel.openstate = ErrorQuestionCellOpen;
        NSArray *childCellNode = [self generateCellViewModelArrayWithKnowledgeModelArray:cellViewModel.knowledgeModel.childrenKnowledgeModelArray];
        [self.cellViewModelArray insertObjects:childCellNode atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, childCellNode.count)]];
        NSMutableArray *indexPathArray = [[NSMutableArray alloc]init];
        for(NSInteger i = indexPath.row+1 ; i <= indexPath.row + childCellNode.count ; i++){
            NSIndexPath *obj = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPathArray addObject:obj];
        }
        [self setCellIndex];
        [_tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }else{
        cellViewModel.openstate = ErrorQuestionCellClose;
        NSArray *showingChildCellNode = [self allShowingChildNodeWithCellViewModel:cellViewModel];
        [self.cellViewModelArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, showingChildCellNode.count)]];
        NSMutableArray *indexPathArray = [[NSMutableArray alloc]init];
        for(NSInteger i = indexPath.row+1 ; i <= indexPath.row + showingChildCellNode.count ; i++){
            NSIndexPath *obj = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPathArray addObject:obj];
        }
        [self setCellIndex];
        [_tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - PrivateMethod
-(void)initTableView{
    self.dataSource = [[NSMutableArray alloc]init];
    self.cellViewModelArray = [[NSMutableArray alloc]init];
    self.levelOneModelArray = [[NSMutableArray alloc]init];
    [self.view addSubview:self.tableView];
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
            //TODO
            [weakSelf.cellViewModelArray removeAllObjects];
            [weakSelf.cellViewModelArray addObjectsFromArray:[self generateCellViewModelArrayWithKnowledgeModelArray:modelArray]];
            [weakSelf.tableView reloadData];
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

-(void)setCellIndex{
    for(TreeViewModel *cellModel in self.cellViewModelArray){
        NSInteger index = [self.cellViewModelArray indexOfObject:cellModel];
        TreeViewModel *nextCellModel = nil;
        if(index + 1 < self.cellViewModelArray.count){
            nextCellModel = [self.cellViewModelArray objectAtIndex:index+1];
        }
        if([self isLevelOneModelWithCellViewModel:cellModel]){
            cellModel.index = ErrorQuestionCellIndexTop;
        }else if([[self.cellViewModelArray lastObject] isEqual:cellModel]){
            cellModel.index = ErrorQuestionCellIndexBottom;
        }else if(nextCellModel && [self isLevelOneModelWithCellViewModel:nextCellModel]){
            cellModel.index = ErrorQuestionCellIndexBottom;
        }else{
            cellModel.index = ErrorQuestionCellIndexCenter;
        }
    }
}

-(NSArray *)allShowingChildNodeWithCellViewModel:(TreeViewModel *)cellViewModel{
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    NSArray *knowledgeModelArray = [TreeModel allChildNodeWithKnowledgeModel:cellViewModel.knowledgeModel];
    for(TreeModel *knowledgeMdeol in knowledgeModelArray){
        for(TreeViewModel *obj in self.cellViewModelArray){
            if([knowledgeMdeol.knowledgeID isEqualToString:obj.knowledgeModel.knowledgeID]){
                [mArray addObject:obj];
            }
        }
    }
    return mArray;
}

-(BOOL)isLevelOneModelWithCellViewModel:(TreeViewModel *)cellModel{
    return [self.levelOneModelArray containsObject:cellModel.knowledgeModel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
