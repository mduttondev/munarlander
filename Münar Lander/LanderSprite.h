//
//  LanderSprite.h
//  Münar Lander
//
//  Created by Matthew Dutton on 5/2/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Constants.h"

@interface LanderSprite : SKSpriteNode

    
{
    SKSpriteNode* ship;
}



@property    SKEmitterNode* landerEngine;
@property    SKEmitterNode* rcsLeft;
@property    SKEmitterNode* rcsRight;



-(id)init;

-(SKSpriteNode*)createLander;

@end