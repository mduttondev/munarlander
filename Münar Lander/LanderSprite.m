//
//  LanderSprite.m
//  Münar Lander
//
//  Created by Matthew Dutton on 5/2/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import "LanderSprite.h"
#import "SKSpriteNode+DebugDraw.h"

@implementation LanderSprite
@synthesize landerEngine,rcsLeft,rcsRight;


- (id)init{
    
    self = [super init];

    return self;
    
}



-(SKSpriteNode*)createLander {
    
    // lander sprite
    ship = [SKSpriteNode spriteNodeWithImageNamed:@"Moon_Lander"];
    
    ship.name = @"lander";
    
    ship.size = CGSizeMake(ship.size.width * 0.1, (ship.size.height * 0.1));
    
    
    // creating the lander physics body
    CGMutablePathRef tempLander = CGPathCreateMutable();
    
    CGPathMoveToPoint(tempLander, nil, -ship.size.width/2, -ship.size.height/2);
    
    CGPathAddLineToPoint(tempLander, nil, ship.size.width/2, -ship.size.height/2);
    CGPathAddLineToPoint(tempLander, nil, 25, 0);
    CGPathAddLineToPoint(tempLander, nil, 15, 35);
    CGPathAddLineToPoint(tempLander, nil, -15, 35);
    CGPathAddLineToPoint(tempLander, nil, -25, 0);
    CGPathAddLineToPoint(tempLander, nil, -ship.size.width/2, -ship.size.height/2);
    
    ship.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:tempLander];
    
    ship.physicsBody.friction = 1.0f;
    
    ship.physicsBody.mass = 10;
    
    ship.physicsBody.dynamic = YES;
    
    ship.physicsBody.angularDamping = 2.5f;
    
    ship.physicsBody.linearDamping = .5f;
    
    [ship attachDebugRectFromPath:tempLander];
    
    CGPathRelease(tempLander);
    
    
    // adding the thrust emitter for the engine.
    landerEngine = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"EngineThrust" ofType:@"sks"]];
    
    landerEngine.position= CGPointMake(0, -23);
    
    landerEngine.numParticlesToEmit = 1;
    
    [ship addChild:landerEngine];

    
    
    rcsLeft = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"rcsThrust" ofType:@"sks"]];
    
    rcsLeft.position= CGPointMake( (ship.size.width/2) - 10, 10);
    
    rcsLeft.zRotation = DEGREES_TO_RADIANS(330);
    
    rcsLeft.numParticlesToEmit = 1;
    
    [ship addChild:rcsLeft];
    
    
    
    rcsRight = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"rcsThrust" ofType:@"sks"]];
    
    rcsRight.position= CGPointMake( -(ship.size.width/2) + 10, 10);
    
    rcsRight.zRotation = DEGREES_TO_RADIANS(210);
    
    rcsRight.numParticlesToEmit = 1;
    
    [ship addChild:rcsRight];
    
    return ship;
}




@end
