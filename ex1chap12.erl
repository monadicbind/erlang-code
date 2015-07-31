-module(ex1chap12).
-export([start1/2,loop/0]).

start1(AnAtom,Fun) ->
	case whereis(AnAtom) of
		undefined -> register(AnAtom,spawn(Fun));
		Pid -> error(io:format("~s, already Registered to ~p~n",[AnAtom,Pid]))
	end.
	

loop() ->
	receive
		Any ->
			Any,
			loop()
	end.	
	


	
