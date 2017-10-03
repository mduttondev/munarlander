//
//  TerrainSprite.h
//  Münar Lander
//
//  Created by Matthew Dutton on 5/2/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKSpriteNode+DebugDraw.h"

@interface TerrainSprite : SKSpriteNode
{
    
    SKSpriteNode* ground;
}

-(id)init;

- (SKSpriteNode*)createBackground;

@end
