//
//  CURCreateGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURCreateGameViewController.h"
#import "CURGameViewController.h"
#import "GameInfo+CoreDataClass.h"
#import "CURGameInfo.h"

static const float FIELDHEIGHT = 40;
static const float INDENT = 10;

@interface CURCreateGameViewController ()

@property (nonatomic, strong) UITextField *teamNameFirst;
@property (nonatomic, strong) UITextField *teamNameSecond;
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
    
    self.teamNameFirst = [[UITextField alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.navigationController.navigationBar.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*2, FIELDHEIGHT)];
    self.teamNameFirst.placeholder = @"First team name";
    self.teamNameFirst.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.teamNameFirst];
    
    self.teamNameSecond = [[UITextField alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.teamNameFirst.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*2, FIELDHEIGHT)];
    self.teamNameSecond.placeholder = @"Second team name";
    self.teamNameSecond.backgroundColor = [UIColor lightGrayColor];
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
    
    CURGameManager *gameManager = [[CURGameManager alloc] initWithColor:[UIColor redColor] andHash:gameInfo.hashLink];
    gameManager.coreDataManager = self.coreDataManager;
    
    CURGameViewController *gameViewController = [[CURGameViewController alloc] initWithManager:gameManager];
    [self.navigationController pushViewController:gameViewController animated:YES];
}

@end
