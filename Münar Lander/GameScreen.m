//
//  GameScreen.m
//  Münar Lander
//
//  Created by Matthew Dutton on 4/15/14.
//  Copyright (c) 2014 Matthew Dutton. All rights reserved.
//

#import "GameScreen.h"
#import "MainMenuScene.h"
#import "GameOverScene.h"
#import "VictoryScene.h"
#import "SKSpriteNode+DebugDraw.h"


typedef NS_OPTIONS(uint32_t, myPhysicsCategory) {
    
    phyCat_Player = 1 << 0,
    
    phyCat_LandingPads = 1 << 1,
    
    phyCat_Terrain = 1 << 2,
    
    phyCat_Edge = 1 << 3,
    
    phyCat_Asteroid = 1 << 4,
    
    phyCat_VictoryPad = 1 << 5,
    
    phyCat_None = 1 << 6,
    
    phyCat_StartingPad = 1 << 7
    
    
};



@implementation GameScreen

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        gamehelper = [GameDataHelper getSharedInstance];
        
        soundEffects = [mySoundPlayer sharedInstance];
        
        landerObject = [[LanderSprite alloc]init];
        
        BGObject = [[TerrainSprite alloc]init];
        
        refuel = NO;
        
        onPad = NO;
        
        onVictoryPad = NO;
        
        isCloseToRest = NO;
        
        reportedScore = NO;
        
        thrusterIsOperable = YES;
        
        fuelLevel = MAX_FUEL;
        
        fuelUsed = 0;
        
        died = NO;
        
        untouched = YES;
        
        [self startGame];
    
    }
    
    return self;
}




