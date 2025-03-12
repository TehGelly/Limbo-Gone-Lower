# SCRIPTING

Inside of **Task::Step** is the definitions of each of the instructions of this scripting language.
The scripting language seems to have no registers and works solely on the stack and with instruction arguments.

Below are listed an understanding of each of the operations and their argument counts
Lowercase arguments are on the stack
(INCOMPLETE INSTRUCTIONS ARE OP_XX)

0  PUSHI A    : Push A as immediate onto the stack  
1  PUSHI A    : Same as OP_0  
2  PUSHS S    : Push length-prepended string immediate onto stack [only variable-length argument instruction]  
3  POP   A    : Pop A values from the stack.  
4  DUP   A    : Duplicate the top of the stack A times.  
5  FLOAT A,B  : Starting from A values below the stack and moving down, converts B ints to floating point numbers in place.  
6  OP_6       : Push SOME UNKNOWN MEMBER OF script (script->base_node->base_entity->UNKNOWN_REFLIST->field0) onto the stack  
7  OP_7       : Push SOME LOCAL SCENE VAR onto the stack  
8  OP_8       : Push SOME GLOBAL SCENE VAR onto the stack  
9  OP_9  A,B,c: Move down the stack A\*B values and copy c\*B values from (A-c)\*B. Set stack pointer to (A-1)\*B (WHY ARE WE SHIFTING THE STACK DOWN? WHY IS THE STACK POINTER IN THE MIDDLE OF COPIED VALUES?)  
10 MUL   A,b,c: Push A\*b + c onto the stack  
11 OP_11 A,b  : Push A values from SOME LOCAL_SCRIPT LOCATION's INDEXED WITH b onto the stack  
12 OP_12 A,b  : Pop A values from the stack to SOME LOCAL_SCRIPT's LOCATION INDEXED WITH b  
13 OP_13 A,b,c: Push A values from SOME OTHER_SCRIPT WITH ID c's LOCATION INDEXED WITH b onto the stack  
14 OP_14 A,b,c: Pop A values from the stack to SOME OTHER_SCRIPT WITH ID c's LOCATION INDEXED WITH b  
15 OP_15 A,b  : Push A values from "the call stack", starting at 2-b values into "the call stack"  
16 OP_16 A,b  : Pop A values into "the call stack", starting at 2-b values into "the call stack"  
17 OP_17 a,b  : UNKNOWN OPERATION involving Entity with ID b and its property with id a  
18 OP_18 A,b,c: SOMETHING TO DO WITH PROPERTIES???? LOOK AT OP_17 FOR REFERENCE????  
19 DATACALL A : Calls operation low16(A) of datatype high16(A), using the stack.  
20 GLOBCALL A : Calls globally-defined function A, using the stack.  
21 LOCACALL A : Push a call to local function A onto "the call stack"  
22 OP_22 A,B,C: Does SOME FORM OF EXTERNAL CALL VIA LOOKUP FOR ANOTHER SCRIPT EHHHHHH  
23 ENTICALL A,B: get entity number from value A under the stack and call function B of it.  
24 JMP   A    : Jump A ahead  
25 JNZ   A,b  : Jump A ahead if b != 0  
26 JZ    A,b  : Jump A ahead if b == 0  
27 OP_27 A    : SIMPLER VERSION OF OP_21?  
28 OP_28 a    : SO MUCH. SO MUCH. POSSIBLY CALLING THE TOP OF ANOTHER SCRIPT'S STACK????  
29 OP_29      : POPS FROM "THE CALL STACK". PROBABLY CALLS IT, TOO  
30 HLT\
31 HLT\
32 HLT\

## DATATYPES AND DATACALLS

Below are the initial datatypes and their applicable calls. Full operator descriptions have been abbreviated, 
but can be found in the binary in AddScriptableDataTypes

DATATYPES = [("void",0,[]),("int",1,[]),("float",2,[]),("bool",3,[]),("char",4,[]),  
             ("vector2i",5,["x","y"]), ("vector2f",6,["x","y"]), ("UNIMP",7,[]),  
             ("vector3f",8,["x","y","z"]),("quaternion",9,["x","y","z","w"]),  
             ("entity",10,[]),("string",11,[])]  

OPERATORS = {"bool"    :["&&","||","^^","==","!=","!"],  
             "int"     :["&","|","^",">","<",">=","<=","==","!=","*","/","%","+","-","<<",">>","++","--","-1*","~"],  
             "float"   :["*",">","<",">=","<=","==","!=","*","/","+","-","-1*","IsValid","%","*3f"],  
             "string"  :["+","-","==","!=",">","<","+f","+i","+b","+2f","+3f"],  
             "entity"  :["==","!="],  
             "vector2i":["*","/","+","-","==","!=","-1*"],  
             "vector2f":["*",".","/","+","-","^","==","!=","-1*","GetLength","GetNormalized"],  
             "vector3f":["*",".","/","+","-1*","-","^","==","!=","GetLength","GetSqrLength","GetNormalized"],  
             "quaterni":["*q","*f","==","!=","!","ToEuler"]}  