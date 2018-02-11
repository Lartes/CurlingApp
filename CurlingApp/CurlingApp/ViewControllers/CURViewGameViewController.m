//
//  CURViewGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURViewGameViewController.h"

static const float INDENT = 10.;

@interface CURViewGameViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *teamNameFirst;
@property (nonatomic, strong) UILabel *teamNameSecond;
@property (nonatomic, strong) UILabel *teamsScore;
@property (nonatomic, strong) UIView *colorBarTopNameFirst;
@property (nonatomic, strong) UIView *colorBarBottomNameFirst;
@property (nonatomic, strong) UIView *colorBarTopNameSecond;
@property (nonatomic, strong) UIView *colorBarBottomNameSecond;
@property (nonatomic, strong) UIView *colorBarLeftScore;
@property (nonatomic, strong) UIView *colorBarRightScore;
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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Игры" style:UIBarButtonItemStylePlain target:self action:@selector(toMainView)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteGame)];
    self.navigationItem.rightBarButtonItem = deleteButton;
    
    self.teamNameFirst = [UILabel new];
    self.teamNameFirst.textColor = [UIColor blackColor];
    self.teamNameFirst.text = self.gameInfo.teamNameFirst;
    self.teamNameFirst.textAlignment = NSTextAlignmentRight;
    self.teamNameFirst.numberOfLines = 0;
    [self.view addSubview:self.teamNameFirst];
    
    self.teamNameSecond = [UILabel new];
    self.teamNameSecond.textColor = [UIColor blackColor];
    self.teamNameSecond.text = self.gameInfo.teamNameSecond;
    self.teamNameSecond.textAlignment = NSTextAlignmentLeft;
    self.teamNameSecond.numberOfLines = 0;
    [self.view addSubview:self.teamNameSecond];
    
    self.teamsScore =[UILabel new];
    self.teamsScore.textColor = [UIColor blackColor];
    self.teamsScore.textAlignment = NSTextAlignmentCenter;
    self.teamsScore.numberOfLines = 1;
    NSString *score = [NSString stringWithFormat:@"%d:%d", self.gameInfo.firstTeamScore, self.gameInfo.secondTeamScore];
    self.teamsScore.text = score;
    [self.view addSubview:self.teamsScore];
    
    self.colorBarTopNameFirst = [UIView new];
    self.colorBarBottomNameFirst = [UIView new];
    self.colorBarTopNameSecond = [UIView new];
    self.colorBarBottomNameSecond = [UIView new];
    self.colorBarLeftScore = [UIView new];
    self.colorBarRightScore = [UIView new];
    
    UIColor *firstColor = [UIColor redColor];
    UIColor *secondColor = [UIColor yellowColor];
    if(!self.gameInfo.isFirstTeamColorRed)
    {
        firstColor = [UIColor yellowColor];
        secondColor = [UIColor redColor];
    }
    
    self.colorBarTopNameFirst.backgroundColor = firstColor;
    self.colorBarBottomNameFirst.backgroundColor = firstColor;
    self.colorBarTopNameSecond.backgroundColor = secondColor;
    self.colorBarBottomNameSecond.backgroundColor = secondColor;
    self.colorBarLeftScore.backgroundColor = firstColor;
    self.colorBarRightScore.backgroundColor = secondColor;
    
    [self.view addSubview:self.colorBarTopNameFirst];
    [self.view addSubview:self.colorBarBottomNameFirst];
    [self.view addSubview:self.colorBarTopNameSecond];
    [self.view addSubview:self.colorBarBottomNameSecond];
    [self.view addSubview:self.colorBarLeftScore];
    [self.view addSubview:self.colorBarRightScore];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[CURScoreTableViewCell class] forCellReuseIdentifier:@"ScoreTableViewCell"];
    [self.view addSubview:self.tableView];
    
    self.teamsScore.font = [UIFont systemFontOfSize:30];
    self.teamNameFirst.font = [UIFont systemFontOfSize:23];
    self.teamNameSecond.font = [UIFont systemFontOfSize:23];
}

- (void)updateViewConstraints
{
    if(self.navigationController)
    {
        [self.colorBarTopNameFirst mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).with.offset(INDENT);
            make.top.mas_equalTo(self.navigationController.navigationBar.mas_bottom).with.offset(INDENT);
            make.height.mas_equalTo(INDENT);
        }];
        [self.teamNameFirst mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.colorBarTopNameFirst);
            make.top.mas_equalTo(self.colorBarTopNameFirst.mas_bottom);
        }];
        [self.colorBarBottomNameFirst mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.colorBarTopNameFirst);
            make.top.mas_equalTo(self.teamNameFirst.mas_bottom);
            make.size.mas_equalTo(self.colorBarTopNameFirst);
        }];
        
        [self.colorBarTopNameSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.colorBarTopNameFirst.mas_right);
            make.right.mas_equalTo(self.view).with.offset(-INDENT);
            make.top.mas_equalTo(self.colorBarTopNameFirst);
            make.size.mas_equalTo(self.colorBarTopNameFirst);
        }];
        [self.teamNameSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.teamNameFirst.mas_right).with.offset(INDENT);
            make.right.mas_equalTo(self.view).with.offset(-INDENT);
            make.top.mas_equalTo(self.colorBarTopNameSecond.mas_bottom);
            make.size.mas_equalTo(self.teamNameFirst);
        }];
        [self.colorBarBottomNameSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.colorBarTopNameSecond);
            make.top.mas_equalTo(self.teamNameSecond.mas_bottom);
            make.size.mas_equalTo(self.colorBarTopNameSecond);
        }];
        
        [self.colorBarLeftScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(self.view).with.offset(INDENT);
            make.top.mas_equalTo(self.teamsScore);
            make.bottom.mas_equalTo(self.teamsScore);
            make.width.mas_equalTo(INDENT);
        }];
        [self.teamsScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.colorBarLeftScore.mas_right).with.offset(INDENT);
            make.top.mas_equalTo(self.colorBarBottomNameFirst.mas_bottom).with.offset(INDENT);
            make.centerX.mas_equalTo(self.view);
        }];
        [self.colorBarRightScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.teamsScore.mas_right).with.offset(INDENT);
            make.right.mas_lessThanOrEqualTo(self.view).with.offset(-INDENT);
            make.top.mas_equalTo(self.teamsScore);
            make.size.mas_equalTo(self.colorBarLeftScore);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).with.offset(INDENT);
            make.right.mas_equalTo(self.view).with.offset(-INDENT);
            make.top.mas_equalTo(self.teamsScore.mas_bottom).with.offset(INDENT);
            make.bottom.mas_equalTo(self.view);
        }];
    }
    
    [super updateViewConstraints];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Удалить игру?" message:@"Это действие необратимо." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self.coreDataManager deleteGameByHash:self.gameInfo.hashLink];
        [self toMainView];
    }];
    [alert addAction:actionCancel];
    [alert addAction:actionOk];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)toMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    NSString *score = [NSString stringWithFormat:@"%d:%d", endScore.firstTeamScore, endScore.secondTeamScore];
    cell.score.text = score;
    cell.endNumber.text = [NSString stringWithFormat:@"%d энд", endScore.endNumber];
    
    [cell setNeedsUpdateConstraints];
    
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
