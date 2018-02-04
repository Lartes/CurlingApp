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
    
    self.teamNameFirst = [[UILabel alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.navigationController.navigationBar.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*2, LABELHEIGHT)];
    self.teamNameFirst.textColor = [UIColor blackColor];
    self.teamNameFirst.text = [self.teamData objectForKey:@"teamNameFirst"];
    [self.view addSubview:self.teamNameFirst];
    
    self.teamNameSecond = [[UILabel alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.teamNameFirst.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*2, LABELHEIGHT)];
    self.teamNameSecond.textColor = [UIColor blackColor];
    self.teamNameSecond.text = [self.teamData objectForKey:@"teamNameSecond"];
    [self.view addSubview:self.teamNameSecond];
}

@end
