//
//  CURViewGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURViewGameViewController.h"

static const float LABELHEIGHT = 40.;
static const float INDENT = 10.;

@interface CURViewGameViewController ()

@property (nonatomic, strong) UILabel* teamNameFirst;
@property (nonatomic, strong) UILabel* teamNameSecond;

@end

@implementation CURViewGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
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

- (void)toMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
