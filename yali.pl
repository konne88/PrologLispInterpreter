% Implements a subset of common lisp
% The following functions/macros are provided by default
% 
% quote
% defun
% 
% car
% cdr
% list
%
% TODO
% caaaaar, caaddddr ...
% cond
% cons
% append
% let
% if
% eval

% remove NO from macros parsing

concat([],B,B).
concat([A|T],B,[A|R]) :- concat(T,B,R).

% N is a list of variables represented as the tuple (id,value)
% F is a list of functions, represented as the tuple (id,parameters,body)
% O is the output structure of command
% Id is an identifier
% Param is a parameter
% T stands for the tail of a list
% H stand for head

% True is true
t.

% first expand all macros and then execute the created structure
eval(N,F,Value,O,NewF) :- expand(Value,ExpandedValue,CustomF), 
                          concat(CustomF,F,NewF), 
                          exe(N,NewF,ExpandedValue,O).

% function declarations may not be nested
expand([defun, Id, ParamVars, Body],Id,[[Id,ParamVars,ExpandedBody]]) :- expand(Body,ExpandedBody,[]). 

% conditions are expanded to an appropriate function
expand([if, Cond, Then, Else],[cond,[ExpandedCond,ExpandedThen],[t,ExpandedElse]],FO) :- expand(Cond,ExpandedCond,CondF),
										         expand(Then,ExpandedThen,ThenF),
                     								         expand(Else,ExpandedElse,ElseF),
                                                                                         concat(CondF,ThenF,CondThenF),
                                                                                         concat(CondThenF,ElseF,FO).

% resursively evaluate all nodes of the structure
expand([H|T],[HO|TO],FO) :- expand(H,HO,HFO), expand(T,TO,TFO), 
                            concat(HFO,TFO,FO).

% expanding simple elements does not do anything
expand(O,O,[]).

% cond
exeCases(_,_,[],[]).
exeCases(N,F,[[Cond,Expr]|_],O) :- exe(N,F,Cond,Bool), Bool, exe(N,F,Expr,O).
exeCases(N,F,[_|T],O) :- exeCases(N,F,T,O).

exe(N,F,[cond|Cases],O) :- exeCases(N,F,Cases,O).

% quote stops evaluation
exe(_,_,[quote|[Value]],Value).

% evaluate a function
exe(N,F,[Id|Params],O) :- exeParams(N,F,Params,Evaluated), fun(F,Id,Evaluated,O).

% resolves a variable, if it is not found, variable name is returned
exe([[Id|Value]|_],_,Id,Value).
exe([_|T],F,Id,Value) :- exe(T,F,Id,Value).
exe([],_,Num,Num) :- number(Num).
exe([],_,t,t).
exe([],_,nil,[]).

bindParamVars([],[],[]).
bindParamVars([Param|T],[ParamVar|T2],[.(ParamVar,Param)|NO]):-bindParamVars(T,T2,NO).

% execute a common function
fun(_,car,Params,O) :- Params = [[O|_]].
fun(_,cdr,Params,O) :- Params = [[_|O]].
fun(_,list,Params,Params).
fun(_,(<),[A,B],t) :- number(A), number(B), A<B.
fun(_,(<),[A,B],t) :- number(A), number(B).
fun(_,(>),[A,B],t) :- number(A), number(B), A>B.
fun(_,(>),[A,B],nil) :- number(A), number(B).
fun(_,(=),[A,B],t) :- number(A), number(B), A=B.
fun(_,(=),[A,B],nil) :- number(A), number(B).
fun(_,null,[],t).
fun(_,null,_,nil).
fun(_,(+),[A,B],O) :- number(A), number(B), O is A+B.
fun(_,(-),[A,B],O) :- number(A), number(B), O is A-B.
fun(_,(*),[A,B],O) :- number(A), number(B), O is A*B.
fun(_,(/),[A,B],O) :- number(A), number(B), O is A/B.

% go for the user defined functions
fun(F,Id,Params,O) :- userFun(F,F,Id,Params,O).

userFun(F,[[Id,ParamVars,Body]|_],Id,Params,O) :- bindParamVars(Params,ParamVars,N), 
            				          exe(N,F,Body,O).
userFun(F,[_|T],Id,Params,O) :- userFun(F,T,Id,Params,O).

% evaluates all elements of a list
exeParams(_,_,[],[]).
exeParams(N,F,[Element|T],[Evaluated|T2]) :- exe(N,F,Element,Evaluated), exeParams(N,F,T,T2).

% eval([],[],5,O,FO).
% eval([.(x,1337)],[],x,O,FO).
% eval([],[],[list,1,2],O,FO).
% eval([],[],[cdr,[list,1,2,3]],O,FO).
% eval([.(x,1337)],[],[car,[list,x,2,3]],O,FO).
% eval([],[],[defun, test, [x,y], [list,1,2,x,y]],O,FO).
% eval([],[],[defun, test, [a], a],O,FO), eval([],FO,[test,1337],O2,FO2). 
% eval([],[],[defun, test, [x,y], [list,1,2,x,y]],O,FO), eval([],FO,[test,3,4],O2,FO2).
% eval([],[],[quote, [a,[+,3,4],var,66,du,[1,6,8,[[],[]],va]]],O,FO). 
% eval([],[],[+,[t,5]],O,FO).
% eval([],[],[-,[t,5]],O,FO).
% eval([],[],[*,[t,5]],O,FO).
% eval([],[],[/,[t,5]],O,FO).
% eval([],[],[/,[t,5]],O,FO).
% eval([],[],[<,[t,5]],O,FO).
% eval([],[],[>,[t,5]],O,FO).
% eval([],[],[null,[t,5]],O,FO).
% eval([],[],[null,[t,5]],O,FO).

