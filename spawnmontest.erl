-module(spawnmontest).
-export([start/0,startmon/0]).

start() -> spawn(fun() -> 
			{Pid,Ref} = startmon(),
			loop(Pid,Ref)
end).

loop(Pid,Ref) ->
	io:format("Inside the loop~n"),
	receive
		hello -> 
			Pid ! hello,
			loop(Pid,Ref);
		{'DOWN',Ref,process,Pid,Why} ->
			io:format("in here ~w~n",[Why])
	end.

startmon() -> 
	{Pid,Ref} = spawn_monitor(fun() -> 
		io:format("In the fun ~n"),
		receive
			X -> list_to_atom(X)
		end
	end).


