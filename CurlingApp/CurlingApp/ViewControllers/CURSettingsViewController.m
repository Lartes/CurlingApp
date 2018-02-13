//
//  CURSettingsViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 12/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURSettingsViewController.h"

@interface CURSettingsViewController ()

@end

@implementation CURSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
    loginButton.backgroundColor = [UIColor grayColor];
    [loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 100, 50)];
    saveButton.backgroundColor = [UIColor grayColor];
    [saveButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.view addSubview:saveButton];
}

- (void)saveButtonPressed
{
    [self.coreDataManager saveToDropbox];
}

- (void)loginButtonPressed
{
    NSLog(@"Pressed!");
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

@end
