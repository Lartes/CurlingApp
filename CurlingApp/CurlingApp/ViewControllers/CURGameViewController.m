//
//  CURGameViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURGameViewController.h"

static const float INDENT = 10.;

@interface CURGameViewController ()

@property (nonatomic, strong) CURScrollView *trackScrollView;
@property (nonatomic, strong) CURScoreView *scoreView;
@property (nonatomic, strong) CURGameManager *gameManager;
@property (nonatomic, strong) CURButton *nextButton;

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
    [self.trackScrollView addSubview:[self.gameManager addStone]];
}

- (void)prepareUI
{
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeGame)];
    self.navigationItem.rightBarButtonItem = closeButton;
    
    self.scoreView = [[CURScoreView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.navigationController.navigationBar.frame)) andCenterX:self.view.center.x - 8.];
    self.navigationItem.titleView = self.scoreView;
    
    self.gameManager.output = self.scoreView;
    
    self.trackScrollView = [CURScrollView new];
    self.trackScrollView.showsVerticalScrollIndicator = NO;
    self.trackScrollView.output = self;
    
    UIImage *image = [UIImage imageNamed:@"track"];
    self.trackScrollView.contentSize = CGSizeMake(self.view.frame.size.width, (image.size.height/image.size.width)*self.view.frame.size.width);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, self.trackScrollView.contentSize.width, self.trackScrollView.contentSize.height);
    [self.trackScrollView addSubview:imageView];
    [self.view addSubview:self.trackScrollView];
    
    self.nextButton = [CURButton new];
    [self.nextButton setTitle:@"Далее" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextStone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
}

- (void)updateViewConstraints
{
    if (self.navigationController)
    {
        [self.trackScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.navigationController.navigationBar.mas_bottom);
            make.left.right.and.bottom.mas_equalTo(self.view);
        }];
        [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view).with.offset(-INDENT);
            make.right.mas_equalTo(self.view).with.offset(-INDENT);
        }];
    }
    
    [super updateViewConstraints];
}

- (void)nextStone
{
    [self.nextButton tapAnimation];
    
    if ([self.gameManager isEndFinished])
    {
        [self.gameManager finishEnd];
        
        CURCloseGameViewController *closeGameViewController = [CURCloseGameViewController new];
        closeGameViewController.gameManager = self.gameManager;
        [self.navigationController pushViewController:closeGameViewController animated:YES];
    }
    else
    {
        UIView *stone = [self.gameManager addStone];
        [self.trackScrollView addSubview:stone];
    }
}

- (void)closeGame
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Закрыть игру?" message:@"Текущий энд не будет сохранен." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self.gameManager.coreDataManager deleteEndByHash:[self.gameManager getHashLink] andEndNumber:[self.gameManager getEndNumber]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:actionCancel];
    [alert addAction:actionOk];
    [self presentViewController:alert animated:YES completion:nil];
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
