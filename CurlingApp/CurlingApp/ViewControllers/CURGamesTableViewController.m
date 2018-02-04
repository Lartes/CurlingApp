//
//  CURGamesTableViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//


#import "CURGamesTableViewController.h"
#import "CURGameTableViewCell.h"
#import "CURCreateGameViewController.h"
#import "CURViewGameViewController.h"

@interface CURGamesTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;

@end


@implementation CURGamesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
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
    
    self.data = [@[@{@"teamNameFirst":@"Apple", @"teamNameSecond":@"Peach"}, @{@"teamNameFirst":@"Peach", @"teamNameSecond":@"Cherry"}] mutableCopy];
}

- (void)addNewGame
{
    CURCreateGameViewController *createGameViewController = [CURCreateGameViewController new];
    [self.navigationController pushViewController:createGameViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CURGameTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"GameTableViewCell" forIndexPath:indexPath];
    cell.teamNameFirst.text = [self.data[indexPath.row] objectForKey:@"teamNameFirst"];
    cell.teamNameSecond.text = [self.data[indexPath.row] objectForKey:@"teamNameSecond"];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CURViewGameViewController *viewGameViewController = [CURViewGameViewController new];
    viewGameViewController.teamData = self.data[indexPath.row];
    [self.navigationController pushViewController:viewGameViewController animated:YES];
}

@end
