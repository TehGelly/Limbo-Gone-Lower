'   
stateAntic signal   
                                      stateAttack signal   
                                    boyKilledSignal signal   
                                    	chaseAnim     G                                   bodySkeleton     J                                ����attackerLegSkeleton     J                                ����pelvis     6                                ����attackSpring     :                                ����attackLegPivot                                     ����myState                           	           ����
trapJoint1     7                     
           ����
trapJoint2     7                                ����killTrigger     0                                ����startSkeletonForce                                      ����	forceKill                                      ����forceKillTimer                                      ����endBone     6                                ����allowBridgeJump                                      ����waitingForBridgeJump                                      ����start                                                  forceAttack                                      ����updateChase                                                 currentfpsscale                                      ����updateAnticipation                          q                       attackStartPos                                      ����attackFraction                                      ����updateAttack                          N                       	anticDone                          �                
   
       killBoy                          O                     	boyKilled                          �                
   
       disableLogics                                      ����disableAttackLegLogics                          �                
   
       forceAttackSignal                          �                
   
       legOff                          �          	      
   
       WaitForAllowBridgeJump                          =          
      
   
       AllowBridgeJump                          a                
   
       DisAllowBridgeJump                          �                
   
       enableAttackLegLogics                          �                     	integrate                          �                     0   n                                    ����diffx                             &  n  ����dist                                n  ����diff                                n  ����gameTime                          ����    n  ����step                             �  K  ����dist                             �  K  ����diff                             �  K  ����targetfpsscale                             �  K  ����dist2                              q  K  ����gameTime                          ����    K  ����dirNormalized                          	   �  �  ����dir                             �  �  ����target                             u  �  ����vel                              d  �  ����gameTime                          ����    �  ����	activator     
                     ����    L  ����caller     
                     ����    L  ����j     7                 	   
   �    ����	trapJoint     8                 	   	   �    ����j     7                 
   
   +  B  ����	trapJoint     8                 
   	     B  ����body                             �  �  ����joint2                             �  �  ����joint1                             �  �  ����thigh     6                       �  �  ����forward                               �  ����
rightThigh     6                       u  �  ����	leftThigh     6                       k  �  ����s     J                        O  �  ����	activator     
                     ����    �  ����caller     
                     ����    �  ����	activator     
                     ����    �  ����caller     
                     ����    �  ����	activator     
                     ����    �  ����caller     
                     ����    �  ����body     6                       �  -  ����n                             �  :  ����body     6                        �  :  ����	activator     
                     ����    :  ����caller     
                     ����    :  ����	activator     
                     ����    ^  ����caller     
                     ����    ^  ����	activator     
                     ����    �  ����caller     
                     ����    �  ����	activator     
                     ����    �  ����caller     
                     ����    �  ����gameTime                              �  ^  ����        D                                                                                                                                 %   ;   ;   O   O   d   y   y   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �                        &  &  @  @  X  X  ^  h  n  n  q  q  q  q  q  q  q  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �          #  #  -  -  ;  E  K  K  N  N  N  N  N  N  d  d  k  u  u  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �              %  %  +  +  1  7  7  =  =  F  F  L  O  O  O  O  O  O  O  O  O  O  O  O  O  T  T  k  k  u    �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �              +  6  B  D  O  O  Q  W  g  p  x  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �      "  "  -  /  1  :  =  =  =  E  O  U  U  ^  a  a  a  h  n  t  z  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �                  #  #  )  5  5  ;  G  G  R  X  X  ^  ^  b  