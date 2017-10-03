//
//  VictoryScene.m
//  Münar Lander
//
//  Created by Matthew Dutton on 5/1/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import "VictoryScene.h"
#import "MainMenuScene.h"
#import "GameScreen.h"

@interface VictoryScene(){
    
    int fuelUsed;

}

@end


@implementation VictoryScene
@synthesize gameHelper;

-(id)initWithSize:(CGSize)size andScore:(int)score wasUntouched:(BOOL)untouched didntDie:(BOOL)died {
    
    if (self = [super initWithSize:size]) {
        
        fuelUsed = score;

        gameHelper = [GameDataHelper getSharedInstance];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil]; //Sends message to viewcontroller to show ad.
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor clearColor];
        
        SKSpriteNode* backImage = [SKSpriteNode spriteNodeWithImageNamed:@"VICTORY"];
        backImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:backImage];
        
        SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        titleLabel.text = @"VICTORY IS YOURS";
        titleLabel.fontSize = 125;
        titleLabel.position = CGPointMake(512,512*1.25);
        [self addChild:titleLabel];
        
        
        SKLabelNode* scoreLabel = [[SKLabelNode alloc]initWithFontNamed:@"Marker Felt"];
        scoreLabel.text = [NSString stringWithFormat:@"YOU USED %i LITERS OF FUEL", score];
        scoreLabel.fontSize = 64;
        scoreLabel.fontColor = [UIColor orangeColor];
        scoreLabel.position = CGPointMake(512, 550);
        [self addChild:scoreLabel];
        
        // creation of the main menu button
        SKSpriteNode* toMainNode = [SKSpriteNode spriteNodeWithImageNamed:@"LARGEBUTTON"];
        toMainNode.size = CGSizeMake( 175 * 2 , 110 );
        toMainNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + toMainNode.size.height / 1.5 );
        toMainNode.name = @"toMainMenu";
        [self addChild:toMainNode];
        
        
        SKLabelNode* toMainNodeLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        toMainNodeLabel.text = @"Main Menu";
        toMainNodeLabel.name = @"toMainMenu";
        toMainNodeLabel.fontColor = [SKColor blackColor];
        toMainNodeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [toMainNode addChild:toMainNodeLabel];
        
        // creation of the restart Button
        SKSpriteNode* restartGame = [SKSpriteNode spriteNodeWithImageNamed:@"LARGEBUTTON"];
        restartGame.size = CGSizeMake( 175 * 2 , 110 );
        restartGame.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - toMainNode.size.height / 1.5 );
        restartGame.name = @"restart";
        [self addChild:restartGame];

        SKLabelNode* restartGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        restartGameLabel.text = @"Play Again";
        restartGameLabel.fontColor = [SKColor blackColor];
        restartGameLabel.name = @"restart";
        restartGameLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [restartGame addChild:restartGameLabel];
        
        SKSpriteNode* shareBacker = [SKSpriteNode spriteNodeWithImageNamed:@"LARGEBUTTON"];
        shareBacker.size = CGSizeMake(150, 100);
        shareBacker.position = CGPointMake(135, self.frame.size.height/2);
        shareBacker.name = @"share";
        [self addChild:shareBacker];
        
        SKLabelNode* shareBackerLbl = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        shareBackerLbl.text = @"Share Score";
        shareBackerLbl.fontSize = 26;
        shareBackerLbl.fontColor = [UIColor blackColor];
        shareBackerLbl.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        shareBackerLbl.name = @"share";
        [shareBacker addChild:shareBackerLbl];
            
        [self checkForAchievements:fuelUsed wasUntouched:untouched died:died];
            
        

    }
    
    return self;
    
}


