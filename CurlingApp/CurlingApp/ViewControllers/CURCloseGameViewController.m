//
//  SURCloseGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 05/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURCloseGameViewController.h"

static const CGFloat INDENT = 10.;

@interface CURCloseGameViewController ()

@property (nonatomic, strong) UIButton *nextEndButton;
@property (nonatomic, strong) UIButton *closeGameButton;
@property (nonatomic, strong) UITextField *firstTeamScore;
@property (nonatomic, strong) UITextField *secondTeamScore;
@property (nonatomic, strong) UILabel* teamNameFirst;
@property (nonatomic, strong) UILabel* teamNameSecond;
@property (nonatomic, strong) GameInfo *gameInfo;

@end

@implementation CURCloseGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI
{
    self.navigationItem.title = @"Score";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.gameInfo = [self.gameManager.coreDataManager loadGamesInfoByHash:[self.gameManager getHashLink]];
    
    self.teamNameFirst = [UILabel new];
    self.teamNameFirst.textColor = [UIColor blackColor];
    self.teamNameFirst.text = self.gameInfo.teamNameFirst;
    self.teamNameFirst.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.teamNameFirst];
    
    self.teamNameSecond = [UILabel new];
    self.teamNameSecond.textColor = [UIColor blackColor];
    self.teamNameSecond.text = self.gameInfo.teamNameSecond;
    self.teamNameSecond.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.teamNameSecond];
    
    self.teamNameFirst.font = [UIFont systemFontOfSize:23];
    self.teamNameSecond.font = [UIFont systemFontOfSize:23];
    
    self.firstTeamScore = [UITextField new];
    self.firstTeamScore.keyboardType = UIKeyboardTypeNumberPad;
    self.firstTeamScore.textAlignment = NSTextAlignmentCenter;
    self.firstTeamScore.borderStyle = UITextBorderStyleRoundedRect;
    self.firstTeamScore.placeholder = @"-";
    [self.view addSubview:self.firstTeamScore];
    
    self.secondTeamScore = [UITextField new];
    self.secondTeamScore.keyboardType = UIKeyboardTypeNumberPad;
    self.secondTeamScore.textAlignment = NSTextAlignmentCenter;
    self.secondTeamScore.borderStyle = UITextBorderStyleRoundedRect;
    self.secondTeamScore.placeholder = @"-";
    [self.view addSubview:self.secondTeamScore];
    
    self.firstTeamScore.font = [UIFont systemFontOfSize:30];
    self.secondTeamScore.font = [UIFont systemFontOfSize:30];
    
    self.nextEndButton = [CURButton new];
    [self.nextEndButton setTitle:@"Next end" forState:UIControlStateNormal];
    [self.nextEndButton addTarget:self action:@selector(switchToNextEnd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextEndButton];
    
    self.closeGameButton = [CURButton new];
    [self.closeGameButton setTitle:@"End game" forState:UIControlStateNormal];
    [self.closeGameButton addTarget:self action:@selector(closeGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeGameButton];
}

- (void)updateViewConstraints
{
    if (self.navigationController)
    {
        [self.teamNameFirst mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.navigationController.navigationBar.mas_bottom).with.offset(INDENT);
            make.left.mas_equalTo(self.view).with.offset(INDENT);
        }];
        [self.teamNameSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.teamNameFirst.mas_bottom).with.offset(INDENT);
            make.left.mas_equalTo(self.teamNameFirst);
            make.size.mas_equalTo(self.teamNameFirst);
            make.bottom.mas_equalTo(self.secondTeamScore);
        }];
        [self.firstTeamScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_greaterThanOrEqualTo(self.teamNameFirst);
            make.left.mas_equalTo(self.teamNameFirst.mas_right).with.offset(INDENT);
            make.right.mas_equalTo(self.view).with.offset(-INDENT*2);
            //make.width.mas_equalTo(self.firstTeamScore.mas_height);
        }];
        [self.secondTeamScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.firstTeamScore.mas_bottom).with.offset(INDENT);
            make.left.mas_equalTo(self.firstTeamScore);
            make.size.mas_equalTo(self.firstTeamScore);
        }];
        [self.nextEndButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.teamNameSecond.mas_bottom).with.offset(INDENT);
            make.centerX.mas_equalTo(self.view);
        }];
        [self.closeGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nextEndButton.mas_bottom).with.offset(INDENT);
            make.bottom.mas_lessThanOrEqualTo(self.view).with.offset(-INDENT);
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(self.nextEndButton);
        }];
    }
    
    [super updateViewConstraints];
}

- (void)switchToNextEnd
{
    [self.gameManager.coreDataManager saveFirstScore:[self.firstTeamScore.text intValue] andSecondScore:[self.secondTeamScore.text intValue] forEnd:[self.gameManager getEndNumber] andHash:self.gameInfo.hashLink];
    
    if ([self.firstTeamScore.text intValue] != [self.secondTeamScore.text intValue])
    {
        if ([self.firstTeamScore.text intValue] > [self.secondTeamScore.text intValue])
        {
            [self.gameManager setFirstStoneColor:[self.gameManager getFirstTeamColor]];
        }
        else
        {
            UIColor *color = [self.gameManager getFirstTeamColor] == [UIColor redColor] ? [UIColor yellowColor] : [UIColor redColor];
            [self.gameManager setFirstStoneColor:color];
        }
    }
    CURGameViewController *gameViewController = [[CURGameViewController alloc] initWithManager:self.gameManager];
    [self.navigationController pushViewController:gameViewController animated:YES];
}

- (void)closeGame
{
    [self.gameManager.coreDataManager saveFirstScore:[self.firstTeamScore.text intValue] andSecondScore:[self.secondTeamScore.text intValue] forEnd:[self.gameManager getEndNumber] andHash:self.gameInfo.hashLink];
    [self.gameManager finishGame];
    
    CURCoreDataManager *coreDataManager = self.gameManager.coreDataManager;
    GameInfo *gameInfo = [coreDataManager loadGamesInfoByHash:[self.gameManager getHashLink]];
    
    CURViewGameViewController *viewGameViewController = [CURViewGameViewController new];
    viewGameViewController.gameInfo = gameInfo;
    viewGameViewController.coreDataManager = coreDataManager;
    [self.navigationController pushViewController:viewGameViewController animated:YES];
}

@end
