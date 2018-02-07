//
//  CURViewGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURViewGameViewController.h"
#import "CURShowGameManager.h"
#import "CURShowGameViewController.h"

static const float LABELHEIGHT = 40.;
static const float INDENT = 10.;

@interface CURViewGameViewController ()

@property (nonatomic, strong) UILabel* teamNameFirst;
@property (nonatomic, strong) UILabel* teamNameSecond;
@property (nonatomic, strong) UIButton *viewButton;

@end

@implementation CURViewGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.coreDataManager)
    {
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteGame)];
        self.navigationItem.rightBarButtonItem = deleteButton;
        
        self.viewButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*2/3, CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame)/3, 30)];
        self.viewButton.backgroundColor = [UIColor grayColor];
        [self.viewButton setTitle:@"Show game" forState:UIControlStateNormal];
        [self.viewButton addTarget:self action:@selector(showGame) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.viewButton];
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Games" style:UIBarButtonItemStylePlain target:self action:@selector(toMainView)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.teamNameFirst = [[UILabel alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.navigationController.navigationBar.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*2, LABELHEIGHT)];
    self.teamNameFirst.textColor = [UIColor blackColor];
    [self.view addSubview:self.teamNameFirst];
    
    self.teamNameSecond = [[UILabel alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.teamNameFirst.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*2, LABELHEIGHT)];
    self.teamNameSecond.textColor = [UIColor blackColor];
    [self.view addSubview:self.teamNameSecond];
    
    if (self.gameInfo)
    {
        self.teamNameFirst.text = self.gameInfo.teamNameFirst;
        self.teamNameSecond.text = self.gameInfo.teamNameSecond;
    }
}

- (void)deleteGame
{
    [self.coreDataManager deleteGame:self.gameInfo];
    [self toMainView];
}

- (void)toMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showGame
{
    CURShowGameManager *gameManager = [[CURShowGameManager alloc] initWithGameInfo:self.gameInfo];
    gameManager.coreDataManager = self.coreDataManager;
    
    CURShowGameViewController *gameViewController = [[CURShowGameViewController alloc] initWithManager:gameManager];
    [self.navigationController pushViewController:gameViewController animated:YES];
}

@end
