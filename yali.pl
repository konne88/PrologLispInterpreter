concat([],B,B).
concat([A|T],B,[A|R]) :- concat(T,B,R).

% evaluate a macro
% eval(N,[M|P],O) :- exp(N,M,P,O). 

% evaluate a function
eval(N,[F|P],O) :- evalpar(N,P,E), exe(F,E,O).

% resolves a variable, if it is not found, variable name is returned
eval([[K|V]|_],K,V).
eval([_|T],K,V) :- eval(T,K,V).
eval([],K,K).

% expand a macro
% exp(N,defun,[I P B],O) :-  

% execute a function
exe(car,P,O) :- P = [[O|_]].
exe(cdr,P,O) :- P = [[_|O]].
exe(list,P,P).

% evaluates all elements of a list
evalpar(_,[],[]).
evalpar(N,[A|T],[Q|O]) :- eval(N,A,Q), evalpar(N,T,O).

% eval([.(x,1337)],x,X).
% eval([],[list,1,2],X).
% eval([],[cdr,[list,1,2,3]],X).
% eval([.(x,1337)],[car,[list,x,2,3]],X).
