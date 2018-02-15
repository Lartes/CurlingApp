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

- (void)saveToDropbox
{
    NSArray *gamesInfo = [self.coreDataManager loadAllGamesInfo];
    NSMutableArray *gamesInfoToSave = [NSMutableArray new];
    NSMutableDictionary *dict = nil;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    for (GameInfo *gameInfo in gamesInfo)
    {
        dict = [NSMutableDictionary new];
        [dict setObject:gameInfo.teamNameFirst forKey:@"teamNameFirst"];
        [dict setObject:gameInfo.teamNameSecond forKey:@"teamNameSecond"];
        [dict setObject:gameInfo.hashLink forKey:@"hashLink"];
        [dict setObject:[NSString stringWithFormat:@"%d", gameInfo.numberOfEnds] forKey:@"numberOfEnds"];
        [dict setObject:[NSString stringWithFormat:@"%d", gameInfo.firstTeamScore] forKey:@"firstTeamScore"];
        [dict setObject:[NSString stringWithFormat:@"%d", gameInfo.secondTeamScore] forKey:@"secondTeamScore"];
        [dict setObject:[NSString stringWithFormat:@"%d", gameInfo.isFirstTeamColorRed] forKey:@"isFirstTeamColorRed"];
        [dict setObject:[dateFormatter stringFromDate:gameInfo.date] forKey:@"date"];
        [gamesInfoToSave addObject:[dict copy]];
    }
    
    NSArray *stonesData = [self.coreDataManager loadAllStoneData];
    NSMutableArray *stonesDataToSave = [NSMutableArray new];
    for (StoneData *stoneData in stonesData)
    {
        dict = [NSMutableDictionary new];
        [dict setObject:stoneData.hashLink forKey:@"hashLink"];
        [dict setObject:[NSString stringWithFormat:@"%f", stoneData.stonePositionX] forKey:@"stonePositionX"];
        [dict setObject:[NSString stringWithFormat:@"%f", stoneData.stonePositionY] forKey:@"stonePositionY"];
        [dict setObject:[NSString stringWithFormat:@"%d", stoneData.stepNumber] forKey:@"stepNumber"];
        [dict setObject:[NSString stringWithFormat:@"%d", stoneData.isStoneColorRed] forKey:@"isStoneColorRed"];
        [dict setObject:[NSString stringWithFormat:@"%d", stoneData.endNumber] forKey:@"endNumber"];
        [stonesDataToSave addObject:[dict copy]];
    }
    
    NSArray *endScores = [self.coreDataManager loadAllEndScore];
    NSMutableArray *endScoresToSave = [NSMutableArray new];
    for (EndScore *endScore in endScores)
    {
        dict = [NSMutableDictionary new];
        [dict setObject:endScore.hashLink forKey:@"hashLink"];
        [dict setObject:[NSString stringWithFormat:@"%d", endScore.endNumber] forKey:@"endNumber"];
        [dict setObject:[NSString stringWithFormat:@"%d", endScore.firstTeamScore] forKey:@"firstTeamScore"];
        [dict setObject:[NSString stringWithFormat:@"%d", endScore.secondTeamScore] forKey:@"secondTeamScore"];
        [endScoresToSave addObject:[dict copy]];
    }
    
    NSDictionary *dataToSave = @{
        @"GameInfo":[gamesInfoToSave copy],
        @"StoneData":[stonesDataToSave copy],
        @"EndScore":[endScoresToSave copy]
    };
    
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:dataToSave options:NSJSONWritingSortedKeys error:nil];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://content.dropboxapi.com/2/files/upload"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"{\"path\":\"/data.txt\",\"mode\":{\".tag\":\"overwrite\"},\"mute\":true}" forHTTPHeaderField:@"Dropbox-API-Arg"];
    AppData *appData = [self.coreDataManager loadAppData];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", appData.accessToken] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionUploadTask *task = [urlSession uploadTaskWithRequest:request fromData:dataJSON completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.output taskDidFinishedWithStatus:[(NSHTTPURLResponse *)response statusCode] == DROPBOXSUCCESSSTATUSCODE];
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
    [request setURL:[NSURL URLWithString:@"https://content.dropboxapi.com/2/files/download"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"{\"path\":\"/data.txt\"}" forHTTPHeaderField:@"Dropbox-API-Arg"];
    AppData *appData = [self.coreDataManager loadAppData];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", appData.accessToken] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDownloadTask *task = [urlSession downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error){
        if([(NSHTTPURLResponse *)response statusCode] == DROPBOXSUCCESSSTATUSCODE)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveDownloadDataToCoreData:location];
                [self.output taskDidFinishedWithStatus:[(NSHTTPURLResponse *)response statusCode] == DROPBOXSUCCESSSTATUSCODE];
                [urlSession finishTasksAndInvalidate];
            });
        }
    }];
    [task resume];
}

- (void)saveDownloadDataToCoreData:(NSURL *)location
{
    NSData *dataJSON = [NSData dataWithContentsOfURL:location];
    
    [self.coreDataManager clearCoreData];
    
    NSDictionary* readData = [NSJSONSerialization JSONObjectWithData:dataJSON options:NSJSONReadingAllowFragments error:nil];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    CURGameInfo *gameInfo = nil;
    for (NSDictionary *dict in [readData objectForKey:@"GameInfo"])
    {
        gameInfo = [CURGameInfo new];
        gameInfo.teamNameFirst = [dict objectForKey:@"teamNameFirst"];
        gameInfo.teamNameSecond = [dict objectForKey:@"teamNameSecond"];
        gameInfo.hashLink = [dict objectForKey:@"hashLink"];
        gameInfo.numberOfEnds = [[dict objectForKey:@"numberOfEnds"] intValue];
        gameInfo.firstTeamScore = [[dict objectForKey:@"firstTeamScore"] intValue];
        gameInfo.secondTeamScore = [[dict objectForKey:@"secondTeamScore"] intValue];
        gameInfo.isFirstTeamColorRed = [[dict objectForKey:@"isFirstTeamColorRed"] boolValue];
        gameInfo.date = [dateFormatter dateFromString:[dict objectForKey:@"date"]];
        
        [self.coreDataManager saveGameInfo:gameInfo];
    }
    
    CURStoneData *stoneData = nil;
    for (NSDictionary *dict in [readData objectForKey:@"StoneData"])
    {
        stoneData = [CURStoneData new];
        stoneData.endNumber = [[dict objectForKey:@"endNumber"] intValue];
        stoneData.stepNumber = [[dict objectForKey:@"stepNumber"] intValue];
        stoneData.isStoneColorRed = [[dict objectForKey:@"isStoneColorRed"] boolValue];
        stoneData.stonePositionX = [[dict objectForKey:@"stonePositionX"] floatValue];
        stoneData.stonePositionY = [[dict objectForKey:@"stonePositionY"] floatValue];
        stoneData.hashLink = [dict objectForKey:@"hashLink"];
        
        [self.coreDataManager saveStoneData:stoneData];
    }
    
    for (NSDictionary *dict in [readData objectForKey:@"EndScore"])
    {
        NSString * hashLink = [dict objectForKey:@"hashLink"];
        int endNumber = [[dict objectForKey:@"endNumber"] intValue];
        int firstTeamScore = [[dict objectForKey:@"firstTeamScore"] intValue];
        int secondTeamScore = [[dict objectForKey:@"secondTeamScore"] intValue];
        [self.coreDataManager saveFirstScore:firstTeamScore andSecondScore:secondTeamScore forEnd:endNumber andHash:hashLink];
    }
}

@end
