//
//  TerrainSprite.m
//  Münar Lander
//
//  Created by Matthew Dutton on 5/2/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import "TerrainSprite.h"

@implementation TerrainSprite


-(id)init {
    
    self = [super init];

    
    return  self;
}



- (SKSpriteNode*)createBackground {
    
    
    // background image and terrain as one sprite. I have the individual assets if these need to be seperate to work or if i decide to do paralax scrolling
    ground = [SKSpriteNode spriteNodeWithImageNamed:@"Munar_Level_1"];
    ground.name = @"background";
    
    
    // setting the back ground collision body
    CGMutablePathRef tempPath = CGPathCreateMutable();
    
    // setting the starting point
    CGPathMoveToPoint(tempPath, nil, -ground.size.width/2, -ground.size.height/2);
    
    //adding lines to the mutablePathRef for the "surface" == "creating the collision boundry"
    CGPathAddLineToPoint(tempPath, nil, -ground.size.width/2, -215);
    CGPathAddLineToPoint(tempPath, nil, -1433, -232);
    CGPathAddLineToPoint(tempPath, nil, -1378, -284);
    CGPathAddLineToPoint(tempPath, nil, -1116, -255);
    CGPathAddLineToPoint(tempPath, nil, -701, -257);
    CGPathAddLineToPoint(tempPath, nil, -403, -158);
    CGPathAddLineToPoint(tempPath, nil, -125, -117);
    CGPathAddLineToPoint(tempPath, nil, -82, -145);
    CGPathAddLineToPoint(tempPath, nil, 216, -124);
    CGPathAddLineToPoint(tempPath, nil, 216, -94);
    CGPathAddLineToPoint(tempPath, nil, 360, -42);
    CGPathAddLineToPoint(tempPath, nil, 624, -134);
    CGPathAddLineToPoint(tempPath, nil, 681, -79);
    CGPathAddLineToPoint(tempPath, nil, 905, -79);
    CGPathAddLineToPoint(tempPath, nil, 1041, -196);
    CGPathAddLineToPoint(tempPath, nil, 1191, -240);
    CGPathAddLineToPoint(tempPath, nil, 1262, -75);
    CGPathAddLineToPoint(tempPath, nil, 1362, -77);
    CGPathAddLineToPoint(tempPath, nil, 1536, -119);
    CGPathAddLineToPoint(tempPath, nil, 1536, -384);
    CGPathAddLineToPoint(tempPath, nil, -1536, -384);
    
    ground.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:tempPath];
    
    ground.physicsBody.friction = 1.0f;
    
    ground.physicsBody.dynamic = NO;
    
    
    [ground attachDebugRectFromPath:tempPath];
    
    CGPathRelease(tempPath);
    
    return ground;
}


@end
