//
//  GameOverScene.m
//  Münar Lander
//
//  Created by Matthew Dutton on 4/15/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import "GameOverScene.h"
#import "MainMenuScene.h"
#import "GameScreen.h"


@implementation GameOverScene
@synthesize gameHelper;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        gameHelper = [GameDataHelper getSharedInstance];
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor clearColor];

        
        SKSpriteNode* backImage = [SKSpriteNode spriteNodeWithImageNamed:@"GAMEOVER"];
        backImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:backImage];

        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        myLabel.text = @"Game Over";
        myLabel.fontSize = 60;
        myLabel.position = CGPointMake(512,512*1.25);
        [self addChild:myLabel];
        
        
        // creation of the main menu button
        SKSpriteNode* toMain = [SKSpriteNode spriteNodeWithImageNamed:@"LARGEBUTTON"];
        toMain.size = CGSizeMake( 175 * 2 , 110 );
        toMain.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + toMain.size.height / 1.5 );
        toMain.name = @"toMainMenu";
        [self addChild:toMain];
        
        
        SKLabelNode* toMainLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        toMainLabel.text = @"Main Menu";
        toMainLabel.name = @"toMainMenu";
        toMainLabel.fontColor = [SKColor blackColor];
        toMainLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [toMain addChild:toMainLabel];
        
        
        
        // creation of the restart Button
        SKSpriteNode* restart = [SKSpriteNode spriteNodeWithImageNamed:@"LARGEBUTTON"];
        restart.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - toMain.size.height / 1.5 );
        restart.size = CGSizeMake( 175 * 2 , 110 );
        restart.name = @"restart";
        [self addChild:restart];
        
        
        SKLabelNode* restartLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        restartLabel.text = @"Try Again";
        restartLabel.name = @"restart";
        restartLabel.fontColor = [SKColor blackColor];
        restartLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [restart addChild:restartLabel];
        
        [self checkGameOverAchievement];
     
        
    }
    return self;
}


-(void)checkGameOverAchievement {
    
    GKAchievement* gameOverAchievement = [gameHelper getAchievementWithIdentifier:kGAMEOVER_FIRST_TIME];
    // if the achievement wasnt nil
    if (gameOverAchievement) {
        
        // if the ach returned says it hasnt been completed, submit it as complete
        if (gameOverAchievement.percentComplete == 0) {
        
            [gameHelper reportAchievementsCompleteForIdentifiers:@[gameOverAchievement.identifier]];
        
        }
        
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"toMainMenu"]) {
        
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

        
    }
    
}






@end
