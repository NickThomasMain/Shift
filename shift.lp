valid_shift(S, L) :-
    type(S_min, S_max, L_min, L_max),
    slot(S), L = 1..8,  % Possible length of shifts based on slots
    S >= S_min, S <= S_max,
    L >= L_min, L <= L_max.

max_employees(Max) :- Max = #max {E: emp(_, _, E)}.
1 {shift(S, L, D, E) : day(D), valid_shift(S, L), E = 1..MaxE} MaxS :- max_employees(MaxE), maxshifts(MaxS).

cyclic(S, L) :- shift(S, L, D, E), S + L > 8.

slot_in_shift(SL, S, L, E) :-
    shift(S, L, _, E),
    SL >= S,
    SL < S + L, 
    slot(SL).   


slot_in_shift(SL, S, L, E) :-
    shift(S, L, _, E),
    cyclic(S, L),
    RemainingLength = (S + L) \ 8,
    SL >= 1,
    SL < RemainingLength,
    slot(SL).


employee_per_shifts(SL, Sum) :-
    Sum = #sum{E, SL, L, D: slot_in_shift(SL, L, D, E)},
    slot(SL).

:- emp(_,S,R), employee_per_shifts(S, Sum), Sum < R - Sh, shorten(Sh) .
:- emp(_,S,R), employee_per_shifts(S, Sum), Sum > R + Ex, exceed(Ex).

#show shift/4.
