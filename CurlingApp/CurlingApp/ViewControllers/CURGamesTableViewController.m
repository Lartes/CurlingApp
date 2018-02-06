//
//  CURGamesTableViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//


#import "AppDelegate.h"
#import "CURGamesTableViewController.h"
#import "CURGameTableViewCell.h"
#import "CURCreateGameViewController.h"
#import "CURViewGameViewController.h"
#import "GameInfo+CoreDataClass.h"
#import "CURCoreDataManager.h"

@interface CURGamesTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *gamesArray;
@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

@end


@implementation CURGamesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    [self prepareData];
}

- (void)prepareUI
{
    self.navigationItem.title = @"Games";
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewGame)];
    self.navigationItem.rightBarButtonItem = newButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 110.;
    [self.tableView registerClass:[CURGameTableViewCell class] forCellReuseIdentifier:@"GameTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)prepareData
{
    self.coreDataManager = [CURCoreDataManager new];
    self.gamesArray = [self.coreDataManager loadAllGamesInfo];
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
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CURViewGameViewController *viewGameViewController = [CURViewGameViewController new];
    viewGameViewController.gameInfo = self.gamesArray[indexPath.row];
   [self.navigationController pushViewController:viewGameViewController animated:YES];
}

@end
