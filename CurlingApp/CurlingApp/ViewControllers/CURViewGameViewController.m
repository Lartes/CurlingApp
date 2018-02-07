//
//  CURViewGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURViewGameViewController.h"

static const float LABELHEIGHT = 40.;
static const float INDENT = 10.;

@interface CURViewGameViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel* teamNameFirst;
@property (nonatomic, strong) UILabel* teamNameSecond;
@property (nonatomic, strong) UIButton *viewButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<EndScore *> *scoresArray;

@end

@implementation CURViewGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    
    [self loadData];
    [self.tableView reloadData];
}

- (void)prepareUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Games" style:UIBarButtonItemStylePlain target:self action:@selector(toMainView)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.teamNameFirst = [[UILabel alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.navigationController.navigationBar.frame)+INDENT, CGRectGetWidth(self.view.frame)/2-INDENT*2, LABELHEIGHT)];
    self.teamNameFirst.textColor = [UIColor blackColor];
    self.teamNameFirst.text = self.gameInfo.teamNameFirst;
    self.teamNameFirst.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.teamNameFirst];
    
    self.teamNameSecond = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.teamNameFirst.frame)+INDENT*2, CGRectGetMinY(self.teamNameFirst.frame), CGRectGetWidth(self.view.frame)/2.-INDENT*2, LABELHEIGHT)];
    self.teamNameSecond.textColor = [UIColor blackColor];
    self.teamNameSecond.text = self.gameInfo.teamNameSecond;
    self.teamNameSecond.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.teamNameSecond];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.teamNameFirst.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*2, CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.navigationController.navigationBar.frame)-LABELHEIGHT-INDENT*2) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50.;
    [self.tableView registerClass:[CURScoreTableViewCell class] forCellReuseIdentifier:@"ScoreTableViewCell"];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteGame)];
    self.navigationItem.rightBarButtonItem = deleteButton;
    
    self.viewButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*2/3, CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame)/3, 30)];
    self.viewButton.backgroundColor = [UIColor grayColor];
    [self.viewButton setTitle:@"Show game" forState:UIControlStateNormal];
    [self.viewButton addTarget:self action:@selector(showGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.viewButton];
}

- (void)loadData
{
    if (self.coreDataManager)
    {
        self.scoresArray = [self.coreDataManager loadEndScoreByHash:self.gameInfo.hashLink];
    }
}

- (void)deleteGame
{
    [self.coreDataManager deleteGameByHash:self.gameInfo.hashLink];
    [self toMainView];
}

- (void)toMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showGame
{
    CURShowGameManager *gameManager = [[CURShowGameManager alloc] initWithGameInfo:self.gameInfo andEndNumber:1];
    gameManager.coreDataManager = self.coreDataManager;
    
    CURShowGameViewController *gameViewController = [[CURShowGameViewController alloc] initWithManager:gameManager];
    [self.navigationController pushViewController:gameViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scoresArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CURScoreTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ScoreTableViewCell" forIndexPath:indexPath];
    
    EndScore *endScore = self.scoresArray[indexPath.row];
    cell.score.text = endScore.score;
    cell.score.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CURShowGameManager *gameManager = [[CURShowGameManager alloc] initWithGameInfo:self.gameInfo andEndNumber:self.scoresArray[indexPath.row].endNumber];
    gameManager.coreDataManager = self.coreDataManager;

    CURShowGameViewController *gameViewController = [[CURShowGameViewController alloc] initWithManager:gameManager];
    [self.navigationController pushViewController:gameViewController animated:YES];
}

@end
