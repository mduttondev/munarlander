//
//  OptionsScene.m
//  Münar Lander
//
//  Created by Matthew Dutton on 4/15/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import "OptionsScene.h"
#import "MainMenuScene.h"
#import "ViewController.h"
#import "mySoundPlayer.h"

@interface OptionsScene()

{
    
    UISwitch* toggleBackgroundMusic;
    UISwitch* toggleSoundEffects;
    
    SKSpriteNode* bgSound;
    SKSpriteNode* SFX;
    
    
    mySoundPlayer* SP_Singleton;
    

}

@end


@implementation OptionsScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil]; //Sends message to viewcontroller to show ad.

        SP_Singleton = [mySoundPlayer sharedInstance];
        
        if ( [SP_Singleton.defaults objectForKey:@"bgSound"] != nil) {
         
            SP_Singleton.bgSoundOn = [SP_Singleton.defaults boolForKey:@"bgSound"];
        
        } else {
            
            SP_Singleton.bgSoundOn = YES;
        }
        
        
        
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.8 blue:0.8 alpha:1.0];
        
        
        SKSpriteNode* backImage = [SKSpriteNode spriteNodeWithImageNamed:@"MAINMENU"];
        backImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:backImage];
        
        
        
        SKLabelNode* optionsHeader = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        
        optionsHeader.text = @"Options";
        
        optionsHeader.fontSize = 60;
        
        optionsHeader.position = CGPointMake(512,512*1.25);
        
        [self addChild:optionsHeader];
        
        
        
        SKSpriteNode* back = [SKSpriteNode spriteNodeWithImageNamed:@"BackButton.png"];
        
        [back setScale:.25f];
        
        back.position = CGPointMake( 128 , (512 * 1.25) + (55 / 4) );
        
        back.size = CGSizeMake(back.size.width + 20, back.size.height);
        
        back.name = @"backButton";
        
        [self addChild:back];
        
    
        
        if (SP_Singleton.bgSoundOn == YES) {
          
            bgSound = [SKSpriteNode spriteNodeWithImageNamed:@"GreenCircle.png"];
           
            bgSound.name = @"bgSoundGreen";
            
            [bgSound setScale:.5];
            
            bgSound.position = CGPointMake( self.size.width/1.5,self.size.height/2);
            
            [self addChild:bgSound];
            
    
        } else {
            
            
            bgSound = [SKSpriteNode spriteNodeWithImageNamed:@"RedCircle.png"];
            
            bgSound.name = @"bgSoundRed";
            
            [bgSound setScale:.5];
            
            bgSound.position = CGPointMake( self.size.width/1.5,self.size.height/2);
            
            [self addChild:bgSound];
            
        }
        
        

        
        if (SP_Singleton.soundFXOn == YES) {
            
            SFX = [SKSpriteNode spriteNodeWithImageNamed:@"SFXON.png"];
            
            SFX.name = @"SFXON";
            
            [SFX setScale:.5];
            
            SFX.position = CGPointMake( self.size.width/3,self.size.height/2);
            
            [self addChild:SFX];
            
            
        } else {
            
            
            SFX = [SKSpriteNode spriteNodeWithImageNamed:@"SFXOFF.png"];
            
            SFX.name = @"SFXOFF";
            
            [SFX setScale:.5];
            
            SFX.position = CGPointMake( self.size.width/3,self.size.height/2);
            
            [self addChild:SFX];
            
        }

    }
    
    return self;
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:location];
    
    
    if ([node.name isEqualToString:@"backButton"]) {
        
        SKView * skView = (SKView *)self.view;
        
        skView.showsFPS = NO;
        
        skView.showsNodeCount = NO;
        
        
        SKScene * scene = [MainMenuScene sceneWithSize:skView.bounds.size];
        
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        
        SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:.5];
        
        [skView presentScene:scene transition:reveal];
        
    }
    
    
    if ( [ node.name isEqualToString:@"bgSoundGreen"] ) {
        
        [bgSound setTexture:[SKTexture textureWithImageNamed:@"RedCircle.png" ]];
        
        bgSound.name = @"bgSoundRed";
        
        SP_Singleton.bgSoundOn = NO;
        
        [SP_Singleton doesPlayBGSound:NO];
        
        [SP_Singleton.defaults setBool:NO forKey:@"bgSound"];
        
        [SP_Singleton.defaults synchronize];
        
        
    } else if ( [ node.name isEqualToString:@"bgSoundRed" ] ) {
        
        [bgSound setTexture:[SKTexture textureWithImageNamed:@"GreenCircle.png" ]];
        
        bgSound.name = @"bgSoundGreen";
        
        SP_Singleton.bgSoundOn = YES;
        
        [SP_Singleton doesPlayBGSound:YES];
        
        [SP_Singleton.defaults setBool:YES forKey:@"bgSound"];
        
        [SP_Singleton.defaults synchronize];
    }
    
    
    
    if ( [ node.name isEqualToString:@"SFXON"] ) {
        
        [SFX setTexture:[SKTexture textureWithImageNamed:@"SFXOFF.png" ]];
        
        SFX.name = @"SFXOFF";
        
        SP_Singleton.soundFXOn = NO;
        
        
        [SP_Singleton.defaults setBool:NO forKey:@"soundFXOn"];
        
        [SP_Singleton.defaults synchronize];
        
        
    } else if ( [ node.name isEqualToString:@"SFXOFF" ] ) {
        
        [SFX setTexture:[SKTexture textureWithImageNamed:@"SFXON.png" ]];
        
        SFX.name = @"SFXON";
        
        SP_Singleton.soundFXOn = YES;
        
        
        [SP_Singleton.defaults setBool:YES forKey:@"soundFXOn"];
        
        [SP_Singleton.defaults synchronize];
    }












}
















@end
