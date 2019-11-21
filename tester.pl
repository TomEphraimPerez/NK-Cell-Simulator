bool(true). 
bool(false). 
str('string'). 
str('anotherString'). 
variable('x'). 
operator(+). 
operator(-). 
operator(~). 
operator(!). 
operator(void). 
binop('<').
binop('<='). 
binop('>').
binop('>=').
binop('==').
binop('!='). 
binop('>').
cbop('+').
cbop('-').
cbop('*'). 
cbop('/'). 

equal_cbop(X):- 
	cbop(Y), 
	atom_chars(X, [Y,=]).

expression(X):- 
	bool(X). 
expression(X):-
	str(X). 
expression(X):-
	variable(X). 
expression('null'). 
expression(assignment(X, E)):-
	variable(X), expression(E). 
expression(X, Y, Z):-
	variable(X), 
	cbop(Y), 
	expression(Z). 

