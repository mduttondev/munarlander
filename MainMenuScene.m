//
//  MainMenuScene.m
//  Münar Lander
//
//  Created by Matthew Dutton on 4/15/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import "ViewController.h"
#import "MainMenuScene.h"
#import "GameScreen.h"
#import "OptionsScene.h"



@implementation MainMenuScene
@synthesize viewSize;

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        viewSize = size;
        
        gameHelper = [GameDataHelper getSharedInstance];
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor clearColor];
        
        SKSpriteNode* backImage = [SKSpriteNode spriteNodeWithImageNamed:@"MAINMENU.png"];
        backImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:backImage];
        
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        myLabel.text = @"Münar Lander";
        myLabel.fontSize = 60;
        myLabel.position = CGPointMake(512,512*1.2);
        [self addChild:myLabel];
        
        
        SKSpriteNode* playButton = [SKSpriteNode spriteNodeWithImageNamed:@"LARGEBUTTON"];
        playButton.size = CGSizeMake( 175 * 2 , 110 );
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + playButton.size.height / 1.5 );
        playButton.name = @"playButton";
        [self addChild:playButton];
        
        SKLabelNode* playLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        playLabel.text = @"Play Game";
        playLabel.fontColor = [SKColor blackColor];
        playLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        playLabel.name = @"playButton";
        [playButton addChild:playLabel];

        
        SKSpriteNode* optionsButton = [SKSpriteNode spriteNodeWithImageNamed:@"LARGEBUTTON"];
        optionsButton.size = CGSizeMake( 175 * 2 , 110 );
        optionsButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - playButton.size.height / 1.5 );
        optionsButton.name = @"optionsButton";
        [self addChild:optionsButton];
        
        SKLabelNode* optionsLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        optionsLabel.fontColor = [SKColor blackColor];
        optionsLabel.text = @"Options";
        optionsLabel.name = @"optionsButton";
        optionsLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [optionsButton addChild:optionsLabel];
        
        
        SKSpriteNode* leaderBoardButton = [SKSpriteNode spriteNodeWithImageNamed:@"LARGEBUTTON"];
        leaderBoardButton.size = CGSizeMake( 175 * 2 , 110 );
        leaderBoardButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - playButton.size.height * 2 );
        leaderBoardButton.name = @"leaderBoardButton";
        [self addChild:leaderBoardButton];
        
        SKLabelNode* leaderBoardLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        leaderBoardLabel.fontColor = [SKColor blackColor];
        leaderBoardLabel.text = @"Leaderboard &";
        leaderBoardLabel.name = @"leaderBoardButton";
        [leaderBoardButton addChild:leaderBoardLabel];
        
        SKLabelNode* achievementsLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        achievementsLabel.fontColor = [SKColor blackColor];
        achievementsLabel.position = CGPointMake(leaderBoardLabel.position.x, leaderBoardLabel.position.y - 30);
        achievementsLabel.text = @"Achievements";
        achievementsLabel.name = @"leaderBoardButton";
        [leaderBoardButton addChild:achievementsLabel];
        
    }
    
    return self;
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    if ([node.name isEqualToString:@"playButton"]) {
        
        GameScreen * scene = [GameScreen sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:.5];
        [skView presentScene:scene transition:reveal];
        
        
    } else if ([node.name isEqualToString:@"optionsButton"]){
        
        SKScene * scene = [OptionsScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:.5];
        [skView presentScene:scene transition:reveal];
        
    
    } else if ([node.name isEqualToString:@"leaderBoardButton"]){
        
        LeaderBoardScene* leaderboard = [[LeaderBoardScene alloc]initWithSize:viewSize];
        
        SKTransition* reveal = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:0.5];
        
        [skView presentScene:leaderboard transition:reveal];
        
        
    }
    
    
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
