-module(errorhandle3).
-import(errorhandle1,[my_spawn/3]).
-export([my_spawn/4]).

my_spawn(Mod,Fun,Args,Time1) ->
	spawn(fun() -> 
		Pid = my_spawn(Mod,Fun,Args),
		receive
			{makeError,Msg} ->
				Pid ! Msg
		after 
			Time1 -> 
				io:format("Killing after time ~w~n",[Time1]),
				void
		end
	end).
