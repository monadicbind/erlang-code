-module(fact1).
-export([main/1]).

main([A]) ->
	I = list_to_integer(atom_to_list(A)),
	F = fact(I),
	io:format("factorial ~w = ~w ~n",[I,F]),
	init:stop().

fact(0) -> 1;
fact(N) -> N*fact(N-1).
