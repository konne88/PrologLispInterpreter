concat([],B,B).
concat([A|T],B,[A|R]) :- concat(T,B,R).

% N is a list of variables represented as the tuple (id,value)
% F is a list of functions, represented as the tuple (id,parameters,body)
% O is the output structure of command
% Id is an identifier
% Param is a parameter
% T stands for the tail of a list

% evaluate a macro
% eval(N,[M|P],O) :- exp(N,M,P,O). 

% evaluate a function
eval(N,[Id|Params],O) :- evalpar(N,Params,Evaluated), exe(Id,Evaluated,O).

% resolves a variable, if it is not found, variable name is returned
eval([[Id|Value]|_],Id,Value).
eval([_|T],Id,Value) :- eval(T,Id,Value).
eval([],Id,Id).

% expand a macro
% exp(N,defun,[I P B],O) :-  

% execute a function
exe(car,Params,O) :- Params = [[O|_]].
exe(cdr,Params,O) :- Params = [[_|O]].
exe(list,Params,Params).

% evaluates all elements of a list
evalpar(_,[],[]).
evalpar(N,[Element|T],[Evaluated|T2]) :- eval(N,Element,Evaluated), evalpar(N,T,T2).

% eval([.(x,1337)],x,X).
% eval([],[list,1,2],X).
% eval([],[cdr,[list,1,2,3]],X).
% eval([.(x,1337)],[car,[list,x,2,3]],X).
