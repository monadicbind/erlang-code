-module(startseveralmon).
-export([startsevmons/0,startprocess/1,startmon/1]).

startprocess(Id) ->
	receive
		kill ->
			io:format("Process id ~p Killed ~n",[Id])
	after
		5000 ->
			io:format("Process id ~p died ~n",[Id]),
			exit(tringtring)
	end.	

startmon(IndVal) ->
	{Pid,Ref} = spawn_monitor(?MODULE,startprocess,[IndVal]),
	receive
			{'DOWN',Ref,process,Pid,Why} ->
				io:format("Killed process , ~p",[Pid]),
				io:format(Why),
				startmon(IndVal);
			killMonProcess ->
				Pid ! kill,
				io:format("Killing the startmon Process~n"),
				startmon(IndVal)
		end.

startsevmons() ->
	Pid1 = spawn(fun() -> 
		NumList = lists:seq(1,2),
		T = lists:map(fun(I) -> spawn(fun() -> startmon(I) end) end,NumList)
		%L = [spawn(fun() -> startmon(1) end)],
		%lists:foreach(fun(Pid) -> 
						%receive 
							%after 
								%15000 -> 
									%io:format("Kill"), 
									%Pid ! killMonProcess 
						%end
					%end,T)
	end).
	

