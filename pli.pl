% Implements a subset of common lisp
% The following functions/macros are provided by default
% 
% quote
% defun
% let
% cond
% if
%
% car
% cdr
% list
% cons
% null
% 
% >,<
% +,-,*
% floor
%
% There are lots of things you cannot do such as quoting lists with ' or
% Define custom macros, etc. Further the way numbers are used, especially
% Concerning rounding etc, might be wrong
%
% Each predicate defined in this code has a short header describing what
% The predicate does. This description is followed by a newline and a
% Detailed description of all the predicate's parameters. The following
% common parameters are not described again for each function:
% 
% N is a list of variables represented as the tuple .(id,value). This list
%   generally represents the locally declared variables
% F is a list of functions, represented as the tuple [id,parameters,body]
%   This list generally represents the locally declared functions.
% O is the resulting structure of a command execution
% Id is an identifier
% Param is a parameter
% T stands for the tail of a list
% H stand for head
%
% Common names can be concaternated to form more complex things such as
% FO, which stands for List of Functions to that resulted from command execution

% True is true
t.

% This is the only entry function for users of this module
% First expand all macros and then execute the created structure
%
% Value is the structure to be executed,
% O,N,F,FO
eval(Value,O,N,F,FO) :- expand(Value,ExpandedValue,CustomF), 
                          append(CustomF,F,FO), 
                          exe(N,FO,ExpandedValue,O).

% Expand macros, this is mainly used for function daclarations and if but could be 
% extended to support used provided macros
%
% Value to be expanded,
% O,FO
expand([defun, Id, ParamVars, Body],[quote,Id],[[Id,ParamVars,ExpandedBody]]) :- expand(Body,ExpandedBody,[]), !. 

expand([if, Cond, Then, Else],[cond,[ExpandedCond,ExpandedThen],[t,ExpandedElse]],FO) :- expand(Cond,ExpandedCond,CondF),
										         expand(Then,ExpandedThen,ThenF),
                     								         expand(Else,ExpandedElse,ElseF),
                                                                                         append(CondF,ThenF,CondThenF),
                                                                                         append(CondThenF,ElseF,FO), !.

% Resursively expand all nodes of the structure
expand([H|T],[HO|TO],FO) :- expand(H,HO,HFO), expand(T,TO,TFO), 
                            append(HFO,TFO,FO), !.

% Expanding simple elements does not do anything
expand(O,O,[]).

% Used internally by the cond statement. Evaluates and Executes appropriate Cases.
%
% N,F,
% Values is a list of condition expression tuples such that each element is [Condition,Expression]
% O
exeCases(_,_,[],[]).
exeCases(N,F,[[Cond,Expr]|T],O) :- exe(N,F,Cond,Bool), Bool=t, exe(N,F,Expr,O), !.
exeCases(N,F,[_|T],O) :- exeCases(N,F,T,O).

% Used internally by the let statement. Executes and Binds all variables declared in the led statement.
% THis means that it adds new Variables to N.
%
% N,F,
% Values is a list of Id Value tuples such that each element is [Id,Value].
% NO
bindValues(N,_,[],N).
bindValues(N,F,[[Id,Value]|T],[.(Id,ExecutedValue)|NO]):-exe(N,F,Value,ExecutedValue), bindValues(N,F,T,NO).

% Used internally by exe to evaluate a function's parameters before calling the function.
%
% N,F,
% A list of Parameters to be evaluated,
% O is a list of evaluated parameters
exeParams(_,_,[],[]).
exeParams(N,F,[Element|T],[Evaluated|T2]) :- exe(N,F,Element,Evaluated), exeParams(N,F,T,T2).

% Executes an already expanded structure in lisp fashion
% 
% N,F,
% Value is the structure to be executed,
% O
exe(N,F,[cond|Cases],O) :- exeCases(N,F,Cases,O), !.

% Quote stops evaluation
exe(_,_,[quote,Value],Value) :- !.

% Let binds some values
exe(N,F,[let, Values, Body],O) :- bindValues(N,F,Values,NewN), exe(NewN,F,Body,O), !.

% Evaluate a function
exe(N,F,[Id|Params],O) :- exeParams(N,F,Params,Evaluated), fun(F,Id,Evaluated,O), !.

% Common atoms that need no execution
exe(_,_,[],[]):- !.
exe(_,_,Num,Num) :- number(Num), !.
exe(_,_,t,t) :- !.
exe(_,_,nil,[]):- !.

% Resolves a variable
exe([[Id|Value]|_],_,Id,Value):- !.
exe([_|T],F,Id,Value) :- exe(T,F,Id,Value).

% Used internally by userFun. Binds the parameters passed to a 
% user defined function to it's internal namespace N.
% 
% ParamIds  A List of the function's parameter Ids,
% Param     The Values that should be bound to these Ids,
% NO
bindParamVars([],[],[]).
bindParamVars([Param|T],[ParamVar|T2],[.(ParamVar,Param)|NO]):-bindParamVars(T,T2,NO).

% Used internally by fun for used defined functions.
% Looks up the name of the function that is to be executed and 
% Runs the appropriate code.
%
% F,
% A sublist of F with all the function names that were not yet checked,
% Function Name is the name of the function to be called,
% Params is a list of parameteres passed to the function,
% O
userFun(F,[[Id,ParamVars,Body]|_],Id,Params,O) :- bindParamVars(Params,ParamVars,N), 
            				          exe(N,F,Body,O), !.
userFun(F,[_|T],Id,Params,O) :- userFun(F,T,Id,Params,O).

% Executes a function
%
% F,
% Function Name is the name of the function to be called,
% Params is a list of parameteres passed to the function,
% O
fun(_,print,[Value],Value) :- write(Value), nl, !.
fun(_,car,Params,O) :- Params = [[O|_]], !.
fun(_,cdr,Params,O) :- Params = [[_|O]], !.
fun(_,list,Params,Params):- !.
fun(_,cons,[A,B],.(A,B)):- !.
fun(_,null,[[]],t) :- !.
fun(_,null,[nil],t) :- !.
fun(_,null,_,nil) :- !.
fun(_,floor,[A,B],O) :- number(A), C is A/B, O is floor(C), !.
fun(_,(<),[A,B],t) :- number(A), number(B), A<B, !.
fun(_,(<),[A,B],nil) :- number(A), number(B), !.
fun(_,(>),[A,B],t) :- number(A), number(B), A>B, !.
fun(_,(>),[A,B],nil) :- number(A), number(B), !.
fun(_,(=),[A,B],t) :- number(A), number(B), A=B, !.
fun(_,(=),[A,B],nil) :- number(A), number(B), !.
fun(_,(+),[A,B],O) :- number(A), number(B), O is A+B, !.
fun(_,(-),[A,B],O) :- number(A), number(B), O is A-B, !.
fun(_,(*),[A,B],O) :- number(A), number(B), O is A*B, !.
fun(_,(/),[A,B],O) :- number(A), number(B), O is A/B, !.

% execute the user defined functions
fun(F,Id,Params,O) :- userFun(F,F,Id,Params,O).

