-module(spawn3mon).
-export([myspawn/3,startmon/3]).

%Write a function my_spawn(Mod, Func, Args) that behaves 
%like spawn(Mod, Func, Args)
% but with one difference. 
%If the spawned process dies, 
%a message should be printed 
%saying why the process died 
%and how long the process lived for before it died.

myspawn(Mod,Fun,Args) -> 
	spawn(fun() ->
		{Pid,Ref} = startmon(Mod,Fun,Args),
		loop(Pid,Ref)
	end).

loop(Pid,Ref) ->
	io:format("Inside the loop~n"),
	receive
		hello -> 
			Pid ! hello,
			loop(Pid,Ref);
		{'DOWN',Ref,process,Pid,Why} ->
			{_,Time1} = statistics(wall_clock),
			io:format("in here ~w~n",[Why]),
			io:format("Time1 : ~p~n",[Time1])
	end.

startmon(Mod,Fun,Args) -> 
	statistics(wall_clock),
	{Pid,Ref} = spawn_monitor(Mod,Fun,Args).