#pragma mark -Check Achievements
//**********************************************************************
//
//                          Achievement Check
//
//**********************************************************************
-(void)checkForAchievements:(int)fuel wasUntouched:(BOOL)untouched died:(BOOL)died{
    
    NSMutableArray* submitAchievements = [[NSMutableArray alloc]init];

    //checking to see if this if the first time that you have completed the level
    if ([gameHelper getAchievementWithIdentifier:kCOMPLETE_FIRST_TIME].percentComplete == 0) {
        
        GKAchievement* firstComplete = [gameHelper getAchievementWithIdentifier:kCOMPLETE_FIRST_TIME];
        [submitAchievements addObject: firstComplete.identifier];
    }
    
    if (untouched) {
        
        if ([gameHelper getAchievementWithIdentifier:kCOMPLETE_WITHOUT_HIT].percentComplete == 0) {
           
            [submitAchievements addObject:[gameHelper getAchievementWithIdentifier:kCOMPLETE_WITHOUT_HIT].identifier];
        }
    }
    
    
    
    if ( !died ) {
        
        if ([gameHelper getAchievementWithIdentifier:kCOMPLETE_WITHOUT_DYING].percentComplete == 0) {
            
            [submitAchievements addObject:[gameHelper getAchievementWithIdentifier:kCOMPLETE_WITHOUT_DYING].identifier];
        }
    }
    
    
    
    if (fuel >= 900) {
        
        if ([gameHelper getAchievementWithIdentifier:kCOMPLETE_OVER_900].percentComplete == 0) {
            
            [submitAchievements addObject:[gameHelper getAchievementWithIdentifier:kCOMPLETE_OVER_900].identifier];
            
        }
    }
    
    
    // if the fuel used is < 500 submit the ACH and check if less than 400
    if (fuel < 500) {
        
        if ([gameHelper getAchievementWithIdentifier:kCOMPLETE_USING_LESS_500].percentComplete == 0) {
            
            [submitAchievements addObject:[gameHelper getAchievementWithIdentifier:kCOMPLETE_USING_LESS_500].identifier];
        }
        
        // if the fuel used is < 400 submit the ACH and check if less than 300
        if (fuel < 400) {
            
            if ([gameHelper getAchievementWithIdentifier:kCOMPLETE_USING_LESS_400].percentComplete == 0) {
                
                [submitAchievements addObject:[gameHelper getAchievementWithIdentifier:kCOMPLETE_USING_LESS_400].identifier];
            }
            
            // if the fuel used is < 300 submit the ACH
            if (fuel < 300) {
                
                if ([gameHelper getAchievementWithIdentifier:kCOMPLETE_USING_LESS_300].percentComplete == 0) {
                    
                    [submitAchievements addObject:[gameHelper getAchievementWithIdentifier:kCOMPLETE_USING_LESS_300].identifier];
                }
            }
        }
    }
    
    
    
    
    if ([submitAchievements count] > 0) {
        
        [gameHelper reportAchievementsCompleteForIdentifiers:submitAchievements];
        
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"toMainMenu"]   ) {
        
        SKView * skView = (SKView *)self.view;
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        
        SKScene * scene = [MainMenuScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.5];
        [skView presentScene:scene transition:reveal];
        
        
    } else if ([node.name isEqualToString:@"restart"]) {
        
        SKView * skView = (SKView *)self.view;
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        
        SKScene * scene = [GameScreen sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.5];
        [skView presentScene:scene transition:reveal];
        
    } else if ([node.name isEqualToString:@"share"]) {
        
        
        [self sharePressed];
        
    }
    
}


-(void)sharePressed {
    
    ViewController* rootVC = (ViewController*)[[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0]nextResponder];
    
    NSString* messageText = [NSString stringWithFormat:@"I just landed my ship and only used %i liters of fuel!!\n\n\n\n-Munar Lander for Ipad", fuelUsed];
    
    NSArray* whatToSend = @[messageText];
    
    UIActivityViewController* activityVC = [[UIActivityViewController alloc]initWithActivityItems:whatToSend applicationActivities:nil];
    
    [activityVC setValue:@"Awesome iPad Game!!!" forKey:@"subject"];
    
    activityVC.popoverPresentationController.sourceView = rootVC.view;
    
    [rootVC presentViewController:activityVC animated:YES completion:nil];
    
}



@end

