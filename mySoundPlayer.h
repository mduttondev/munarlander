//
//  mySoundPlayer.h
//  Münar Lander
//
//  Created by Matthew Dutton on 5/1/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface mySoundPlayer : NSObject





@property NSUserDefaults* defaults;

@property AVAudioPlayer* backgroundMusic;

@property AVAudioPlayer* thrusterSound;

@property AVAudioPlayer* rcsSound;

@property AVAudioPlayer* deathSound;

@property AVAudioPlayer* eagle_Landed;

@property AVAudioPlayer* landingSound;





@property BOOL bgSoundOn;

@property BOOL soundFXOn;

@property NSURL* url;


+(id) sharedInstance;

-(void)doesPlayBGSound:(BOOL)soundIsOn;
-(void)effectNamed:(NSString*)name shouldBe:(BOOL)setting ;


@end
