-module(areaserver2).
-export([loop/0,rpc/2]).

rpc(Pid , Request) ->
	Pid ! {self(),Request},
	receive 
		{Pid , Response} ->
			io:format("Pid : ~w~n",[Pid]),
			Response
	end.


loop() ->
	receive
		{From , {rectangle , Width , Height}} -> 
			From ! {self(),Width * Height},
			loop();
		{From, {square , Side}} ->
			From ! {self(),Side * Side},
			loop();
		{From , Other} ->
			From ! {self() , {error , Other} },
			loop()
	end.