- (void)startGame {

    /* Setting up the scene here */
    self.backgroundColor = [SKColor colorWithRed:0.65 green:0.75 blue:0.3 alpha:1.0];
    
    self.physicsWorld.contactDelegate = self;
    
    // setting the world gravity to ~1/2 of earths gravity
    self.physicsWorld.gravity = CGVectorMake(0, -(9.8 / 2.5) );
    
    // setting the frame as a boundary
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    
    
    
#pragma mark -Objects Creation Calls
    
    // Adding the three lives tothe screen with individual names
    [self addLifeWithName:@"life1" atLocation:CGPointMake(55, self.frame.size.height - 50)];
    
    [self addLifeWithName:@"life2" atLocation:CGPointMake(110, self.frame.size.height - 50)];
    
    [self addLifeWithName:@"life3" atLocation:CGPointMake(165, self.frame.size.height - 50)];
    
    lives = 3;
    
    
    // creating the back ground and terrain for the game
    backGround = [BGObject createBackground];
    backGround.position = CGPointMake(self.size.width*1.5, self.size.height/2);
    [self addChild:backGround];
    
    
    // creating the lander sprite
    lander = [landerObject createLander];
    lander.position = CGPointMake(self.size.width/2, 580);
    [self addChild:lander];
    
    
    // creating the initial starting pad sprite
    [self createLandingPadWithName:@"startingPad" atPosition:CGPointMake(-965, 132) withSize:CGSizeMake(120, 10) andCategory: phyCat_StartingPad];
    
    
    // easy ( green ) pad
    [self createLandingPadWithName:@"easyPad" atPosition:CGPointMake(-997, -254) withSize:CGSizeMake(158, 10) andCategory: phyCat_LandingPads];
    
    
    // medium ( Yellow ) Pad
    [self createLandingPadWithName:@"mediumPad" atPosition:CGPointMake(136, -127) withSize:CGSizeMake(130, 10) andCategory: phyCat_LandingPads];
    
    
    // hard ( orange ) pad - - Victory Pad
    [self createLandingPadWithName:@"victoryPad" atPosition:CGPointMake(1317, -71) withSize:CGSizeMake(110, 10) andCategory: phyCat_VictoryPad];
    
    
    
    // creating and adding the arrows and thrust button to the screen
    [self addControlSurfaces];
    
    
    //creating the Falling Asteroids
    SKAction* createAsteroids = [SKAction sequence:@[
                                                     [SKAction performSelector:@selector(createAsteroids) onTarget:self],
                                                     [SKAction waitForDuration:.75f withRange:2.0f]
                                                     ]];
    
    [self runAction:[SKAction repeatActionForever:createAsteroids]];
    
    
    
#pragma mark -Fuel Label and Fuel Bar Creation
    SKLabelNode* fuelLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    fuelLabel.fontColor = [SKColor greenColor];
    fuelLabel.text = @"Fuel";
    fuelLabel.position = CGPointMake(755, self.frame.size.height - 75);
    [self addChild: fuelLabel];
  
    landerFuelBar = [FuelBar new];
    landerFuelBar.position = CGPointMake(900, self.frame.size.height - 65);
    [self addChild:landerFuelBar];
    
    
    SKLabelNode* fuelUsedLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    fuelUsedLabel.fontColor = [SKColor greenColor];
    fuelUsedLabel.text = @"Fuel Used";
    fuelUsedLabel.position = CGPointMake( self.frame.size.width/2, self.frame.size.height - 45);
    [self addChild:fuelUsedLabel];
    
    fuelUsedNumber = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    fuelUsedNumber.fontColor = [SKColor greenColor];
    fuelUsedNumber.text = @"00";
    fuelUsedNumber.position = CGPointMake( self.frame.size.width/2 , self.frame.size.height - 75);
    [self addChild:fuelUsedNumber];
    
    
    
    // asteroid and landing pad catagories, collision, and contactTest bitmasks are set up inside their creation method
#pragma mark -Setting Catagory
    // setting the catagory for each type
    lander.physicsBody.categoryBitMask = phyCat_Player;
    
    backGround.physicsBody.categoryBitMask = phyCat_Terrain;
    
    self.physicsBody.categoryBitMask = phyCat_Edge;
    
    
#pragma mark -Setting Collision
    // setting the collision for each type
    lander.physicsBody.collisionBitMask = phyCat_Terrain | phyCat_Edge | phyCat_LandingPads | phyCat_Asteroid | phyCat_VictoryPad | phyCat_StartingPad;
    
    backGround.physicsBody.collisionBitMask = phyCat_Player;
    
    self.physicsBody.collisionBitMask = phyCat_Player;
    
    
    
#pragma mark -Setting Contact Test
    
    lander.physicsBody.contactTestBitMask = phyCat_Terrain | phyCat_VictoryPad | phyCat_StartingPad | phyCat_LandingPads;
    
    backGround.physicsBody.contactTestBitMask = phyCat_Player;
}



// If the lander is on a landing pad change the Collision to not be effected by asteroids. Then when off the pad, turn asteroid collisions on
-(void)asteroidCollisionsShouldBeOn:(BOOL)collisions {
    
    if (collisions) {
        
        lander.physicsBody.collisionBitMask = phyCat_Terrain | phyCat_Edge | phyCat_LandingPads | phyCat_VictoryPad | phyCat_StartingPad;
        
    } else {
        
        // setting the collision for each type
        lander.physicsBody.collisionBitMask = phyCat_Terrain | phyCat_Edge | phyCat_LandingPads | phyCat_VictoryPad | phyCat_Asteroid | phyCat_StartingPad;
    }
    
}




#pragma mark -Back and Game Over Buttons

- (void)addLifeWithName:(NSString*)nodeName atLocation:(CGPoint)location {
    
    SKSpriteNode* life = [SKSpriteNode spriteNodeWithImageNamed:@"lives_Indicator.png"];
    
    [life setScale:.05f];
    
    life.position = location;
    
    life.name = nodeName;
    
    life.zPosition = 2;
    
    [self addChild:life];


}


