//
//  CURCreateGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURCreateGameViewController.h"


static const float FIELDHEIGHT = 40;
static const float INDENT = 10;

@interface CURCreateGameViewController ()

@property (nonatomic, strong) UITextField *teamNameFirst;
@property (nonatomic, strong) UITextField *teamNameSecond;
@property (nonatomic, strong) UIView *teamColorFirst;
@property (nonatomic, strong) UIView *teamColorSecond;
@property (nonatomic, strong) UIButton *createButton;

@end

@implementation CURCreateGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.teamColorFirst = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-INDENT-FIELDHEIGHT, CGRectGetMaxY(self.navigationController.navigationBar.frame)+INDENT, FIELDHEIGHT, FIELDHEIGHT)];
    self.teamColorFirst.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.teamColorFirst];
    
    self.teamColorSecond = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-INDENT-FIELDHEIGHT, CGRectGetMaxY(self.teamColorFirst.frame)+INDENT, FIELDHEIGHT, FIELDHEIGHT)];
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
    
    self.teamNameFirst = [[UITextField alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.navigationController.navigationBar.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*3-FIELDHEIGHT, FIELDHEIGHT)];
    self.teamNameFirst.placeholder = @"First team name";
    self.teamNameFirst.backgroundColor = [UIColor lightGrayColor];
    self.teamNameFirst.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.teamNameFirst];
    
    self.teamNameSecond = [[UITextField alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.teamNameFirst.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*3-FIELDHEIGHT, FIELDHEIGHT)];
    self.teamNameSecond.placeholder = @"Second team name";
    self.teamNameSecond.backgroundColor = [UIColor lightGrayColor];
    self.teamNameSecond.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.teamNameSecond];
    
    self.createButton = [[UIButton alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.teamNameSecond.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*2, FIELDHEIGHT)];
    [self.createButton setTitle:@"Create game" forState:UIControlStateNormal];
    self.createButton.backgroundColor = [UIColor grayColor];
    [self.createButton addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createButton];
}

- (void)createGame
{
    CURGameInfo *gameInfo = [CURGameInfo new];
    gameInfo.teamNameFirst = self.teamNameFirst.text;
    gameInfo.teamNameSecond = self.teamNameSecond.text;
    gameInfo.hashLink = [NSString stringWithFormat:@"%@%@", gameInfo.teamNameFirst, gameInfo.teamNameSecond ];
    [self.coreDataManager saveGameInfo:gameInfo];
    
    CURGameManager *gameManager = [[CURGameManager alloc] initWithColor:self.teamColorFirst.backgroundColor andHash:gameInfo.hashLink];
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
