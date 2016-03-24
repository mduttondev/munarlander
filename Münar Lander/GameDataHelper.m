//
//  GameDataHelper.m
//  Munar lander
//
//  Created by Matthew Dutton on 1/21/15.
//  Copyright (c) 2015 Matthew Dutton. All rights reserved.
//

#import "GameDataHelper.h"


@implementation GameDataHelper

@synthesize gameCenterEnabled;
@synthesize leaderboardID;
@synthesize gameCenterUserAuthenticated;
@synthesize rootArray;
@synthesize localPlayer;
@synthesize achievementDictionary;
@synthesize achievementDescriptions;

static GameDataHelper* instance = nil;

+(GameDataHelper *)getSharedInstance {
    
    @synchronized(self) {
        
        if( instance == nil) {
            
            instance= [GameDataHelper new];
            
        }
        
    }
    
    return instance;
}

-(void)registerAsNetworkObserver {
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reachabilityDidChange:)
     name:kReachabilityChangedNotification
     object:nil];
}

-(void)unregisterAsNetworkObserver {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark -Authenticate Player
//**********************************************************************
//
//                           Authenticate Player
//
//**********************************************************************

-(void)authenticateLocalPlayer:(UIViewController*)presentFromVC {
    
    __weak typeof(self) weakSelf = self;
    
    if ([Reachability isNetworkReachable]) {
        
        localPlayer = [GKLocalPlayer localPlayer];
        
        localPlayer.authenticateHandler = ^(UIViewController* viewController, NSError *error){
            
            if (error != nil) {
                
                NSLog(@"Auth handler error: %@", [error localizedDescription]);
                
            } else if (viewController != nil) {
                
                [presentFromVC presentViewController:viewController animated:YES completion:nil];
                
            } else {
                
                if (weakSelf.localPlayer.authenticated ) {
                    
                    [weakSelf.localPlayer loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString* leaderboardIdentifier, NSError *error) {
                        
                        if (error != nil) {
                            
                            NSLog(@"Error reported: %@", [error localizedDescription]);
                            
                            weakSelf.gameCenterEnabled = NO;
                            
                            
                        } else {
                            
                            NSLog(@"Leaderboard ID: %@", leaderboardIdentifier);
                            
                            weakSelf.leaderboardID = leaderboardIdentifier;
                            
                            weakSelf.gameCenterEnabled = YES;
                            
                            weakSelf.achievementDictionary = [[NSMutableDictionary alloc]init];
                            
                            [weakSelf loadAchievementProgress];
                            
                        }
                        
                    }];
                    
                } else {
                    
                    NSLog(@"USER NOT AUTHENTICATED");
                    
                    weakSelf.gameCenterEnabled = NO;
                    
                }
            }
        };
        
    }
    
}

#pragma mark -Show LeaderBoard
//**********************************************************************
//
//                            Show Online LeaderBoard
//
//**********************************************************************

-(void)showLeaderBoardWithID:(NSString*)leaderboardIdentifier withViewController:(UIViewController*)viewController {
    
    //programmatically grabbing the root view controller from the stack.
    ViewController* rootVC = (ViewController*)[[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0]nextResponder];
    
    //getting the game center view controller
    GKGameCenterViewController* gcVC = [[GKGameCenterViewController alloc] init];
    
    if (gcVC != nil) {
        
        gcVC.gameCenterDelegate = rootVC;
        
        gcVC.leaderboardIdentifier = leaderboardID;
        
        [viewController presentViewController: gcVC animated: YES completion:nil];
        
    }
}


#pragma mark -Report Scores
//**********************************************************************
//
//                Report new Score to Online Leaderboard
//
//**********************************************************************

