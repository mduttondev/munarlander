//
//  LeaderBoardScene.m
//  Munar lander
//
//  Created by Matthew Dutton on 1/21/15.
//  Copyright (c) 2015 Matthew Dutton. All rights reserved.
//

#import "LeaderBoardScene.h"

@interface LeaderBoardScene()
{
    SKSpriteNode* scoresBacker;
    SKSpriteNode* scoreSort;
    SKSpriteNode* nameSort;
}
@end


@implementation LeaderBoardScene

-(instancetype)initWithSize:(CGSize)size {
 
    if ( self = [super initWithSize:size] ) {
        
        self.backgroundColor = [SKColor clearColor];
        
        gameHelper = [GameDataHelper getSharedInstance];
        
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"MAINMENU"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        
        SKLabelNode* leaderboardTitle = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        leaderboardTitle.text = @"Leaderboard-";
        leaderboardTitle.fontSize = 60;
        leaderboardTitle.position = CGPointMake(512,640);
        [self addChild:leaderboardTitle];
        
        
        // if there is a network connection and the user has been authenticated then show the game center leaderboard
        if ([Reachability isNetworkReachable] && gameHelper.gameCenterEnabled) {
            
            ViewController* vc = (ViewController*)[[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0]nextResponder];
            
            [gameHelper showLeaderBoardWithID:gameHelper.leaderboardID withViewController:vc];
            
            
        // if theres no connection or users not authenticated then show the Sign in to Game Center
        } else {
            
            SKSpriteNode* back = [SKSpriteNode spriteNodeWithImageNamed:@"BackButton.png"];
            [back setScale:.25f];
            back.position = CGPointMake( 128 , 512 );
            back.size = CGSizeMake(back.size.width + 20, back.size.height);
            back.name = @"backButton";
            [self addChild:back];
            
            scoresBacker = [SKSpriteNode spriteNodeWithColor:[UIColor darkGrayColor] size:CGSizeMake(550, 650)];
            scoresBacker.position = CGPointMake(512, 284);
            [self addChild:scoresBacker];

            leaderboardTitle.text = @"Sign in to Game Center";
            
 
        }
    
    };
    
    return self;
    
}



-(void)showSortButtons {
    
    scoreSort = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.095 green:0.451 blue:0.130 alpha:1.000] size:CGSizeMake(150, 100)];
    scoreSort.position = CGPointMake(890, self.frame.size.height/2);
    scoreSort.name = @"scoreSort";
    [self addChild:scoreSort];
    
    SKLabelNode* scoreSortLbl = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    scoreSortLbl.text = @"Sort by Score";
    scoreSortLbl.fontSize = 26;
    scoreSortLbl.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    scoreSortLbl.name = @"scoreSort";
    [scoreSort addChild:scoreSortLbl];
    

    nameSort = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.981 green:0.000 blue:0.032 alpha:1.000] size:CGSizeMake(150, 100)];
    nameSort.position = CGPointMake( 890, (self.frame.size.height / 4) + 50);
    nameSort.name = @"nameSort";
    [self addChild:nameSort];
    
    
    SKLabelNode* nameSortLbl = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    nameSortLbl.text = @"Sort by Name";
    nameSortLbl.name = @"nameSort";
    nameSortLbl.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    nameSortLbl.fontSize = 26;
    [nameSort addChild:nameSortLbl];
    
}






-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:location];
    
    if ( [node.name isEqualToString:@"backButton"] ) {
        
        SKView * skView = (SKView *)self.view;
        
        skView.showsFPS = NO;
        
        skView.showsNodeCount = NO;
        
        SKScene * scene = [MainMenuScene sceneWithSize:skView.bounds.size];
        
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:.5];
        
        [skView presentScene:scene transition:reveal];
        
    }
    
}

@end
