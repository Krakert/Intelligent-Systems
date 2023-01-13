/* Fatcs */
male(jan).
male(dirk).
male(henk).
male(ben).
male(dick).
male(dennis).
male(kevin).
male(leroy).
male(jeroen).
male(stefan).
male(davy).
male(mats).
male(guus).
male(thomas).
male(erwin).

female(joke).
female(trudy).
female(suanne).
female(lisa).
female(ingrid).
female(renee).
female(petra).
female(margot).
female(maud).
female(veerle).
female(amber).


/* kids of jan & joke = renee, henk, margot */
parent_of(jan, renee).
parent_of(jan, henk).
parent_of(jan, margot).
parent_of(joke, renee).
parent_of(joke, henk).
parent_of(joke, margot).

/* kids of dirk & trudy = dick */
parent_of(dirk, dick).
parent_of(trudy, dick).

/* kids of susanne & lisa = ingrid */
parent_of(susanne, ingrid).
parent_of(lisa, ingrid).

/* kids of henk & petra = stefan, jeroen */
parent_of(henk, stefan).
parent_of(henk, jeroen).
parent_of(petra, stefan).
parent_of(petra, jeroen).

/* kids of margot & ben = dennis, kevin, leroy */
parent_of(margot, dennis).
parent_of(margot, kevin).
parent_of(margot, leroy).
parent_of(ben, dennis).
parent_of(ben, kevin).
parent_of(ben, leroy).

/* kids of dick & irgid = maud, veerle, guus */
parent_of(dick, maud).
parent_of(dick, veerle).
parent_of(dick, guus).
parent_of(ingrid, maud).
parent_of(ingrid, veerle).
parent_of(ingrid, guus).

/* kids of erwin = thomas, amber */
parent_of(erwin, thomas).
parent_of(erwin, amber).

/* kids of stefan & maud = davy, mats */
parent_of(stefan, davy).
parent_of(stefan, mats).
parent_of(maud, davy).
parent_of(maud, mats).

/* Bonus kids of erwin = stefan, jeroen */
stepparent_of(erwin, stefan).
stepparent_of(erwin, jeroen).

/* Rules */

/* Get the father of Y or the child(s) of X */
father_of(X, Y) :-
    male(X),
    parent_of(X, Y).

/* Get the stepfather of Y or the bonus child(s) of X */
stepfather_of(X, Y) :-
    male(X),
    stepparent_of(X, Y).

/* Get the stepmother of Y or the bonus child(s) of X */
stepmother_of(X, Y) :-
    female(X),
    stepparent_of(X, Y).

/* Get the mother of Y or the child(s) of X */
mother_of(X, Y) :-
    female(X),
    parent_of(X, Y).
 
/* Get the grandfather of Y or the grandchild(er) of X */
grandfather_of(X, Y) :-
    male(X),
    parent_of(X, Z),
    parent_of(Z, Y).
 
/* Get the grandmother of Y or the grandchild(er) of X */
grandmother_of(X, Y) :-
    female(X),
    parent_of(X, Z),
    parent_of(Z, Y).

/* Get all the sisters of X or Y */
sister_of(Sister, Sibling) :-
    female(Sister),
    siblings(Sister, Sibling).

/* Get all the brothers of X or Y */
brother_of(Brother, Sibling) :-
    male(Brother),
    siblings(Brother, Sibling).

/* Get the person(s) nephew*/
nephew_of(Nephew, Person) :-
    male(Nephew),
    parent_of(Parent, Nephew),
    siblings(Parent, Person).

/* Get cousing(s) of Child1 or Child2 */
cousin_of(Child1, Child2) :-
    parent_of(Y1, Child1),
    parent_of(Y2, Child2),
    siblings(Y1, Y2).

/* Get aunt of Y or the nephew / niece of X */
aunt_of(X, Y) :-
    female(X),
    parent_of(Parent, Y),
    sister_of(X, Parent).

/* Get uncle of Y or the nephew / niece of X */
uncle_of(X, Y) :-
    male(X),
    parent_of(Parent, Y),
    brother_of(X, Parent). 

/* Get all the siblings of X or Y */
sib(X,Y) :- 
    parent_of(P,X), 
    parent_of(P,Y), 
    \+X=Y.

/* Get all the siblings of X or Y, not duplicated */
siblings(X, Y) :-
    setof((X, Y),
          P^(parent_of(P, X), parent_of(P, Y), \+X=Y),
          Sibs),
    member((X, Y), Sibs),
    \+ ( Y@<X,
         member((Y, X), Sibs)
       ).

/* Get the great grandmother of Y or the great grandchild of X */
great_grandmother_of(X, Y) :-
        female(X),
        parent_of(X,V), 
        parent_of(V,W), 
        parent_of(W,Y).

/* Get the great grandfather of Y or the great grandchild of X */    
great_grandfather_of(X, Y) :-
        male(X),
        parent_of(X,V), 
        parent_of(V,W), 
        parent_of(W,Y).
    
/* Get the descendants of X, or the ancestor(s) of Y*/
ancestor_of(X,Y):- 
    parent_of(X,Y).
ancestor_of(X,Y):- 
    parent_of(X,Z),
    ancestor_of(Z,Y).