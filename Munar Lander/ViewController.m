//
//  ViewController.m
//  Münar Lander
//
//  Created by Matthew Dutton on 4/15/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//
// Background music from freestockmusic.com
// Sound Effects from nasa.gov, wavcentral.com, free sound.org

#import "ViewController.h"
#import "MainMenuScene.h"
#import "OptionsScene.h"
#import <AVFoundation/AVFoundation.h>
#import "GADBannerView.h"
#import "GADRequest.h"
#import "Constants.h"


@interface ViewController() {

    mySoundPlayer* SP_Instance;
    
    GameDataHelper* gameHelper;
}

@end

 
@implementation ViewController

 - (void)viewDidLoad {
     
     [super viewDidLoad];
     
     SP_Instance = [mySoundPlayer sharedInstance];
     
     gameHelper = [GameDataHelper getSharedInstance];
     
     [gameHelper registerAsNetworkObserver];
     
     
 }
 
 -(void)viewWillLayoutSubviews{
 
     // Configure the view.
     SKView * skView = (SKView *)self.view;
     skView.showsFPS = NO;
     skView.showsNodeCount = NO;
     
     // Create and configure the scene.
     MainMenuScene* scene = [[MainMenuScene alloc]initWithSize:skView.bounds.size];
     scene.scaleMode = SKSceneScaleModeAspectFill;
     
     // Present the scene.
     [skView presentScene:scene];
     
     [gameHelper authenticateLocalPlayer:self];
 
 }


 
 - (UIStatusBarStyle)preferredStatusBarStyle
 {
     return UIStatusBarStyleLightContent;
 }



//**********************************************************************
//
//          GKGameCenterControllerDelegate  Delegate Method
//
//**********************************************************************

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    
    // Configure a view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    
    MainMenuScene* mainMenu = [[MainMenuScene alloc]initWithSize:skView.bounds.size];
    
    SKTransition* reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:0.5];
    
    [skView presentScene:mainMenu transition:reveal];
}
 
 
 @end

