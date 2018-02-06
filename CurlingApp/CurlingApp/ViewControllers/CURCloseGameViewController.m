//
//  SURCloseGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 05/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURCloseGameViewController.h"
#import "CURViewGameViewController.h"
#import "CURGameViewController.h"

static const CGFloat INDENT = 10.;
static const CGFloat BUTTONHEIGHT = 40.;

@interface CURCloseGameViewController ()

@property (nonatomic, strong) UIButton *nextEndButton;
@property (nonatomic, strong) UIButton *closeGameButton;

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
    
    self.nextEndButton = [[UIButton alloc] initWithFrame:CGRectMake(INDENT, CGRectGetMaxY(self.navigationController.navigationBar.frame)+INDENT, CGRectGetWidth(self.view.frame)-INDENT*2, BUTTONHEIGHT)];
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
    CURGameViewController *gameViewController = [[CURGameViewController alloc] initWithManager:self.gameManager];
    [self.navigationController pushViewController:gameViewController animated:YES];
}

- (void)closeGame
{
    CURViewGameViewController *viewGameViewController = [CURViewGameViewController new];
    
    NSManagedObjectContext *coreDataContext = self.gameManager.coreDataContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GameInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", [self.gameManager getHashLink]];
    fetchRequest.predicate = predicate;
    NSArray *fetchedObjects = [coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    if (fetchedObjects.count>0)
    {
        viewGameViewController.gameInfo = fetchedObjects[0];
    }
    viewGameViewController.coreDataContext = coreDataContext;
    [self.navigationController pushViewController:viewGameViewController animated:YES];
}

@end
