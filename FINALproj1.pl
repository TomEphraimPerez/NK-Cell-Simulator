% https://github.com/citationdude/410project
% https://github.com/citationdude/410project

% read(X), see(File) >>>
% https://www.cis.upenn.edu/~matuszek/Concise%20Guides/Concise%20Prolog.ht
%   %ml#unequal
%   clause(X,V)
%  Find a clause in the database whose head (left hand side) matches X
%   and whose body (right hand side) matches V. To find a base clause,
%   use true for V. maplist/N.
%   Also see B.I. PREDICATES/Input_predicates/ re get(X), get0(X) (rd
%   char and unify ASCII w X) ...
%
% https://www.metalevel.at/prolog/metapredicates#targetText=A%20closure%20is%20a%20term,arbi
%   trary%20meta%2Dpredicates%20in%20Prolog. DCG def clause grammars
% https://en.wikipedia.org/wiki/Prolog_syntax_and_semantics PL UNSW
%   Dictionary http://www.cse.unsw.edu.au/~billw/prologdict.html#body
%   AST's http://www.cse.unsw.edu.au/~billw/prologdict.html#body Dangers
%   in INF search
% https://cseweb.ucsd.edu/classes/fa09/cse130/misc/prolog/prolog_tutorial.pdf
%   inc concat, sort ..
% https://courses.cs.washington.edu/courses/cse341/12au/prolog/basics.html
% A.M.Z.I. ! http://www.amzi.com/AdventureInProlog/a4comqry.php
% DailyFreeCodeCom
% http://www.dailyfreecode.com/MySearchResult.aspx?q=testing+Javascript+with+Prolog&stype=al
%   l&slang=0
/*
read_js1(X) :-
  write('str'),
  nl,
  read(X),
  test1(X).
*/
% Usage into interpreter/ ?- read_js1(X).     .
% Contemplate having the js to be tested, poised for SWIPL input.
%
%
%                    a la  TEST CASE GENERATION in PL | Dewey-Github-410

 % e in BooleanExpression ::- [enum'ed here:]
/*   enumerate_indexed_solutions :-
      true,
      false,
      and(Exp, Exp),
      or(Exp, Exp),
      not(Exp),       % SWI-prolog.org says "not X" ctrl pred AKA \+X or not(X).
      lessThan(Exp, Exp),
      grtrThan(Exp, Exp),
      lessThanOrEqual(Exp, Exp),
      grtrThanOrEqual(Exp, Exp),
      equal(Exp, Exp),
      notEqual(Exp, Exp),
      plus(Exp, Exp),
      minus(Exp, Exp),
      integer(Exp),
      string(Exp),
      combBinopPlus(Exp, Exp, Exp),
      combBinopMinus(Exp, Exp, Exp),
      combBinopMult(Exp, Exp, Exp),
      combBinopDiv(Exp, Exp, Exp).
*/

decBound(In, Out):-                        % Depth-first.
  In > 0,
  Out is In - 1.
% expression(X):-
%   bool(X).   is replaced by >>>
% true, false                  From "Test Case Generation in Prolog"
boundedExpression(_, true).        % Was "booleanExpression(...)" since augment w bnd.
boundedExpression(_, false).               % true & false (also) base cases.
% and/2
boundedExpression(B1, and(E1, E2)):-       % &&
  decBound(B1, B2),              %line70   % B1 is current bnd. B2 is the AST fr before.
  boundedExpression(B2, E1),
  boundedExpression(B2, E2).
% or/2
boundedExpression(B1, or(E1, E2)):-        % ||
  decBound(B1, B2),
  boundedExpression(B2, E1),
  boundedExpression(B2, E2).
% Since re Mon 11-18-19 lecture, we have to remain in the
%            boundedExpression domain. So we now don't use the old/3 :
%   and(_, false, false).
%   and(false, _, false).
%   and(true, true, true).                   nor do we use the old/3 :
%   or(_, true, true).
%   or(true, _, true).
%   or(false, false, false).
%                                          %line86
% not/1
boundedExpression(B1, not(E)):-
  decBound(B1, B2),
  boundedExpression(B2, E).
%lessThan/2
boundedExpression(B1, lessThan(E1, E2)):-
  decBound(B1, B2),
  boundedExpression(B2, E1),
  boundedExpression(B2, E2).
%grtrThan/2
boundedExpression(B1, grtrThan(E1, E2)):-
  decBound(B1, B2),
  boundedExpression(B2, E1),
  boundedExpression(B2, E2).
%lessThanOrEqual/2
boundedExpression(B1, lessThanOrEqual(E1, E2)):-
  decBound(B1, B2),
  boundedExpression(B2, E1),
  boundedExpression(B2, E2).
%grtrThanOrEqual/2
boundedExpression(B1, grtrThanOrEqual(E1, E2)):-
  decBound(B1, B2),
  boundedExpression(B2, E1),
  boundedExpression(B2, E2).
%equal/2                                      % ==    line111
boundedExpression(B1, equal(E1, E2)):-
  decBound(B1, B2),
  boundedExpression(B2, E1),
  boundedExpression(B2, E2).
%notEqual/2
boundedExpression(B1, notEqual(E1, E2)):-   % !=
  decBound(B1, B2),
  boundedExpression(B2, E1),
  boundedExpression(B2, E2).

%plus/2
boundedExpression(B1, plus(E1, E2)):- % a la asmt6* TestCaseGen: makeTest(Tree,plus(E1,E2))
  decBound(B1, B2),                          % a la *decBound(Tree, TreeResult),
  boundedExpression(B2, E1),                 % al la *makeTest(TreeResult, E1) ...
  boundedExpression(B2, E2).
%minus/2
boundedExpression(B1, minus(E1, E2)):-
  decBound(B1, B2),
  boundedExpression(B2, E1),
  boundedExpression(B2, E2).
%integer/1
boundedExpression(B1, integer(E)):-
  decBound(B1, B2),
  boundedExpression(B2, E).
%string/1 (sans "otherString")
boundedExpression(B1, string(E)):-
  decBound(B1, B2),
  boundedExpression(B2, E).

%combBinopPlus/2  ('+')
boundedExpression(B1, combBinopPlus(E1, E2, E3)):-
  decBound(B1, B2),
  boundedExpression(B2, E1),
  boundedExpression(B2, E2),
  boundedExpression(B2, E3).
%combBinopMinus/2 ('-')
boundedExpression(B1, combBinopMinus(E1, E2, E3)):-
  decBound(B1, B2),  % ////////////////////////////////////////
  boundedExpression(B2, E1),
  boundedExpression(B2, E2),
  boundedExpression(B2, E3).
%combBinopMult/2 ('*')
boundedExpression(B1, combBinopMult(E1, E2, E3)):-
  decBound(B1, B2),
  boundedExpression(B2, E1),
  boundedExpression(B2, E2),
  boundedExpression(B2, E3).
%combBinopDiv/2 ('/')                            % Contemplate omitting.
boundedExpression(B1, combBinopDiv(E1, E2, E3)):-
  decBound(B1, B2),
  boundedExpression(B2, E1),
  boundedExpression(B2, E2),
  boundedExpression(B2, E3).                      %line164.

% END for now.

% for, whilth sw, asmt, postinc pre inc and dec.





















