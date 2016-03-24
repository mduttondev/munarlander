//
//  MainMenuScene.h
//  Münar Lander
//
//  Created by Matthew Dutton on 4/15/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"
#import "LeaderBoardScene.h"
#import "GameDataHelper.h"

@interface MainMenuScene : SKScene

{
    
    GameDataHelper* gameHelper;
    
}


@property CGSize viewSize;


@end
