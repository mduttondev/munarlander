//
//  GameDataHelper.h
//  Munar lander
//
//  Created by Matthew Dutton on 1/21/15.
//  Copyright (c) 2015 Matthew Dutton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "Reachability.h"
#import "ViewController.h"
#import "Constants.h"



@interface GameDataHelper : NSObject <UIAlertViewDelegate>
    
    
@property NSString* leaderboardID;

@property BOOL gameCenterEnabled;

@property BOOL gameCenterUserAuthenticated;

@property NSMutableArray* rootArray;

@property GKLocalPlayer* localPlayer;

@property NSMutableDictionary* achievementDictionary;

@property NSMutableDictionary *achievementDescriptions;



+(GameDataHelper *)getSharedInstance;

-(void)showLeaderBoardWithID:(NSString*)leaderboardIdentifier withViewController:(UIViewController*)viewController;

-(void)authenticateLocalPlayer:(UIViewController*)presentFromVC;

-(void)reportScore:(int)scoreToReport;

-(void)registerAsNetworkObserver;

- (void)reachabilityDidChange:(NSNotification *)notification;


-(GKAchievement*)getAchievementWithIdentifier:(NSString*)identifier;

-(void)reportAchievementsCompleteForIdentifiers:(NSArray*)identifier;



@end
