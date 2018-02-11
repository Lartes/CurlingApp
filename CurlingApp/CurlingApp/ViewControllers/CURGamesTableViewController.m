//
//  CURGamesTableViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//


#import "CURGamesTableViewController.h"

@interface CURGamesTableViewController () <UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *gamesArray;
@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

@end


@implementation CURGamesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    self.coreDataManager = [CURCoreDataManager new];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    [self.tableView reloadData];
}

- (void)prepareUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Игры";
    
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewGame)];
    self.navigationItem.rightBarButtonItem = newButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[CURGameTableViewCell class] forCellReuseIdentifier:@"GameTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)updateViewConstraints
{
    if (self.navigationController)
    {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.navigationController.navigationBar.mas_bottom);
            make.left.right.and.bottom.mas_equalTo(self.view);
        }];
    }
    
    [super updateViewConstraints];
}

- (void)loadData
{
    if (self.coreDataManager)
    {
        self.gamesArray = [self.coreDataManager loadAllGamesInfo];
    }
}

- (void)addNewGame
{
    CURCreateGameViewController *createGameViewController = [CURCreateGameViewController new];
    createGameViewController.coreDataManager = self.coreDataManager;
    [self.navigationController pushViewController:createGameViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gamesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CURGameTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"GameTableViewCell" forIndexPath:indexPath];
    
    GameInfo *gameInfo = self.gamesArray[indexPath.row];
    cell.teamNameFirst.text = gameInfo.teamNameFirst;
    cell.teamNameSecond.text = gameInfo.teamNameSecond;
    NSString *score = [NSString stringWithFormat:@"%d:%d", gameInfo.firstTeamScore, gameInfo.secondTeamScore];
    cell.teamsScore.text = score;
    
    [cell setNeedsUpdateConstraints];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CURViewGameViewController *viewGameViewController = [CURViewGameViewController new];
    viewGameViewController.gameInfo = self.gamesArray[indexPath.row];
    viewGameViewController.coreDataManager = self.coreDataManager;
   [self.navigationController pushViewController:viewGameViewController animated:YES];
}

@end
