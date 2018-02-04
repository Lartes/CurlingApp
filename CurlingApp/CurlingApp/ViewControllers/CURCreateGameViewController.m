//
//  CURCreateGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURCreateGameViewController.h"
#import "CURGameViewController.h"

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
    CURGameViewController *gameViewController = [CURGameViewController new];
    [self.navigationController pushViewController:gameViewController animated:YES];
}

@end
