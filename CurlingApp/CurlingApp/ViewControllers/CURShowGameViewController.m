//
//  CURShowGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 07/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURShowGameViewController.h"

@interface CURShowGameViewController ()

@property (nonatomic, strong) CURScrollView *trackScrollView;
@property (nonatomic, strong) CURScoreView *scoreView;
@property (nonatomic, strong) CURShowGameManager *showGameManager;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *nextEndButton;
@property (nonatomic, strong) UIButton *previousEndButton;

@end

@implementation CURShowGameViewController

- (instancetype)initWithManager:(CURShowGameManager *)showGameManager
{
    self = [super init];
    if(self)
    {
        _showGameManager = showGameManager;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI
{
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scoreView = [[CURScoreView alloc] initWithFrame:CGRectMake(0, 0, 100, CGRectGetHeight(self.navigationController.navigationBar.frame))];
    self.navigationItem.titleView = self.scoreView;
    
    self.showGameManager.output = self.scoreView;
    
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
    
    self.nextEndButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*2/3, CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame)/3, 30)];
    self.nextEndButton.backgroundColor = [UIColor grayColor];
    [self.nextEndButton setTitle:@"Next end" forState:UIControlStateNormal];
    [self.nextEndButton addTarget:self action:@selector(nextEnd) forControlEvents:UIControlEventTouchUpInside];
    if ([self.showGameManager isLastEnd])
    {
        self.nextEndButton.hidden = YES;
    }
    [self.view addSubview:self.nextEndButton];
    
    self.previousEndButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame)/3, 30)];
    self.previousEndButton.backgroundColor = [UIColor grayColor];
    [self.previousEndButton setTitle:@"Past end" forState:UIControlStateNormal];
    [self.previousEndButton addTarget:self action:@selector(previousEnd) forControlEvents:UIControlEventTouchUpInside];
    if ([self.showGameManager isFirstEnd])
    {
        self.previousEndButton.hidden = YES;
    }
    [self.view addSubview:self.previousEndButton];
    
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*2/3, CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame)/3, 30)];
    self.nextButton.backgroundColor = [UIColor grayColor];
    [self.nextButton setTitle:@"-->" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextStone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    self.previousButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame)/3, 30)];
    self.previousButton.backgroundColor = [UIColor grayColor];
    [self.previousButton setTitle:@"<--" forState:UIControlStateNormal];
    [self.previousButton addTarget:self action:@selector(previousStone) forControlEvents:UIControlEventTouchUpInside];
    self.previousButton.hidden = YES;
    [self.view addSubview:self.previousButton];
    
    NSArray *stones = [self.showGameManager startShowGame];
    for (UIView *stone in stones)
    {
        [self.trackScrollView addSubview:stone];
    }
}

- (void)nextStone
{
    self.nextButton.hidden = [self.showGameManager showNextStep];
    self.previousButton.hidden = NO;
}

- (void)previousStone
{
    self.previousButton.hidden = [self.showGameManager showPreviousStep];
    self.nextButton.hidden = NO;
}

- (void)nextEnd
{
    [self.scoreView resetScore];
    self.nextEndButton.hidden = [self.showGameManager changeEndOnNumber:1];
    self.previousEndButton.hidden = NO;
    
    self.previousButton.hidden = YES;
    self.nextButton.hidden = NO;
}

- (void)previousEnd
{
    [self.scoreView resetScore];
    self.previousEndButton.hidden = [self.showGameManager changeEndOnNumber:-1];
    self.nextEndButton.hidden = NO;
    
    self.previousButton.hidden = YES;
    self.nextButton.hidden = NO;
}

- (void)closeGame
{
    [self.navigationController popViewControllerAnimated:YES];
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
