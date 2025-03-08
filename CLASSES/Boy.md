# SUBCLASS

## GroundInfo

### GroundInfo

# FUNCTIONS

## AddForce

## AddForceProxy

## AddVelocity

## ApplyAnimPoseToSkeleton

## ApplyAnimPoseToSkeleton

## ApplyCollisions

## ApplyStateTransition

## Boy

-Superclass of SkeletonStateNode
-Initializes a Boy (more info in struct)

## CallRumbleScript

## Create

-Allocates 0x28c bytes of memory, then calls Boy();

## DebugAddTransitionComment

## DropDown

## DropDown

## DropDownProxy

## ExamineDeath

## ExamineRagdollCollisions

## FellInWater

## GetAnimationPose

## GetAnimationPose

## GetBoyFlags

## GetBoyGravity

## GetClassType

## GetCustomGravity

## GetCycleDistance

## GetCycleDistance

## GetDeathDetectorID0

## GetDeathDetectorID1

## GetDebug

## GetDebug

## GetFallInWaterWitness

## GetFootPos

## GetFootPosProxy

## GetForwardDir

## GetForwardDirProxy

## GetGenericPropertyData

## GetGroundAverageVelocity

## GetGroundInfo

## GetGroundPlateau

## GetGroundPlateau

## GetGroundVelocity

## GetGroundVolumeProxy

## GetImageID

## GetLogicWheelPlateau

## GetMass

## GetMassProxy

## GetNumOutputEvents

## GetObstructionStatus

## GetOutputEventName

## GetOutputEventReceiver

## GetRightDir

## GetRumbleScript

## GetShoulderPos

## GetShoulderPosProxy

## GetSkeletonCore

## GetSkeletonCore

## GetSkeletonProxy

## GetStateNameProxy

## GetStateProxy

## GetStateTimeElapsedProxy

## GetThemeID

## GetUpDir

## GetUpDirProxy

## GetUpRot

## GetVelocity

## GetVelocityProxy

## GetWaterProxy

## GetWheelPos

## GetWheelPosProxy

## GotFocus

## GotFocus

## Initialize

## Integrate

## IsActive

## IsClimbing

## IsDead

## IsDeadProxy

-Checks whether Boy's state can be cast to a BoyRagdollState and, if so, checks if [state+0xfc]&4 !=0.

## IsDebugEnabled

## Kill

## KillProxy

## LostFocus

## LostFocus

## RefreshGroundHistory

## ResetBoyState

## Restart

## Revive

## SetActionToggle

## SetBoyFlag

## SetBoyFlagProxy

## SetBoyFlags

## SetCustomGravity

## SetDeathDetectorID0

## SetDeathDetectorID1

## SetFallInWaterWitness

## SetGenericPropertyData

## SetJumpBanTimeProxy

## SetMaxSpeedProxy

## SetOutputEventReceiver

## SetRumbleScript

## SetThemeID

## SetWheelPos

## SetWheelPos

## SetWheelPosProxy

## SetWheelPosVisualUnchangedProxy

## SpawnStateProxy

## Start

## TheBoy

-Singleton version of Boy ("THE" Boy)
-Does NOT indicate that the pClassType is the Boy - based on empirical evidence, the Boy is at \*(\*(\*(pClassType) + 0x24)) (thanks Tedder!)

## Update

## UpdateCache

## UpdateDebug

## UpdateGravity

## UpdatePos

-Retrieves [g_pPhysicsWorld2D+0x140] as "tick_rate"
-Updates position vector in Boy struct with "position += velocity\*tick_rate"

## UpdateSkeletonState

## UpdateSkeletonState

## UpdateWater

## ~Boy

## ~Boy

## ~Boy

## ~Boy


# STRUCT

struct Boy { /* PlaceHolder Structure */  
    struct SkeletonStateNode field0_0x0; //superclass  
    vector2f position;
    dword field3_0x6c;  
    vector2f velocity;
    dword field6_0x78;  
    float field7_0x7c;  
    float field8_0x80;  
    dword field9_0x84;  
    dword field10_0x88;  
    dword field11_0x8c;  
    dword field12_0x90;  
    dword field13_0x94;  
    float field14_0x98;  
    dword field15_0x9c;  
    dword field16_0xa0;  
    float field17_0xa4;  
    float field18_0xa8;  
    float field19_0xac;  
    float field20_0xb0;  
    dword field21_0xb4;  
    struct BoyVisual field22_0xb8; //0x120 bytes as inferred from packing  
    BoyState\* state; //ragdoll, idle, push, etc.  
    dword field24_0x1dc;  
    dword field25_0x1e0;  
    dword field26_0x1e4;  
    dword field27_0x1e8;  
    struct DeathDetector field28_0x1ec; //0xc bytes as inferred from packing  
    dword field29_0x1f8;  
    float field30_0x1fc;  
    float field31_0x200;  
    dword field32_0x204;  
    dword field33_0x208;  
    struct ReferentList field34_0x20c;  
    struct ReferentList field35_0x218;  
    struct ReferentList field36_0x224;  
    struct ReferentList field37_0x230;  
    struct ReferentList field38_0x23c;  
    word \*\*field39_0x248;  
    int field40_0x24c;  
    void \*field41_0x250;  
    void \*field42_0x254;  
    void \*field43_0x258;  
    void \*field44_0x25c;  
    void \*field45_0x260;  
    void \*field46_0x264;  
    void \*field47_0x268;  
    void \*field48_0x26c;  
    undefined field49_0x270;  
    undefined field50_0x271;  
    undefined field51_0x272;  
    undefined field52_0x273;  
    undefined field53_0x274;  
    undefined field54_0x275;  
    undefined field55_0x276;  
    undefined field56_0x277;  
    undefined field57_0x278;  
    undefined field58_0x279;  
    undefined field59_0x27a;  
    undefined field60_0x27b;  
    undefined field61_0x27c;  
    undefined field62_0x27d;  
    undefined field63_0x27e;  
    undefined field64_0x27f;  
    undefined field65_0x280;  
    undefined field66_0x281;  
    undefined field67_0x282;  
    undefined field68_0x283;  
    undefined field69_0x284;  
    undefined field70_0x285;  
    undefined field71_0x286;  
    undefined field72_0x287;  
    undefined field73_0x288;  
    undefined field74_0x289;  
    undefined field75_0x28a;  
    undefined field76_0x28b;  
};  