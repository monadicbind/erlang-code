-module(areaclientfinal).
-export([area/2]).

area(Pid,What) ->
	rpc(Pid,What).

rpc(Pid,What) ->
	Pid !{self(),What},
	receive
		{Pid,Response} ->
			io:format("Pid : ~p~n",[Pid]),
			io:format("Response: ~w~n",[Response]),
			Response
	end.