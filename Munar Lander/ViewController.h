//
//  ViewController.h
//  Münar Lander
//

//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GameKit/GameKit.h>
#import "mySoundPlayer.h"
#import "Reachability.h"
#import "GameDataHelper.h"



@interface ViewController : UIViewController <GKGameCenterControllerDelegate>

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController;

@end
