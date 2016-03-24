//
//  Constants.h
//  Munar lander
//
//  Created by Matthew Dutton on 1/22/15.
//  Copyright (c) 2015 Matthew Dutton. All rights reserved.
//

//**********************************************************************
//
//                    Ship Movement Constants
//
//**********************************************************************
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (M_PI / 180.0))

#define BACKWARDS_MOVEMENT  ( -70 )

#define RCS_TURNING_FORCE ( 175 )
#define MAX_FUEL ( 1 )
#define FUEL_BURN_RATE ( 0.002f )
#define FUEL_REFILL_RATE ( 0.004f )



//**********************************************************************
//
//                    Leaderboard and Achievements Constants
//
//**********************************************************************


#define kGAMERTAG @"gamerTag"
#define kSCORE   @"score"

#define kCOMPLETE_FIRST_TIME        @"complete_first_time"
#define kCOMPLETE_WITHOUT_DYING     @"complete_without_dying"
#define kCOMPLETE_WITHOUT_HIT       @"complete_without_hit"
#define kGAMEOVER_FIRST_TIME        @"gameover_first_time"
#define kCOMPLETE_OVER_900          @"complete_over_900"
#define kCOMPLETE_USING_LESS_500    @"complete_using_less500"
#define kCOMPLETE_USING_LESS_400    @"complete_using_less400"
#define kCOMPLETE_USING_LESS_300    @"complete_using_less300"

#define COMPLETE 100
#define NOT_COMPLETE 0