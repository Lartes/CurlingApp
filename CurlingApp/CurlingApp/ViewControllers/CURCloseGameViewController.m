//
//  SURCloseGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 05/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURCloseGameViewController.h"

@interface CURCloseGameViewController ()

@property (nonatomic, strong) CURButton *nextEndButton;
@property (nonatomic, strong) CURButton *closeGameButton;
@property (nonatomic, strong) UITextField *firstTeamScore;
@property (nonatomic, strong) UITextField *secondTeamScore;
@property (nonatomic, strong) UILabel* teamNameFirst;
@property (nonatomic, strong) UILabel* teamNameSecond;
@property (nonatomic, strong) GameInfo *gameInfo;

@end

@implementation CURCloseGameViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI
{
    self.navigationItem.title = @"Счет";
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
    
    self.teamNameFirst.font = [UIFont systemFontOfSize:CURMediumFontSize];
    self.teamNameSecond.font = [UIFont systemFontOfSize:CURMediumFontSize];
    
    self.firstTeamScore = [UITextField new];
    self.firstTeamScore.textAlignment = NSTextAlignmentCenter;
    self.firstTeamScore.borderStyle = UITextBorderStyleRoundedRect;
    self.firstTeamScore.placeholder = @"-";
    [self.view addSubview:self.firstTeamScore];
    
    self.secondTeamScore = [UITextField new];
    self.secondTeamScore.textAlignment = NSTextAlignmentCenter;
    self.secondTeamScore.borderStyle = UITextBorderStyleRoundedRect;
    self.secondTeamScore.placeholder = @"-";
    [self.view addSubview:self.secondTeamScore];
    
    self.firstTeamScore.font = [UIFont systemFontOfSize:CURBigFontSize];
    self.secondTeamScore.font = [UIFont systemFontOfSize:CURBigFontSize];
    
    self.nextEndButton = [CURButton new];
    [self.nextEndButton setTitle:@"Следующий энд" forState:UIControlStateNormal];
    [self.nextEndButton addTarget:self action:@selector(nextEndButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextEndButton];
    
    self.closeGameButton = [CURButton new];
    [self.closeGameButton setTitle:@"Завершить игру" forState:UIControlStateNormal];
    [self.closeGameButton addTarget:self action:@selector(closeGameButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeGameButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.teamNameFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(CURTabBarHeight+CURUIIndent);
        make.left.mas_equalTo(self.view).with.offset(CURUIIndent);
    }];
    [self.teamNameSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teamNameFirst.mas_bottom).with.offset(CURUIIndent);
        make.left.mas_equalTo(self.teamNameFirst);
        make.size.mas_equalTo(self.teamNameFirst);
        make.bottom.mas_equalTo(self.secondTeamScore);
    }];
    [self.firstTeamScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_greaterThanOrEqualTo(self.teamNameFirst);
        make.left.mas_equalTo(self.teamNameFirst.mas_right).with.offset(CURUIIndent);
        make.right.mas_equalTo(self.view).with.offset(-CURUIIndent*2);
    }];
    [self.secondTeamScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstTeamScore.mas_bottom).with.offset(CURUIIndent);
        make.left.mas_equalTo(self.firstTeamScore);
        make.size.mas_equalTo(self.firstTeamScore);
    }];
    [self.nextEndButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teamNameSecond.mas_bottom).with.offset(CURUIIndent);
        make.centerX.mas_equalTo(self.view);
    }];
    [self.closeGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nextEndButton.mas_bottom).with.offset(CURUIIndent);
        make.bottom.mas_lessThanOrEqualTo(self.view).with.offset(-CURUIIndent);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(self.nextEndButton);
    }];
    
    [super updateViewConstraints];
}


#pragma mark - Button Actions

- (void)nextEndButtonPressed
{
    [self.nextEndButton tapAnimation];
    
    if(self.firstTeamScore.text.length > 0 && self.secondTeamScore.text.length > 0)
    {
        [self switchToNextEnd];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Введите счет команд."
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Хорошо"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)switchToNextEnd
{
    [self.gameManager.coreDataManager saveFirstScore:[self.firstTeamScore.text intValue]
                                         secondScore:[self.secondTeamScore.text intValue]
                                              forEnd:[self.gameManager getEndNumber]
                                                hash:self.gameInfo.hashLink];
    
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

- (void)closeGameButtonPressed
{
    [self.closeGameButton tapAnimation];
    
    if(self.firstTeamScore.text.length > 0 && self.secondTeamScore.text.length > 0)
    {
        [self closeGame];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Введите счет команд"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Хорошо"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)closeGame
{
    [self.gameManager.coreDataManager saveFirstScore:[self.firstTeamScore.text intValue]
                                         secondScore:[self.secondTeamScore.text intValue]
                                              forEnd:[self.gameManager getEndNumber]
                                                hash:self.gameInfo.hashLink];
    [self.gameManager finishGame];
    
    CURCoreDataManager *coreDataManager = self.gameManager.coreDataManager;
    GameInfo *gameInfo = [coreDataManager loadGamesInfoByHash:[self.gameManager getHashLink]];
    
    CURViewGameViewController *viewGameViewController = [CURViewGameViewController new];
    viewGameViewController.gameInfo = gameInfo;
    viewGameViewController.coreDataManager = coreDataManager;
    [self.navigationController pushViewController:viewGameViewController animated:YES];
}

@end
