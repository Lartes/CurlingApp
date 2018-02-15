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
@property (nonatomic, strong) CURButton *nextButton;
@property (nonatomic, strong) CURButton *previousButton;
@property (nonatomic, strong) CURButton *nextEndButton;
@property (nonatomic, strong) CURButton *previousEndButton;

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
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeGame)];
    self.navigationItem.rightBarButtonItem = closeButton;
    
    self.scoreView = [[CURScoreView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.navigationController.navigationBar.frame)) andCenterX:self.view.center.x - 8.];
    self.navigationItem.titleView = self.scoreView;
    
    self.showGameManager.output = self.scoreView;
    
    self.trackScrollView = [CURScrollView new];
    self.trackScrollView.showsVerticalScrollIndicator = NO;
    self.trackScrollView.output = self;
    
    UIImage *image = [UIImage imageNamed:@"track"];
    self.trackScrollView.contentSize = CGSizeMake(self.view.frame.size.width, (image.size.height/image.size.width)*self.view.frame.size.width);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, self.trackScrollView.contentSize.width, self.trackScrollView.contentSize.height);
    [self.trackScrollView addSubview:imageView];
    [self.view addSubview:self.trackScrollView];
    
    self.nextEndButton = [CURButton new];
    [self.nextEndButton setTitle:@"Следующий энд" forState:UIControlStateNormal];
    [self.nextEndButton addTarget:self action:@selector(nextEnd) forControlEvents:UIControlEventTouchUpInside];
    self.nextEndButton.hidden = YES;
    [self.view addSubview:self.nextEndButton];
    
    self.previousEndButton = [CURButton new];
    [self.previousEndButton setTitle:@"Предыдущий энд" forState:UIControlStateNormal];
    [self.previousEndButton addTarget:self action:@selector(previousEnd) forControlEvents:UIControlEventTouchUpInside];
    if ([self.showGameManager isFirstEnd])
    {
        self.previousEndButton.hidden = YES;
    }
    [self.view addSubview:self.previousEndButton];
    
    self.nextButton = [CURButton new];
    [self.nextButton setTitle:@"-->" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextStone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    self.previousButton = [CURButton new];
    [self.previousButton setTitle:@"<--" forState:UIControlStateNormal];
    [self.previousButton addTarget:self action:@selector(previousStone) forControlEvents:UIControlEventTouchUpInside];
    self.previousButton.hidden = YES;
    [self.view addSubview:self.previousButton];
    
    NSArray *stones = [self.showGameManager startShowGame];
    for (UIView *stone in stones)
    {
        [self.trackScrollView addSubview:stone];
    }
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.trackScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(TABBARHEIGHT);
        make.left.right.and.bottom.mas_equalTo(self.view);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).with.offset(-INDENT);
        make.left.mas_equalTo(self.view.mas_centerX).with.offset(INDENT*2);
    }];
    [self.nextEndButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).with.offset(-INDENT);
        make.right.mas_equalTo(self.view).with.offset(-INDENT);
    }];
    [self.previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).with.offset(-INDENT);
        make.right.mas_equalTo(self.view.mas_centerX).with.offset(-INDENT*2);
    }];
    [self.previousEndButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).with.offset(-INDENT);
        make.left.mas_equalTo(self.view).with.offset(INDENT);
    }];
    
    [super updateViewConstraints];
}

- (void)nextStone
{
    [self.nextButton tapAnimation];
    
    self.nextButton.hidden = [self.showGameManager showNextStep];
    self.previousButton.hidden = NO;
    self.previousEndButton.hidden = YES;
    if (![self.showGameManager isLastEnd])
    {
        self.nextEndButton.hidden = !self.nextButton.hidden;
    }
}

- (void)previousStone
{
    [self.previousButton tapAnimation];
    
    self.previousButton.hidden = [self.showGameManager showPreviousStep];
    self.nextButton.hidden = NO;
    self.nextEndButton.hidden = YES;
    if (![self.showGameManager isFirstEnd])
    {
        self.previousEndButton.hidden = !self.previousButton.hidden;
    }
}

- (void)nextEnd
{
    [self.nextEndButton tapAnimation];
    
    [self.scoreView resetScore];
    [self.showGameManager changeEndOnNumber:1];
    
    self.nextEndButton.hidden = YES;
    self.previousEndButton.hidden = NO;
    self.previousButton.hidden = YES;
    self.nextButton.hidden = NO;
}

- (void)previousEnd
{
    [self.previousEndButton tapAnimation];
    
    [self.scoreView resetScore];
    [self.showGameManager changeEndOnNumber:-1];
    
    if ([self.showGameManager isFirstEnd])
    {
        self.previousEndButton.hidden = YES;
    }
    self.nextEndButton.hidden = YES;
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
