//
//  CURGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURGameViewController.h"
#import "CURCloseGameViewController.h"
#import "CURScrollView.h"
#import "CURScoreView.h"

@interface CURGameViewController ()

@property (nonatomic, strong) CURScrollView *trackScrollView;
@property (nonatomic, strong) CURScoreView *scoreView;
@property (nonatomic, strong) CURGameManager *gameManager;

@end

@implementation CURGameViewController

- (instancetype)initWithManager:(CURGameManager *)gameManager
{
    self = [super init];
    if(self)
    {
        _gameManager = gameManager;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    
    [self.gameManager startEnd];
}

- (void)prepareUI
{
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scoreView = [[CURScoreView alloc] initWithFrame:CGRectMake(0, 0, 100, CGRectGetHeight(self.navigationController.navigationBar.frame))];
    self.navigationItem.titleView = self.scoreView;
    
    self.gameManager.output = self.scoreView;
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeGame)];
    self.navigationItem.rightBarButtonItem = closeButton;
    
    self.trackScrollView = [[CURScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    self.trackScrollView.showsVerticalScrollIndicator = NO;
    self.trackScrollView.output = self;
    
    UIImage *image = [UIImage imageNamed:@"track"];
    self.trackScrollView.contentSize = CGSizeMake(self.view.frame.size.width, (image.size.height/image.size.width)*self.view.frame.size.width);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, self.trackScrollView.contentSize.width, self.trackScrollView.contentSize.height);
    [self.trackScrollView addSubview:imageView];
    [self.view addSubview:self.trackScrollView];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*2/3, CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame)/3, 30)];
    nextButton.backgroundColor = [UIColor grayColor];
    [nextButton setTitle:@"Next stone" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextStone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    
    UIView *stone = [self.gameManager addStone];
    [self.trackScrollView addSubview:stone];
}

- (void)nextStone
{
    if ([self.gameManager isEndFinished])
    {
        [self.gameManager finishEnd];
        
        CURCloseGameViewController *closeGameViewController = [CURCloseGameViewController new];
        closeGameViewController.gameManager = self.gameManager;
        [self.navigationController pushViewController:closeGameViewController animated:YES];
    }
    UIView *stone = [self.gameManager addStone];
    [self.trackScrollView addSubview:stone];
}

- (void)closeGame
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - CURTouchDetectProtocol

- (void)touchHappendAtCoord:(CGPoint)coord onView:(UIView *)view
{
    if(view!=self.trackScrollView)
    {
        view.center = coord;
    }
}

@end
