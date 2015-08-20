-module(imalivetest).
-export([startrunner/0,startmonrunner/0]).

startrunner() ->
	receive
		kill ->
			io:format("Monitor Process killed~n")
	after
		5000 ->
			io:format("Im alive"),
			startrunner()
	end.

startmonrunner() ->
	Pid1 = spawn(fun() -> 
				{Pid,Ref} = spawn_monitor(?MODULE,startrunner,[]),
				register(?MODULE,Pid),
				receive
					{'DOWN',Ref,process,Pid,Why} ->
						io:format("Killed process , ~p",[Pid]),
						io:format(Why),
						startmonrunner();
					killMonProcess ->
						Pid ! kill,
						io:format("Killing the Monitored Process~n")
				end

		end).