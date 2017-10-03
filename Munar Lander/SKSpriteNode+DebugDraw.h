//
//  SKSpriteNode+DebugDraw.h
//  Münar Lander
//
//  Created by Matthew Dutton on 4/22/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKSpriteNode (DebugDraw)

-(void) attachDebugRectWithSize:(CGSize)s;
-(void) attachDebugRectFromPath:(CGPathRef)bodyPath;


@end
