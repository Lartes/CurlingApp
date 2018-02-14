//
//  CURSettingsViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 12/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURSettingsViewController.h"

@interface CURSettingsViewController ()

@property (nonatomic, strong) CURButton *loginButton;
@property (nonatomic, strong) CURButton *saveButton;
@property (nonatomic, strong) CURButton *loadButton;
@property (nonatomic, strong) CURLoadingAnimationView *loadingAnimation;
@property (nonatomic, strong) UIImageView *dropboxImage;

@end

@implementation CURSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Игры" style:UIBarButtonItemStylePlain target:self action:@selector(toMainView)];
    self.navigationItem.rightBarButtonItem = backButton;
    self.navigationItem.hidesBackButton = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dropboxImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropbox"]];
    [self.view addSubview:self.dropboxImage];
    
    self.loginButton = [CURButton new];
    [self.loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setTitle:@"Авторизоваться" forState:UIControlStateNormal];
    self.loginButton.enabled = NO;
    [self.view addSubview:self.loginButton];
    
    self.saveButton = [CURButton new];
    [self.saveButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setTitle:@"Сохранить" forState:UIControlStateNormal];
    [self.view addSubview:self.saveButton];
    
    self.loadButton = [CURButton new];
    [self.loadButton addTarget:self action:@selector(loadButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.loadButton setTitle:@"Загрузить" forState:UIControlStateNormal];
    [self.view addSubview:self.loadButton];
    
    self.loadingAnimation = [CURLoadingAnimationView new];
    self.loadingAnimation.hidden = YES;
    [self.view addSubview:self.loadingAnimation];
}

- (void)updateViewConstraints
{
    if(self.navigationController)
    {
        [self.dropboxImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_greaterThanOrEqualTo(self.navigationController.navigationBar.mas_bottom).with.offset(INDENT);
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(self.dropboxImage.mas_height);
            make.width.mas_equalTo(CGRectGetWidth(self.view.frame)/2.);
        }];
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dropboxImage.mas_bottom).with.offset(INDENT);
            make.center.mas_equalTo(self.view);
        }];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.loginButton.mas_bottom).with.offset(INDENT);
            make.left.mas_equalTo(self.loginButton);
            make.size.mas_equalTo(self.loginButton);
        }];
        [self.loadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.saveButton.mas_bottom).with.offset(INDENT);
            make.left.mas_equalTo(self.loginButton);
            make.size.mas_equalTo(self.loginButton);
            make.bottom.mas_lessThanOrEqualTo(self.view).with.offset(-INDENT);
        }];
        
        [self.loadingAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    
    [super updateViewConstraints];
}

- (void)toMainView
{
    CATransition *transition = [CATransition animation];
    transition.duration = SETTINGSTRANSITIONDURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)saveButtonPressed
{
    self.loadingAnimation.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [self.loadingAnimation startAnimation];
    
    CURNetworkManager *networkManager = [CURNetworkManager new];
    networkManager.coreDataManager = self.coreDataManager;
    networkManager.output = self;
    [networkManager saveToDropbox];
}

- (void)loadButtonPressed
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Загрузить данные?" message:@"Вся текущая информация будет удалена" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        self.loadingAnimation.hidden = NO;
        self.navigationController.navigationBar.hidden = YES;
        [self.loadingAnimation startAnimation];
        
        CURNetworkManager *networkManager = [CURNetworkManager new];
        networkManager.coreDataManager = self.coreDataManager;
        networkManager.output = self;
        [networkManager loadFromDropbox];
    }];
    [alert addAction:actionCancel];
    [alert addAction:actionOk];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loginButtonPressed
{
    NSString *state = [NSString stringWithFormat:@"%d", rand()];
    NSString *stringURL = [NSString stringWithFormat:@"https://www.dropbox.com/oauth2/authorize?response_type=token&client_id=9m3zfx24z7qwgvj&redirect_uri=iOSCurlingApp://dropbox_callback&state=%@", state];
    NSURL* url = [[NSURL alloc] initWithString: stringURL];
    [[UIApplication sharedApplication] openURL: url];
}

- (NSString *)valueForKey:(NSString *)key
           fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems
                                  filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}

- (void)setReceivedURL:(NSURL *)url
{
    NSURLComponents *urlComponents = [NSURLComponents new];
    urlComponents.query = [url fragment];
    NSArray *queryItems  = urlComponents.queryItems;
    if([self.coreDataManager saveAccessToken:[self valueForKey:@"access_token" fromQueryItems:queryItems]])
    {
        self.loginButton.enabled = NO;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Доступ получен" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Хорошо" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Доступ не получен" message:@"Повторите попытку" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Хорошо" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    };
}


#pragma mark - CURNetworkManagerProtocol

- (void)taskDidFinishedWithStatus:(BOOL)status
{
    [self.loadingAnimation stopAnimation];
    self.loadingAnimation.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    
    if(status)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Загрузка завершена" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Хорошо" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        self.loginButton.enabled = YES;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка загрузки" message:@"Необходимо пройти авторизацию" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Хорошо" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    };
}

@end
