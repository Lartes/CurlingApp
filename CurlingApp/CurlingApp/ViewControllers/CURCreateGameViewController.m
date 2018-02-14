//
//  CURCreateGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURCreateGameViewController.h"

@interface CURCreateGameViewController ()

@property (nonatomic, strong) UITextField *teamNameFirst;
@property (nonatomic, strong) UITextField *teamNameSecond;
@property (nonatomic, strong) UIView *teamColorFirst;
@property (nonatomic, strong) UIView *teamColorSecond;
@property (nonatomic, strong) CURButton *createButton;

@end

@implementation CURCreateGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.teamColorFirst = [UIView new];
    self.teamColorFirst.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.teamColorFirst];
    
    self.teamColorSecond = [UIView new];
    self.teamColorSecond.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.teamColorSecond];
    
    UITapGestureRecognizer *tapRecognizerFirst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeColor)];
    tapRecognizerFirst.delaysTouchesBegan = YES;
    tapRecognizerFirst.numberOfTapsRequired = 1;
    [self.teamColorFirst addGestureRecognizer:tapRecognizerFirst];
    
    UITapGestureRecognizer *tapRecognizerSecond = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeColor)];
    tapRecognizerSecond.delaysTouchesBegan = YES;
    tapRecognizerSecond.numberOfTapsRequired = 1;
    [self.teamColorSecond addGestureRecognizer:tapRecognizerSecond];
    
    self.teamNameFirst = [UITextField new];
    self.teamNameFirst.placeholder = @"Первая команда";
    self.teamNameFirst.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.teamNameFirst];
    
    self.teamNameSecond = [UITextField new];
    self.teamNameSecond.placeholder = @"Вторая команда";
    self.teamNameSecond.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.teamNameSecond];
    
    self.teamNameFirst.borderStyle = UITextBorderStyleRoundedRect;
    self.teamNameSecond.borderStyle = UITextBorderStyleRoundedRect;
    
    self.teamNameFirst.font = [UIFont systemFontOfSize:SMALLFONT];
    self.teamNameSecond.font = [UIFont systemFontOfSize:SMALLFONT];
    
    self.createButton = [CURButton new];
    self.createButton.titleLabel.font = [UIFont systemFontOfSize:SMALLFONT];
    [self.createButton setTitle:@"Создать игру" forState:UIControlStateNormal];
    [self.createButton addTarget:self action:@selector(createButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createButton];
}

- (void)updateViewConstraints
{
    if (self.navigationController)
    {
        [self.teamNameFirst mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.navigationController.navigationBar.mas_bottom).with.offset(INDENT);
            make.left.mas_equalTo(self.view).with.offset(INDENT);
            make.height.mas_equalTo(FIELDHEIGHT);
        }];
        [self.teamNameSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.teamNameFirst.mas_bottom).with.offset(INDENT);
            make.left.mas_equalTo(self.teamNameFirst);
            make.size.mas_equalTo(self.teamNameFirst);
        }];
        [self.teamColorFirst mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.teamNameFirst);
            make.left.mas_equalTo(self.teamNameFirst.mas_right).with.offset(INDENT);
            make.right.mas_equalTo(self.view).with.offset(-INDENT);
            make.width.mas_equalTo(self.teamColorFirst.mas_height);
        }];
        [self.teamColorSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.teamColorFirst.mas_bottom).with.offset(INDENT);
            make.left.mas_equalTo(self.teamColorFirst);
            make.size.mas_equalTo(self.teamColorFirst);
            make.bottom.mas_equalTo(self.teamNameSecond);
        }];
        [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.teamNameSecond.mas_bottom).with.offset(INDENT);
            make.left.mas_greaterThanOrEqualTo(self.view).with.offset(INDENT);
            make.right.mas_lessThanOrEqualTo(self.view).with.offset(-INDENT);
            make.bottom.mas_lessThanOrEqualTo(self.view).with.offset(INDENT);
            make.centerX.mas_equalTo(self.view);
            make.height.mas_equalTo(FIELDHEIGHT);
        }];
    }
    
    [super updateViewConstraints];
}

- (void)createButtonPressed
{
    if(self.teamNameFirst.text.length > 0 && self.teamNameSecond.text.length > 0)
    {
        [self createGame];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Введите названия команд" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Хорошо" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)createGame
{
    [self.createButton tapAnimation];
    
    CURGameInfo *gameInfo = [CURGameInfo new];
    gameInfo.teamNameFirst = self.teamNameFirst.text;
    gameInfo.teamNameSecond = self.teamNameSecond.text;
    gameInfo.hashLink = [NSString stringWithFormat:@"%@%@%d", gameInfo.teamNameFirst, gameInfo.teamNameSecond, rand()];
    gameInfo.date = [NSDate date];
    gameInfo.isFirstTeamColorRed = self.teamColorFirst.backgroundColor == [UIColor redColor];
    [self.coreDataManager saveGameInfo:gameInfo];
    
    CURGameManager *gameManager = [[CURGameManager alloc] initWithColor:self.teamColorFirst.backgroundColor andHash:gameInfo.hashLink andStoneSize:CGRectGetWidth(self.view.frame)/STONESIZEDIVIDER];
    gameManager.coreDataManager = self.coreDataManager;
    
    CURGameViewController *gameViewController = [[CURGameViewController alloc] initWithManager:gameManager];
    [self.navigationController pushViewController:gameViewController animated:YES];
     
}

- (void)changeColor
{
    if (self.teamColorFirst.backgroundColor ==[UIColor redColor])
    {
        self.teamColorFirst.backgroundColor = [UIColor yellowColor];
        self.teamColorSecond.backgroundColor = [UIColor redColor];
    }
    else
    {
        self.teamColorFirst.backgroundColor = [UIColor redColor];
        self.teamColorSecond.backgroundColor = [UIColor yellowColor];
    }
}

@end
