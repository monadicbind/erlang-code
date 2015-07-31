-module(errorhandle1).
-export([my_spawn/3,loop/1,test_func/0]).

my_spawn(Mod,Fun,Args) -> 
	%SpawnedPidRef = myspawn_helper(Mod,Fun,Args),
	%spawn(?MODULE , loop , [myspawn_helper(Mod,Fun,Args)]).
	spawn(fun() -> loop(myspawn_helper(Mod,Fun,Args)) end).

myspawn_helper(Mod,Fun,Args) ->
	statistics(wall_clock),
	spawn_monitor(Mod,Fun,Args).

loop({SpPid,SpRef}) ->
	io:format("Created Pid is : ~p~n",[SpPid]),
	receive
		{makeError,Msg} -> 
			SpPid ! Msg,
			loop({SpPid,SpRef});
		{'DOWN',SpRef, process,SpPid,Why} ->
			{_, Time1} = statistics(wall_clock),
			io:format("Down"),
			io:format("Process spawn time = ~p microsecond ~n",[Time1])
	end.

test_func() ->
	receive
		X -> 
			list_to_atom(X)
	end.	