//
//  VictoryScene.h
//  Münar Lander
//
//  Created by Matthew Dutton on 5/1/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameDataHelper.h"
#import "Constants.h"

@interface VictoryScene : SKScene <UITextFieldDelegate, UIActionSheetDelegate>

@property GameDataHelper* gameHelper;

-(id)initWithSize:(CGSize)size andScore:(int)score wasUntouched:(BOOL)untouched didntDie:(BOOL)died;

@end
