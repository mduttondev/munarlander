//
//  GameScreen.h
//  Münar Lander
//
//  Created by Matthew Dutton on 4/15/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "mySoundPlayer.h"
#import "LanderSprite.h"
#import "TerrainSprite.h"
#import "FuelBar.h"
#import "GameDataHelper.h"
#import "Constants.h"

@interface GameScreen : SKScene <SKPhysicsContactDelegate>
{
    
    // Main objects
    SKSpriteNode* backGround;
    SKSpriteNode* lander;
    SKSpriteNode* asteroid;
    
    // Control Surfaces
    SKSpriteNode* thrustButton;
    SKSpriteNode* rotateLeftButton;
    SKSpriteNode* rotateRightButton;
    
    // URL to fill sounds
    NSURL* url;
    
    
    // Determines thruster on/off
    BOOL thrusting;
    BOOL thrusterIsOperable;
    BOOL rotateLeft;
    BOOL rotateRight;
    
    // For Achievements
    BOOL untouched;
    BOOL died;
    
    // Fuel
    float fuelLevel;
    BOOL refuel;
    int fuelUsed;
    SKLabelNode* fuelUsedNumber;
    BOOL reportedScore;
    
    
    // determines if sitting on pad, so to be moved back
    BOOL onPad;
    BOOL isCloseToRest;
    BOOL onVictoryPad;
    
    // for taking lives
    int lives;

    // used to move the background/scrolling ( used in update method )
    NSTimeInterval lastTime;
    NSTimeInterval delta_Time;
    
    // used to keep a bug of 2 landers forming from occuring ( used in didBeginContact )
    NSTimeInterval lastTimerun;
    NSTimeInterval timeDiff;

    mySoundPlayer* soundEffects;
    LanderSprite* landerObject;
    TerrainSprite* BGObject;
    
    FuelBar* landerFuelBar;
    
    GameDataHelper* gamehelper;

}


@end
