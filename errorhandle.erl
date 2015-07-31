-module(errorhandle).
-export([start/1,testmonitor/1,cnvrt/0]).

start(Fun) -> spawn(fun() -> testmonitor(create_monitor(Fun)) end).

create_monitor(Fun) ->
	statistics(wall_clock),
	spawn_monitor(Fun).

testmonitor({Pid,Ref}) ->
	%{Pid,Ref} = spawn_monitor(Fun),
	io:format("Created Pid is : ~p~n",[Pid]),
	receive
		{hello,Msg} -> 
			Pid ! Msg,
			testmonitor({Pid,Ref});
		{'DOWN',Ref, process,Pid,Why} ->
			{_, Time1} = statistics(wall_clock),
			io:format("Down"),
			io:format("Process spawn time = ~p microsecond ~n",[Time1])
	end.

cnvrt() ->
	receive
		X -> 
			list_to_atom(X)
	end.