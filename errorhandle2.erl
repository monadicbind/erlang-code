-module(errorhandle2).
-import(lib_misc,[on_exit/2]).
-export([mspawn/3,loop/1,my_spawn/3]).

mspawn(Mod,Fun,Args) ->
	spawn(fun() -> loop(my_spawn(Mod,Fun,Args)) end).

my_spawn(Mod,Fun,Args) -> 
	statistics(wall_clock),
	SpPid = spawn(Mod,Fun,Args),
	Pid = on_exit(SpPid,fun(Why) -> my_spawn_helper(Why) end),
	{SpPid,Pid}.

loop({SpPid,Pid}) ->
	io:format("Created Pid: ~p~n",[SpPid]),
	io:format("On Exit Pid: ~p~n",[Pid]),
	receive
		{makeError,Msg} ->
			SpPid ! Msg;
			%loop({SpPid,Pid})
		Any -> 
			Any,
			loop({SpPid,Pid})
	end.			



my_spawn_helper(Why) ->
	{_,Time1} = statistics(wall_clock),
	io:format("Call~n"),
	io:format(Why),
	io:format("Process spawn time = ~p microsecond ~n",[Time1]).