-(void)playerWins {
    
    if ([Reachability isNetworkReachable] && gamehelper.localPlayer.authenticated == YES) {

        [gamehelper reportScore:fuelUsed];
        
    }
    
    [soundEffects effectNamed:@"rcs" shouldBe:NO];
    [soundEffects effectNamed:@"main" shouldBe:NO];
    [soundEffects effectNamed:@"victory" shouldBe:YES];
    
    // transitioning to the game over scene on game over
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    VictoryScene* scene = [[VictoryScene alloc]initWithSize:skView.bounds.size andScore:fuelUsed wasUntouched:untouched didntDie:died];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
    [skView presentScene:scene transition:reveal];
    
    
}



#pragma mark -Contact Happened
-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    // if there is a collision with the Victory pad at ALL, user wins game
    if ( (contact.bodyA.categoryBitMask == phyCat_VictoryPad )  ||  (contact.bodyB.categoryBitMask == phyCat_VictoryPad ) ) {
        
        onVictoryPad = YES;
        
        onPad = YES;
        
        isCloseToRest = nearlyAtRest(lander);
        
        [soundEffects effectNamed:@"landing" shouldBe:YES];
        
        [self asteroidCollisionsShouldBeOn: onPad];
        
        double delayInSeconds = 1.00f;

        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);

        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if (onVictoryPad && !reportedScore) {
                
                [self playerWins];
                
                reportedScore = TRUE;
                
            } else {
                
                fuelLevel += .05;
            }
            
            
        });

        
    // if the collision involves terrain then take lives
    } else if ((contact.bodyA.categoryBitMask == phyCat_Terrain )  ||  (contact.bodyB.categoryBitMask == phyCat_Terrain )) {
        
        NSTimeInterval thisTime = [[NSDate date]timeIntervalSince1970];
        
        if(lastTimerun) {
            timeDiff = thisTime - lastTimerun;
            
        } else {
            timeDiff = 0;
        }

         // is a bug fix for a sitution where the game would take 2 lives away in quick succession.
        if ( (timeDiff > .1) || (timeDiff == 0) )  {

            // if the player has X number of lives left then take the corresponding life and reset to start position.
            if ( lives == 3 ) {
        
                [self takeLifeWithName:@"life3"];
                
                
            } else if ( lives == 2 ) {
            
               [self takeLifeWithName:@"life2"];
            
                
            } else if ( lives == 1 ) {
                
                [self takeLifeWithName:@"life1"];
                
                
            // if there are no more lives left your DEAD
            } else {
                
                NSLog(@"Game Over");
                
                [soundEffects effectNamed:@"rcs" shouldBe:NO];
                [soundEffects effectNamed:@"main" shouldBe:NO];
                
                // ensuring the touches are off
                thrusting = NO;
                rotateLeft = NO;
                rotateRight = NO;
                
                // ensuring the particle emmiters stop
                landerObject.landerEngine.numParticlesToEmit = 1;
                landerObject.rcsLeft.numParticlesToEmit = 1;
                landerObject.rcsRight.numParticlesToEmit = 1;
                
                
                // transitioning to the game over scene on game over
                SKView * skView = (SKView *)self.view;
                skView.showsFPS = NO;
                skView.showsNodeCount = NO;
                
                SKScene * scene = [GameOverScene sceneWithSize:skView.bounds.size];
                scene.scaleMode = SKSceneScaleModeAspectFill;
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
                [skView presentScene:scene transition:reveal];
                
            
            }

            lives--;
            
        } else {
            // is a bug fix for a sitution where the game would take 2 lives away in quick succession.
            NSLog(@"OUTSIDE: Bug Avoided: thisTime:%f, lastrunTime: %f, Timediff: %f", thisTime, lastTimerun, timeDiff);
        }
        
        lastTimerun = thisTime;
        
    // if the contact was with a normal landing pad then i want to make the lander move back with it instead of push forward
    } else if ((contact.bodyA.categoryBitMask == phyCat_LandingPads )  ||  (contact.bodyB.categoryBitMask == phyCat_LandingPads )){
        
        onPad = YES;
        
        refuel = YES;
        
        [soundEffects effectNamed:@"landing" shouldBe:YES];
        
        [self asteroidCollisionsShouldBeOn: onPad];
        
    } else if ((contact.bodyA.categoryBitMask == phyCat_StartingPad )  ||  (contact.bodyB.categoryBitMask == phyCat_StartingPad )){
        
        onPad = YES;
        
        refuel = NO;
        
        [soundEffects effectNamed:@"landing" shouldBe:YES];
        
        [self asteroidCollisionsShouldBeOn: onPad];
        
    } else if ((contact.bodyA.categoryBitMask == phyCat_Asteroid )  ||  (contact.bodyB.categoryBitMask == phyCat_Asteroid )) {
        
        
        if (onPad == NO) {
            
            untouched = NO;
            
        }
        
    }
    
}



