concat([],B,B).
concat([A|T],B,[A|R]) :- concat(T,B,R).

% N is a list of variables represented as the tuple (id,value)
% F is a list of functions, represented as the tuple (id,parameters,body)
% O is the output structure of command
% Id is an identifier
% Param is a parameter
% T stands for the tail of a list
% H stand for head

% first expand all macros and then execute the created structure
eval(N,F,Value,O,NewF) :- expand(Value,ExpandedValue,CustomN,CustomF), 
                          concat(CustomN,N,NewN), concat(CustomF,F,NewF), 
                          exe(NewN,NewF,ExpandedValue,O).

% function declarations may not be nested
expand([defun, Id, ParamVars, Body],Id,NO,[[Id,ParamVars,ExpandedBody]]) :- expand(Body,ExpandedBody,[],NO). 

% resursively evaluate all nodes of the structure
expand([H|T],[HO|TO],NO,FO) :- expand(H,HO,HNO,HFO), expand(T,TO,TNO,TFO), 
                               concat(HNO,TNO,NO), concat(HFO,TFO,FO).

% expanding simple elements does not do anything
expand(O,O,[],[]).

% evaluate a function
exe(N,F,[Id|Params],O) :- execParams(N,F,Params,Evaluated), fun(F,Id,Evaluated,O).

% resolves a variable, if it is not found, variable name is returned
exe([[Id|Value]|_],_,Id,Value).
exe([_|T],F,Id,Value) :- exe(T,F,Id,Value).
exe([],_,Id,Id).

bindParamVars([],[],[]).
bindParamVars([Param|T],[ParamVar|T2],[.(ParamVar,Param)|NO]):-bindParamVars(T,T2,NO).

% execute a common function
fun(_,car,Params,O) :- Params = [[O|_]].
fun(_,cdr,Params,O) :- Params = [[_|O]].
fun(_,list,Params,Params).
fun(F,Id,Params,O) :- userFun(F,F,Id,Params,O).

% go for the user defined functions
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

