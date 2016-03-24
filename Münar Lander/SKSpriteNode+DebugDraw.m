//
//  SKSpriteNode+DebugDraw.m
//  Münar Lander
//
//  Created by Matthew Dutton on 4/22/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import "SKSpriteNode+DebugDraw.h"

static BOOL kDebugDraw = NO;

@implementation SKSpriteNode (DebugDraw)


-(void) attachDebugRectWithSize:(CGSize)s{
    
    CGPathRef bodyPath = CGPathCreateWithRect(CGRectMake(-s.width/2, -s.height/2, s.width, s.height), nil);
    
    [self attachDebugRectFromPath:bodyPath];
    CGPathRelease(bodyPath);
    
}

-(void) attachDebugRectFromPath:(CGPathRef)bodyPath {
    
    if(kDebugDraw == NO){
        return;
    }
    
    SKShapeNode *shape = [SKShapeNode node];
    
    shape.path = bodyPath;
    shape.strokeColor = [SKColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    shape.lineWidth = 1.0;
    
    [self addChild:shape];
    
}

@end