- (void)didEndContact:(SKPhysicsContact *)contact {
    
    if ((contact.bodyA.categoryBitMask == phyCat_LandingPads )  ||  (contact.bodyB.categoryBitMask == phyCat_LandingPads )){
        
        onPad = NO;
        
        refuel = NO;
        
        [self asteroidCollisionsShouldBeOn: onPad];
        
    } else if ((contact.bodyA.categoryBitMask == phyCat_StartingPad )  ||  (contact.bodyB.categoryBitMask == phyCat_StartingPad )){
        
        onPad = NO;
        
        [self asteroidCollisionsShouldBeOn: onPad];
        
    } else if((contact.bodyA.categoryBitMask == phyCat_VictoryPad )  ||  (contact.bodyB.categoryBitMask == phyCat_VictoryPad )){
        
        onVictoryPad = NO;
        
        onPad = NO;
        
        [self asteroidCollisionsShouldBeOn: onPad];
        
    }

}



- (void)takeLifeWithName:(NSString*)name {
    
    [self enumerateChildNodesWithName:name usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    died = YES;
    
    [self destroyAndCreateLander];
}


-(void)destroyAndCreateLander {
    
    thrusterIsOperable = NO;
    
    [soundEffects effectNamed:@"rcs" shouldBe:NO];
    
    [soundEffects effectNamed:@"main" shouldBe:NO];
    
    thrusting = NO;
    
    rotateLeft = NO;
    
    rotateRight = NO;
    
    refuel = NO;
    
    [soundEffects effectNamed:@"death" shouldBe:YES];
    
    [self enumerateChildNodesWithName:@"lander" usingBlock:^(SKNode *node, BOOL *stop) {
        
        [node removeFromParent];
        
    }];
  
    // amount of time that you want to delay the code block
    double delayInSeconds = 1.0;
    
    // setting a grand central dispatch version of a timer that takes in time now and then how long to wait
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    // setting a grand central dispatch method to run a code block after the timer expires
    // takes in the timer, thread to run on, and the code block to run
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //resets the lander after 1 second
        lander = [landerObject createLander];
        lander.position = CGPointMake(self.size.width/2, 580);
        [self addChild:lander];
        
    
        thrusterIsOperable = YES;
        
    });
    
    // add fuel if the lander is killed with less than 75 fuel
    if (fuelLevel < 0.20f) {
        
        fuelLevel = 0.25f;
        
    }
    
    
    
}




