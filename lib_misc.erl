-module(lib_misc).
-export([on_exit/2,my_spawn/3,my_test/0,mys/3,idiot/0]).

on_exit(Pid,Fun) ->
	spawn(fun() ->
			Ref = monitor(process,Pid),
			receive
				{'DOWN',Ref,process,Pid,Why} ->
					Fun(Why)
			end
		end).

my_spawn(Mod,Fun,Args) ->
	spawn(fun() ->
			statistics(wall_clock),
			Ref = monitor(process,Pid=spawn(Mod,Fun,Args)),
			receive
				{'DOWN',Ref, process,Pid,Why} ->
				{_,Time2} = statistics(wall_clock),
				io:format(Why),
				io:format(Time2);
				Msg -> Pid ! Msg
			end,
			Pid
		end).

my_test() ->
	receive
		X -> list_to_atom(X)
	end.

mys(Mod,Fun,Args) ->
	spawn(fun() -> myspawn(Mod,Fun,Args) end).

myspawn(Mod,Fun,Args)	->
	statistics(wall_clock),
	{Pid,Ref} = spawn_monitor(Mod,Fun,Args),
	io:format("Pid value created is ~p~n",[Pid]).

idiot() -> spawn(fun() ->
		{Pid,Ref} = spawn_monitor(fun() -> receive {P1,Msg} -> io:format("POS~n"),P1 ! {self(),"fuck"} end end),
		receive
			{_,die} ->
				 io:format("DIE~n") , 
				 Pid ! {self(),"testing"};
			{Pid,Test} ->
				io:format(Test)
		end
	end).	




