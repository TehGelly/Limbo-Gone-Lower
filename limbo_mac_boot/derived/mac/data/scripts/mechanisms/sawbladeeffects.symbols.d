7   blade     ;                                     force 	0.0, 50.0                                       Emitter                                        firstCut Signal   
                                    pelvisTorque -200.0, 200.0                                       minNumOfParts 	0.0, 12.0                                       maxNumOfParts 	0.0, 12.0                                       clockWiseRotation                                         boolNotInUse                                         electrocutionProbes                          	           	   	partEnter signal   
                      
           
   	partLeave signal   
                                    AlwaysCutInHalf                                         useOutEffectBlood                                         	bodyParts                  6                 ����splitAppartBoy                                      ����bloodEmitterFired                                      ����
numOfParts                                      ����boy     K                                ����skeleton     J                                ����pelvis     6                                ����dirToShootParts                                       ����numberOfParts                           "           ����start1                           #           ����	elecProbe     0                     &           ����
bodyProbes                  0      '           ����disconnectedBones                           4           ����tempPart                           5           ����prefab     0                     6           ����partInsideBlade                           7           ����fPartInsideCounter                           8           ����fQuarantine                           9           ����torso     6                     :           ����
tForceKill                           ;           ����
GoreFolder                           <           ����GoreParticleFolder                          =           ����iNumberGoreParticles                           >           ����HeadSplatParticles                          ?           ����tHeadHit                           @           ����headHitTime                           A           ����headhit                           B           ����initialSignalHasBeenSend                           C           ����timeSinceInitialHit                           D           ����firstCutEmitter                          E           ����goreSpawnPoint                          F           ����setUpBloodEmitters                                                  initiateKillEffects                          u                       findDirection                          �                         
SplitApart                          x                       killTriggerEntered                          ~                
   
       findBodyPartsToDismantle                          �                     GetNearestCol                                                   addForceToParts                          e                     	integrate                          D
                     start                          �
          	           <   blood     2                          r   ����dataBase                                  r   ����rUpper     6                    
   �   �  ����rForearm     6                    	   �   �  ����rFoot     6                       �   �  ����rThigh     6                       �   �  ����rCalf     6                       �   �  ����lUpper     6                       �   �  ����lForearm     6                       �   �  ����lFoot     6                       �   �  ����lThigh     6                       �   �  ����lCalf     6                       �   �  ����head     6                        ~   �  ����killTrigger                         ����    �  ����newY                             ,  u  ����newX                             
  u  ����	radToTurn                             �  u  ����newDir                             �  u  ����orgDir                              �  u  ����position                          ����    u  ����forceVector                             �  y  ����body     6                         y  ����	tWasAlive                             �  y  ����name                             �  {  ����bodyNotDisconnected                              �  {  ����i                          ����    {  ����grandparent                             �  �  ����p                             �  �  ����	activator     
                     ����    �  ����caller     
                     ����    �  ����
distToPart                             1  �  ����i                               �  ����tFound                             �    ����closestDist                             �    ����closestPart                              �    ����dist                             !  K  ����iNearest                               b  ����fNearest                             	  b  ����i                               b  ����max                                b  ����vStart                          ����    b  ����vDir                             �  U  ����myPart     2                       �  A  ����child                             �  A  ����index                             �  A  ����daSprite     ,                       �  	  ����colPos                          
   �  	  ����colID                          	   �  	  ����vEnd                             �  	  ����vStart                             �  	  ����wantedSprite                             M  	  ����forceVector                             !	  V	  ����
distToPart                             �  c	  ����tInside                             �  �	  ����child     6                       ~  �	  ����forceVector                             �	  +
  ����
distToPart                             �	  A
  ����
bodyFolder                              e  A
  ����child                             #  I  ����tempRad                              �
  o  ����   globalscripteyes   !g_DeathEffectParticleDatabaseNode   g_EyesScript�  fastShutMode�  g_disableZombieWormP  g_boyPelvisProbe�
  '                                                                                                                                                                                                                                                  *   H   H   X   X   d   r   u   u   u   {   ~   ~   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   
    "  .  :  F  R  ^  j  v  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �     
  
  
  ,  N  N  Z  Z  n  n  u  x  x  x  x  x  x  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �        #  #  0  0  8  8  :  Z  Z  h  n  t  |  |  |  �  �  �  �  �  �  �  �  �  �  �  �  �  �           /  >  @  O  O  O  O  O  Y  Y  Y  Y  Y  Y  Y  Y  a  a  g  m  s  s  y  y  y  {  ~  ~  ~  ~  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �            !  1  1  1  1  I  U  ]  e  e  e  t  t  z  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                	        !  /  ;  C  K  K  M  b  e  e  e  x  x  ~  ~  �  �  �  �  �  �  �  �  �  �  �  �  �  	    !  ;  D  M  M  U  W  ]  ]  c  c  v  v  �  �  �  �  �  �  �  �  �  �  �  �           (  .  4  4  ?  ?  A  C  C  C  C  M  M  T  Z  e  e  j  l  n  y  y  y  {  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  !	  !	  8	  K	  V	  V	  V	  V	  V	  V	  V	  V	  X	  c	  e	  g	  u	  u	  {	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  �	  
  
  
  
  
  %
  +
  +
  +
  +
  /
  5
  5
  ;
  A
  A
  A
  D
  D
  D
  J
  J
  L
  T
  Z
  `
  `
  `
  g
  g
  m
  m
  |
  |
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
  �
          #  *  0  <  G  G  K  K  _  _  _  e  o  o  s  