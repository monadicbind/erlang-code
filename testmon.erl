-module(testmon).
-export([start/0,client/2,loop/0]).



start() -> spawn(testmon , loop ,[]).

client(Pid,Request) ->
	Pid ! {self(),Request},
	receive
		{Pid, Resp} ->
			io:format("~s~n",[Resp])
	end.

loop() ->
	receive
		{From ,Mesg} ->
			io:format(Mesg),
			From ! {self(),"Received"},
			loop()
	end.