-(void)reportScore:(int)scoreToReport {
    
    GKScore* score = [[GKScore alloc]initWithLeaderboardIdentifier:leaderboardID];
    score.value = scoreToReport;
    
    NSArray* newScore = @[score];
    
    [GKScore reportScores:newScore withCompletionHandler:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
}


#pragma mark -Achievement Methods
//**********************************************************************
//
//                    Achievements Methods
//
//**********************************************************************

-(void)loadAchievementProgress {
    
    [achievementDictionary removeAllObjects];
    
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        
        if (error == nil) {
            
            for (GKAchievement* ach in achievements) {

                [achievementDictionary setObject:ach forKey:ach.identifier];
            }
            
            NSLog(@"Achievements (re)loaded- count: %i", (int)[achievements count]);
            
        } else {
            
            NSLog(@"Load Achievements error: %@", [error localizedDescription]);
        }
    }];
    
    achievementDescriptions = [[NSMutableDictionary alloc] init];
    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray *descriptions, NSError *error) {
        if (error != nil) {
            NSLog(@"Error getting achievement descriptions: %@", error);
        }
        for (GKAchievementDescription* achievementDescription in descriptions) {
            [achievementDescriptions setObject:achievementDescription forKey:achievementDescription.identifier];
        }
    }];
    
}



-(GKAchievement*)getAchievementWithIdentifier:(NSString*)identifier {
    
    GKAchievement* achievement = [achievementDictionary objectForKey:identifier];
    
    if (achievement == nil) {
        
        achievement = [[GKAchievement alloc]initWithIdentifier:identifier];
        
        [achievementDictionary setObject:achievement forKey:achievement.identifier];
        
    }
    
    return achievement;
    
}


// since all achievements are esentially all or nothing, I dont need a percent complete parameter. If if it were needing to track
// progress hate youI would need to implement a percent complete intake.
-(void)reportAchievementsCompleteForIdentifiers:(NSArray*)identifier {
    
    NSMutableArray* achievementReport = [[NSMutableArray alloc]init];
    
    NSMutableString* successMessage = [[NSMutableString alloc]initWithString:@""];
    
    for (NSString* ident in identifier) {
        
        GKAchievement* achievement = [self getAchievementWithIdentifier:ident];
        
        if (achievement) {
            
            achievement.percentComplete = COMPLETE;
            
            [achievementReport addObject:achievement];
            
            GKAchievementDescription* achDescription = [achievementDescriptions objectForKey:achievement.identifier];
            
            [successMessage appendFormat:@"\n%@", achDescription.title];
            
        }
        
    }
    
    if ( achievementReport != nil && [achievementReport count] > 0 && localPlayer.authenticated) {
        
        [GKAchievement reportAchievements:achievementReport withCompletionHandler:^(NSError *error) {
            
            if (error != nil) {
                
                NSLog(@"error submitting achievement: %@", [error localizedDescription]);
                
            } else {
                
                [[[UIAlertView alloc]initWithTitle:@"Achievement(s) Unlocked:"
                                           message:[NSString stringWithFormat:@"%@", successMessage]
                                          delegate:self cancelButtonTitle:@"Sweet!!"
                                 otherButtonTitles: nil] show];
                
                
                //delay retrieving the ACH by 4 seconds to allow the server to record them. If you dont do this you can earn each twice.
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self loadAchievementProgress];
                
                });
                
            }
            
        }];
        
    }
    
    
}


//**********************************************************************
//
//                   AlertView Methods
//
//**********************************************************************
#pragma mark -Alertview Methods
- (void) alertView: (UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UITextField *nameForScoring = [alertView textFieldAtIndex:0];
    
    NSString* temp = [nameForScoring text];
    
    if (temp.length > 8) {
        temp = [temp substringToIndex:8];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:temp forKey:kGAMERTAG];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}




- (void)reachabilityDidChange:(NSNotification *)notification {
    
    //programmatically grabbing the root view controller from the stack.
    ViewController* rootVC = (ViewController*)[[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0]nextResponder];
    
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable]) {
        
        if (gameCenterEnabled == NO) {
            
            [self authenticateLocalPlayer:rootVC];
        }
        
        
    } else {
        
        if (gameCenterEnabled == YES) {
            
            gameCenterEnabled = NO;
            
        }
        
        [self authenticateLocalPlayer:rootVC];
        
    }
}













@end
