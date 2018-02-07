//
//  SURCloseGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 05/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURCloseGameViewController.h"

static const CGFloat INDENT = 10.;
static const CGFloat BUTTONHEIGHT = 40.;

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.gameInfo = [self.gameManager.coreDataManager loadGamesInfoByHash:[self.gameManager getHashLink]];
    
    self.teamNameFirst = [[UILabel alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.navigationController.navigationBar.frame)+INDENT, CGRectGetWidth(self.view.frame)/2., BUTTONHEIGHT)];
    self.teamNameFirst.textColor = [UIColor blackColor];
    self.teamNameFirst.text = self.gameInfo.teamNameFirst;
    [self.view addSubview:self.teamNameFirst];
    
    self.teamNameSecond = [[UILabel alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.teamNameFirst.frame)+INDENT, CGRectGetWidth(self.view.frame)/2., BUTTONHEIGHT)];
    self.teamNameSecond.textColor = [UIColor blackColor];
    self.teamNameSecond.text = self.gameInfo.teamNameSecond;
    [self.view addSubview:self.teamNameSecond];
    
    self.firstTeamScore = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2.+INDENT, CGRectGetMaxY(self.navigationController.navigationBar.frame)+INDENT, 50, BUTTONHEIGHT)];
    self.firstTeamScore.keyboardType = UIKeyboardTypeNumberPad;
    self.firstTeamScore.text = @"0";
    self.firstTeamScore.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.firstTeamScore];
    
    self.secondTeamScore = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2.+INDENT, CGRectGetMaxY(self.teamNameFirst.frame)+INDENT, 50, BUTTONHEIGHT)];
    self.secondTeamScore.keyboardType = UIKeyboardTypeNumberPad;
    self.secondTeamScore.text = @"0";
    self.secondTeamScore.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.secondTeamScore];
    
    self.nextEndButton = [[UIButton alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.teamNameSecond.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*2, BUTTONHEIGHT)];
    [self.nextEndButton setTitle:@"Next end" forState:UIControlStateNormal];
    self.nextEndButton.backgroundColor = [UIColor grayColor];
    [self.nextEndButton addTarget:self action:@selector(switchToNextEnd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextEndButton];
    
    self.closeGameButton = [[UIButton alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.nextEndButton.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*2, BUTTONHEIGHT)];
    [self.closeGameButton setTitle:@"End game" forState:UIControlStateNormal];
    self.closeGameButton.backgroundColor = [UIColor grayColor];
    [self.closeGameButton addTarget:self action:@selector(closeGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeGameButton];
}

- (void)switchToNextEnd
{
    NSString *score = [NSString stringWithFormat:@"%@:%@", self.firstTeamScore.text, self.secondTeamScore.text];
    [self.gameManager.coreDataManager saveScore:score forEnd:[self.gameManager getEndNumber] andHash:self.gameInfo.hashLink];
    
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
    [self.gameManager finishGame];
    NSString *score = [NSString stringWithFormat:@"%@:%@", self.firstTeamScore.text, self.secondTeamScore.text];
    [self.gameManager.coreDataManager saveScore:score forEnd:[self.gameManager getEndNumber] andHash:self.gameInfo.hashLink];
    
    CURCoreDataManager *coreDataManager = self.gameManager.coreDataManager;
    GameInfo *gameInfo = [coreDataManager loadGamesInfoByHash:[self.gameManager getHashLink]];
    
    CURViewGameViewController *viewGameViewController = [CURViewGameViewController new];
    viewGameViewController.gameInfo = gameInfo;
    viewGameViewController.coreDataManager = coreDataManager;
    [self.navigationController pushViewController:viewGameViewController animated:YES];
}

@end
