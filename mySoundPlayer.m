//
//  mySoundPlayer.m
//  Münar Lander
//
//  Created by Matthew Dutton on 5/1/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//
// Background music from freestockmusic.com
// Sound Effects from nasa.gov, wavcentral.com, free sound.org



#import "mySoundPlayer.h"

@implementation mySoundPlayer

@synthesize bgSoundOn, backgroundMusic, defaults, url, thrusterSound, rcsSound, deathSound, eagle_Landed, landingSound, soundFXOn;




+(id) sharedInstance {
    
    static mySoundPlayer* sharedManager = nil;
    
    static dispatch_once_t runOnceQueue;
    
    dispatch_once(&runOnceQueue, ^{
        sharedManager = [[self alloc]init];
    });
    
    return sharedManager;
}



-(id)init {
    
    if (self = [super init]) {
        
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        
        
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fantasy-forest" ofType:@"mp3"]];
        
        backgroundMusic = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        [backgroundMusic setVolume:.4f];
        
        [backgroundMusic setNumberOfLoops: (-1) ];
        
        
        
        // alloc and init the thurster sound;
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Main_Thruster" ofType:@"wav"]];
        
        thrusterSound = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        [thrusterSound setNumberOfLoops: -1 ];
        
        
        
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Side_Thruster" ofType:@"wav"]];
        
        rcsSound = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        [rcsSound setNumberOfLoops: -1 ];
        
        
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Death_Explosion" ofType:@"wav"]];
        
        deathSound = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        [deathSound setNumberOfLoops: 0 ];
        
        
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Eagle_Landed" ofType:@"mp3"]];
        
        eagle_Landed = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        [eagle_Landed setNumberOfLoops: 0 ];
        
        
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Landing_Effect" ofType:@"wav"]];
        
        landingSound = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        [landingSound setVolume:.8f];
        
        [landingSound setNumberOfLoops: (0) ];
        
        
        
        // setting up the background music to play or not
        if ([defaults objectForKey:@"bgSound"] != nil) {
            
            // if there is a setting in the defaults use that. if not "default" to yes in the else
            bgSoundOn = [defaults boolForKey:@"bgSound"];
            
        } else {
            
            bgSoundOn = YES;
        }

        
        // if the music is set to on then start the music, if not, dont.
        if (bgSoundOn == YES) {
            
            [self doesPlayBGSound:YES];
            
        } else {
            
            [self doesPlayBGSound:NO];
            
        }
        
       
        
        
        // setting up the background music to play or not
        if ([defaults objectForKey:@"soundFXOn"] != nil) {
            
            // if there is a setting in the defaults use that. if not "default" to yes in the else
            soundFXOn = [defaults boolForKey:@"soundFXOn"];
           
            
        } else {
            
            soundFXOn = YES;
        }
        
        
        
        
        
        
    }
    return self;
    
}




-(void)doesPlayBGSound:(BOOL)soundIsOn {
    
    
    if (soundIsOn == true) {
        [backgroundMusic play];
    
        
    }
    if (soundIsOn == NO) {
        [backgroundMusic stop];
        
    }
    
}




-(void)effectNamed:(NSString*)name shouldBe:(BOOL)setting {
    
    if (soundFXOn == YES) {
        

        if ( [name isEqualToString:@"rcs"]) {
            if (setting == YES) {
                [rcsSound play];
            }
            if (setting == NO) {
                [rcsSound stop];
            }
        }
        
        
        if ( [name isEqualToString:@"main"]) {
            if (setting == YES) {
                [thrusterSound play];
            }
            if (setting == NO) {
                [thrusterSound stop];
            }
        }
        
        
        if ( [name isEqualToString:@"landing"]) {
            if (setting == YES) {
                [landingSound play];
            }
            
        }
        
        
        if ( [name isEqualToString:@"death"]) {
            if (setting == YES) {
                [deathSound play];
            }
            
        }
        
        
        if ( [name isEqualToString:@"victory"]) {
            if (setting == YES) {
                [eagle_Landed play];
            }
        }
    
    
    
    } else {
        
        NSLog(@"sounds are off");
    
    }
    
    
    
}












@end