#pragma mark -Touch Actions
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:location];
    
    
    if ([node.name isEqualToString:@"backButton"]) {
       
        SKView * skView = (SKView *)self.view;
        
        skView.showsFPS = NO;
        
        skView.showsNodeCount = NO;
        
        SKScene * scene = [VictoryScene sceneWithSize:skView.bounds.size];
        
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.5];
        
        [skView presentScene:scene transition:reveal];
        
    }
    
    if ([node.name isEqualToString:@"thrust"] && thrusterIsOperable ){
        
        
        [self turnOnThruster];
    
    }
    
    if ([node.name isEqualToString:@"left"]) {
        
        [self rotateShipLeft];

    }
    
    if ([node.name isEqualToString:@"right"]) {
        
        [self rotateShipRight];
        
    
    }
    
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
 
     UITouch *touch = [touches anyObject];
     
     CGPoint location = [touch locationInNode:self];
     
     SKNode* node = [self nodeAtPoint:location];
    
     if (CGRectContainsPoint(node.frame, location)){

         if ([node.name isEqualToString:@"background"]) {
             
             [self turnOffThruster];
         }
         
         if ( [node.name isEqualToString:@"thrust"] && thrusterIsOperable ) {
            
             [self turnOnThruster];
             
         }
     
     }
 
 }


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:location];
    
    if (  [node.name isEqualToString:@"thrust"]){
        
        [self turnOffThruster];
        
    }
    
    if (  [node.name isEqualToString:@"left"]  ||  (rotateLeft == YES) ) {
       
        [self stopRotateShipLeft];
        
    }
    
    if (  [node.name isEqualToString:@"right"] ||  (rotateRight == YES) ) {
        
        [self stopRotateShipRight];
        
        
    }
    
    
}


#pragma mark -Ship Controlls
- (void)turnOnThruster {
    
    thrusting = YES;
    
    landerObject.landerEngine.numParticlesToEmit = 0;
    
    [soundEffects effectNamed:@"main" shouldBe:YES];
    
    soundEffects.thrusterSound.volume = .5f;
}

- (void)turnOffThruster {
    
    thrusting = NO;
    
    landerObject.landerEngine.numParticlesToEmit = 100;
    
    [soundEffects effectNamed:@"main" shouldBe:NO];
}

- (void)rotateShipLeft {
    
    rotateLeft = YES;
    
    [soundEffects effectNamed:@"rcs" shouldBe:YES];
    
    soundEffects.rcsSound.volume = .125f;
    
    landerObject.rcsLeft.numParticlesToEmit = 0;
}

- (void)rotateShipRight {
    
    rotateRight = YES;
    
    [soundEffects effectNamed:@"rcs" shouldBe:YES];
    
    soundEffects.rcsSound.volume = .125f;
    
    landerObject.rcsRight.numParticlesToEmit = 0;
}


- (void)stopRotateShipLeft {
    
    rotateLeft = NO;
    
    [soundEffects effectNamed:@"rcs" shouldBe:NO];
    
    landerObject.rcsLeft.numParticlesToEmit = 25;
}

- (void)stopRotateShipRight {
    
    rotateRight = NO;
    
    [soundEffects effectNamed:@"rcs" shouldBe:NO];
    
    landerObject.rcsRight.numParticlesToEmit = 25;
}


#pragma mark -Fuel Controller
-(void)burnFuel {
    
    fuelLevel -= FUEL_BURN_RATE;
    
    if (fuelLevel < 0) {
        fuelLevel = 0;
    }
    
    fuelUsed++;
    fuelUsedNumber.text = [NSString stringWithFormat:@"%i", fuelUsed];

}

-(void)addFuel {
    
    fuelLevel += FUEL_REFILL_RATE;
    
    if (fuelLevel > MAX_FUEL) {
        fuelLevel = MAX_FUEL;
    }
    
    
}

-(void)displayFuelLevel {

    [landerFuelBar setProgress: fuelLevel ];
    
}



#pragma mark -Update Method

