//
//  CURNetworkManager.m
//  CurlingApp
//
//  Created by Artem Lomov on 14/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURNetworkManager.h"

@interface CURNetworkManager ()

@end

@implementation CURNetworkManager

- (void)loginToDropbox
{
    NSString *state = [NSString stringWithFormat:@"%d", rand()];
    NSString *stringURL = [NSString stringWithFormat:@"https://www.dropbox.com/oauth2/authorize?response_type=token&client_id=9m3zfx24z7qwgvj&redirect_uri=iOSCurlingApp://dropbox_callback&state=%@", state];
    NSURL* url = [[NSURL alloc] initWithString: stringURL];
    [[UIApplication sharedApplication] openURL: url options:@{} completionHandler:nil];
}

- (void)saveToDropbox
{
    NSArray *gamesInfo = [self.coreDataManager loadAllGamesInfo];
    NSMutableArray *gamesInfoToSave = [NSMutableArray new];
    NSMutableDictionary *dict = nil;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    for (GameInfo *gameInfo in gamesInfo)
    {
        dict = [NSMutableDictionary new];
        dict[@"teamNameFirst"] = gameInfo.teamNameFirst;
        dict[@"teamNameSecond"] = gameInfo.teamNameSecond;
        dict[@"hashLink"] = gameInfo.hashLink;
        dict[@"numberOfEnds"] = @(gameInfo.numberOfEnds);
        dict[@"firstTeamScore"] = @(gameInfo.firstTeamScore);
        dict[@"secondTeamScore"] = @(gameInfo.secondTeamScore);
        dict[@"isFirstTeamColorRed"] = @(gameInfo.isFirstTeamColorRed);
        dict[@"date"] = [dateFormatter stringFromDate:gameInfo.date];
        [gamesInfoToSave addObject:[dict copy]];
    }
    
    NSArray *stonesData = [self.coreDataManager loadAllStoneData];
    NSMutableArray *stonesDataToSave = [NSMutableArray new];
    for (StoneData *stoneData in stonesData)
    {
        dict = [NSMutableDictionary new];
        dict[@"hashLink"] = stoneData.hashLink;
        dict[@"stonePositionX"] = @(stoneData.stonePositionX);
        dict[@"stonePositionY"] = @(stoneData.stonePositionY);
        dict[@"stepNumber"] = @(stoneData.stepNumber);
        dict[@"isStoneColorRed"] = @(stoneData.isStoneColorRed);
        dict[@"endNumber"] = @(stoneData.endNumber);
        [stonesDataToSave addObject:[dict copy]];
    }
    
    NSArray *endScores = [self.coreDataManager loadAllEndScore];
    NSMutableArray *endScoresToSave = [NSMutableArray new];
    for (EndScore *endScore in endScores)
    {
        dict = [NSMutableDictionary new];
        dict[@"hashLink"] = endScore.hashLink;
        dict[@"endNumber"] = @(endScore.endNumber);
        dict[@"firstTeamScore"] = @(endScore.firstTeamScore);
        dict[@"secondTeamScore"] = @(endScore.secondTeamScore);
        [endScoresToSave addObject:[dict copy]];
    }
    
    NSDictionary *dataToSave = @{
        @"GameInfo":[gamesInfoToSave copy],
        @"StoneData":[stonesDataToSave copy],
        @"EndScore":[endScoresToSave copy]
    };
    
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:dataToSave options:NSJSONWritingSortedKeys error:nil];
    
    [self sendUploadRequestWithData:dataJSON];
}

- (void)sendUploadRequestWithData:(NSData *)dataJSON
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = [NSURL URLWithString:@"https://content.dropboxapi.com/2/files/upload"];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"{\"path\":\"/data.txt\",\"mode\":{\".tag\":\"overwrite\"},\"mute\":true}" forHTTPHeaderField:@"Dropbox-API-Arg"];
    AppData *appData = [self.coreDataManager loadAppData];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", appData.accessToken] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionUploadTask *task = [urlSession uploadTaskWithRequest:request fromData:dataJSON
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output taskDidFinishedWithStatus:[(NSHTTPURLResponse *)response statusCode] == CURNetworkManagerDropboxSuccessStatusCode];
                [urlSession finishTasksAndInvalidate];
            });
        }];
    [task resume];
}

- (void)loadFromDropbox
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = [NSURL URLWithString:@"https://content.dropboxapi.com/2/files/download"];
    request.HTTPMethod = @"POST";
    [request setValue:@"{\"path\":\"/data.txt\"}" forHTTPHeaderField:@"Dropbox-API-Arg"];
    AppData *appData = [self.coreDataManager loadAppData];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", appData.accessToken] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDownloadTask *task = [urlSession downloadTaskWithRequest:request
        completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if([(NSHTTPURLResponse *)response statusCode] == CURNetworkManagerDropboxSuccessStatusCode)
                {
                    [self saveDownloadDataToCoreData:location];
                }
                [self.output taskDidFinishedWithStatus:[(NSHTTPURLResponse *)response statusCode] == CURNetworkManagerDropboxSuccessStatusCode];
                [urlSession finishTasksAndInvalidate];
            });
        }];
    [task resume];
}

- (void)saveDownloadDataToCoreData:(NSURL *)location
{
    NSData *dataJSON = [NSData dataWithContentsOfURL:location];
    
    [self.coreDataManager clearCoreData];
    
    NSDictionary* readData = [NSJSONSerialization JSONObjectWithData:dataJSON options:NSJSONReadingAllowFragments error:nil];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    CURGameInfo *gameInfo = nil;
    for (NSDictionary *dict in readData[@"GameInfo"])
    {
        gameInfo = [CURGameInfo new];
        gameInfo.teamNameFirst = dict[@"teamNameFirst"];
        gameInfo.teamNameSecond = dict[@"teamNameSecond"];
        gameInfo.hashLink = dict[@"hashLink"];
        gameInfo.numberOfEnds = [dict[@"numberOfEnds"] intValue];
        gameInfo.firstTeamScore = [dict[@"firstTeamScore"] intValue];
        gameInfo.secondTeamScore = [dict[@"secondTeamScore"] intValue];
        gameInfo.isFirstTeamColorRed = [dict[@"isFirstTeamColorRed"] boolValue];
        gameInfo.date = [dateFormatter dateFromString:dict[@"date"]];
        
        [self.coreDataManager saveGameInfo:gameInfo];
    }
    
    CURStoneData *stoneData = nil;
    for (NSDictionary *dict in readData[@"StoneData"])
    {
        stoneData = [CURStoneData new];
        stoneData.endNumber = [dict[@"endNumber"] intValue];
        stoneData.stepNumber = [dict[@"stepNumber"] intValue];
        stoneData.isStoneColorRed = [dict[@"isStoneColorRed"] boolValue];
        stoneData.stonePositionX = [dict[@"stonePositionX"] floatValue];
        stoneData.stonePositionY = [dict[@"stonePositionY"] floatValue];
        stoneData.hashLink = dict[@"hashLink"];
        
        [self.coreDataManager saveStoneData:stoneData];
    }
    
    for (NSDictionary *dict in readData[@"EndScore"])
    {
        NSString * hashLink = dict[@"hashLink"];
        int endNumber = [dict[@"endNumber"] intValue];
        int firstTeamScore = [dict[@"firstTeamScore"] intValue];
        int secondTeamScore = [dict[@"secondTeamScore"] intValue];
        [self.coreDataManager saveFirstScore:firstTeamScore secondScore:secondTeamScore forEnd:endNumber hash:hashLink];
    }
}

@end
