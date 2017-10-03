//
//  FuelBar.m
//  Munar lander
//
//  Created by Matthew Dutton on 1/13/15.
//  Copyright (c) 2015 Matthew Dutton. All rights reserved.
//

#import "FuelBar.h"

@implementation FuelBar

- (id)init {
    if (self = [super init]) {
        self.maskNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(200,50)];
        SKSpriteNode * sprite = [SKSpriteNode spriteNodeWithImageNamed:@"fuel_gradient.png"];
        [self addChild:sprite];
    }
    return self;
}

- (void) setProgress:(CGFloat) progress {
    self.maskNode.xScale = progress;
}

@end