-(void)update:(NSTimeInterval)currentTime {
    
    [self displayFuelLevel];

    if (fuelLevel <= 0 ) {
        
        thrusting = NO;
        
        [self turnOffThruster];
        
    }

    if(lastTime) {
        
        delta_Time = currentTime - lastTime;
    
    } else {
        
        delta_Time = 0;
    }

    
    if (thrusting) {
        
        CGVector movement = [self getVectorFromRotation:lander.zRotation andMagnitude:12000];
        
        [lander.physicsBody applyForce:movement];
        
        [self burnFuel];
        
    }
    
    if (rotateLeft) {
        
        [lander.physicsBody applyForce:CGVectorMake( RCS_TURNING_FORCE, 0) atPoint:CGPointMake(lander.size.width/2, lander.size.height/2+lander.size.height/4)];
    }
    
    if (rotateRight) {
        
        [lander.physicsBody applyForce:CGVectorMake( -RCS_TURNING_FORCE, 0) atPoint:CGPointMake(lander.size.width/2, lander.size.height/2+lander.size.height/4)];
    }
    
    if (onPad) {
        
        [self moveLanderWithName:@"lander"];
        
        if (refuel) {
            
            [self addFuel];
            
        }
    
    }
    
    
    [self moveBackgroundWithName:@"background"];
    
    lastTime = currentTime;
    
    
    
}


-(CGVector)getVectorFromRotation:(float)radians andMagnitude:(int)mag{

    float x = -mag * sin(radians);
    
    float y = mag * cos(radians);
    
    return CGVectorMake(x, y);
}




- (void)createLandingPadWithName:(NSString*)padName atPosition:(CGPoint)location withSize:(CGSize)padSize andCategory:(u_int32_t)category {
    
    // starting landing pad
    SKSpriteNode* LandingPad = [SKSpriteNode spriteNodeWithColor:nil size:padSize];
    
    LandingPad.position = location;
    
    LandingPad.name = padName;
    
    
    
    LandingPad.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:LandingPad.size];
    
    LandingPad.physicsBody.dynamic = NO;
    
    LandingPad.physicsBody.friction = 1;
    
    [LandingPad attachDebugRectWithSize:LandingPad.size];
    
    
    LandingPad.physicsBody.categoryBitMask = category;
    
    LandingPad.physicsBody.collisionBitMask = phyCat_Player;
    
    LandingPad.physicsBody.contactTestBitMask = phyCat_None;
    
    [backGround addChild:LandingPad];

}



#pragma mark -Rest Determination Functions
static inline CGFloat speed( CGVector velocity){
    
    float deltaX = velocity.dx;
    
    float deltaY = velocity.dy;
    
    return sqrtf( (deltaX * deltaX) + (deltaY * deltaY) );
    
}

static inline CGFloat angularSpeed( CGFloat velocity){
    
    return fabs(velocity);
    
}

static inline bool nearlyAtRest(SKNode* node) {
    
    return ( speed(node.physicsBody.velocity) < .1f  &&  angularSpeed(node.physicsBody.angularVelocity) < .1f);
    
}



#pragma mark -Asteroid Creation

static inline CGFloat skRandf() {
    
    return rand() / (CGFloat) RAND_MAX;
}


static inline CGFloat skRand(CGFloat low, CGFloat high) {

    return skRandf() * (high - low) + low;
}



-(void)createAsteroids {
    
    
    asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"Asteroid"];
    
    asteroid.position = CGPointMake( skRand(0, self.size.width), self.size.height + 100 );
    
    asteroid.name = @"asteroid";
    
    
    // adding the physics properties to the asteroids
    
    asteroid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:asteroid.size.width/2 center:CGPointMake(0,0)];
    
    asteroid.physicsBody.usesPreciseCollisionDetection = YES;
    
    asteroid.physicsBody.mass = 17.0f;
    
    asteroid.physicsBody.angularDamping = 1;
    
    asteroid.physicsBody.friction = 1;
    
    asteroid.physicsBody.categoryBitMask = phyCat_Asteroid;
    
    asteroid.physicsBody.collisionBitMask = phyCat_Player;
    
    asteroid.physicsBody.contactTestBitMask = phyCat_Player;
    
    [asteroid attachDebugRectWithSize:asteroid.size];
    
    [self addChild:asteroid];
    
}




#pragma mark -Adding User Controls

-(void)addControlSurfaces {
 
    
    thrustButton = [SKSpriteNode spriteNodeWithImageNamed:@"Thrust_Button"];
    
    thrustButton.name = @"thrust";
    
    [thrustButton setScale:1.5];
    
    thrustButton.position = CGPointMake( (self.size.width) - (thrustButton.size.width) + 25, 140 );
    
    [self addChild:thrustButton];
    
    
    
    rotateLeftButton = [SKSpriteNode spriteNodeWithImageNamed:@"Left_Arrow"];
    
    rotateLeftButton.name = @"left";
    
    rotateLeftButton.size = CGSizeMake(rotateLeftButton.size.width, rotateLeftButton.size.height);
    
    [rotateLeftButton setScale: 1 ];
    
    rotateLeftButton.position = CGPointMake( 87, 70 + 66);
    
    [self addChild:rotateLeftButton];
    
    
    
    rotateRightButton = [SKSpriteNode spriteNodeWithImageNamed:@"Right_Arrow"];
    
    rotateRightButton.name = @"right";
    
    [rotateRightButton setScale: 1 ];
    
    rotateRightButton.position = CGPointMake( 117 + (rotateLeftButton.size.width), 70 + 66);
    
    [self addChild:rotateRightButton];
    
    
}



#pragma mark -Moving the Background

-(void)moveBackgroundWithName:(NSString*)name {
    
    [self enumerateChildNodesWithName:name usingBlock:^(SKNode *node, BOOL *stop){
       
        // setting the sprite to be the enumerated result
        SKSpriteNode* moving_Background  = (SKSpriteNode *)node;
        
        //The speed at which the background image will move
        CGPoint bgVelocity = CGPointMake( BACKWARDS_MOVEMENT, 0);
        
        // setting the movement by sending to the method the desired change and the amount of time passed
        CGPoint amountToMove = CGPointMultiplyScalar ( bgVelocity, delta_Time );
        
        //moving the background by passing in the starting position and how much to move it
        // calculation is done int the CGPointADD function
        moving_Background.position = CGPointAdd( moving_Background.position, amountToMove );
        
        
        // if the origin of BG has moved to 1/2 a frame off the screen then the background movement is over.
        if ( (backGround.position.x) <= -(self.frame.size.width / 2) + 1  ) {
            
            [backGround setPosition:CGPointMake( -(self.frame.size.width / 2) + 1, moving_Background.position.y)];;
        
        }
        

    }];
}



-(void)moveLanderWithName:(NSString*)name {
    
    if ( !((backGround.position.x) <= -(self.frame.size.width / 2) + 1)  ) {
        
        [self enumerateChildNodesWithName:name usingBlock:^(SKNode *node, BOOL *stop){
            
            // setting the sprite to be the enumerated result
            SKSpriteNode* backward_Lander  = (SKSpriteNode *)node;
            
            //The speed at which the background image will move
            CGPoint bgVelocity = CGPointMake( BACKWARDS_MOVEMENT, 0);
            
            // setting the movement by sending to the method the desired change and the amount of time passed
            CGPoint amountToMove = CGPointMultiplyScalar ( bgVelocity, delta_Time );
            
            //moving the background by passing in the starting position and how much to move it
            // calculation is done int the CGPointADD function
            backward_Lander.position = CGPointAdd( backward_Lander.position, amountToMove );

            
        }];
        
    }
}



CGPoint CGPointAdd(CGPoint p1, CGPoint p2)
{
    // adding the current position and the return from the amount to move scalar
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

CGPoint CGPointMultiplyScalar(CGPoint p1, CGFloat p2)
{
    // multiplying the desired change in the X coordinate by the change in time.
    return CGPointMake(p1.x *p2, p1.y*p2);
}




@end
