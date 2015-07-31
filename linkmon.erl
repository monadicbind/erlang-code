-module(linkmon).
-compile([export_all]).

my_proc() ->
	timer:sleep(5000),
	exit(boom).


chain(0) ->
	receive 
		_ -> ok
	after 2000 ->
		exit("chain dies here")
	end;
chain(N) ->
	Pid = spawn(fun() -> chain(N-1) end),
	link(Pid),
	receive
		_ -> ok
	end.

start_critic() ->
	spawn(?MODULE,critic,[]).

start_critic2() ->
	spawn(?MODULE,restarter,[]).


judge(Pid,Band,Album)	->
	Pid ! {self() , {Band , Album}},
	receive
		{Pid, Criticism} -> Criticism
	after 2000 ->
		timeout
	end.	

judge2(Band,Album) ->
	Ref = make_ref(),
	critic1 ! {self(),Ref,{Band,Album}},
	receive
		{Ref, Criticism} ->
			Criticism
	after 2000 ->
		timeout
	end.

restarter() ->
	process_flag(trap_exit,true),
	Pid = spawn_link(?MODULE,critic,[]),
	register(critic1,Pid),
	receive
		{'EXIT',Pid,normal} ->
			ok;
		{'EXIT',Pid,shutdown} ->
			ok;
		{'EXIT',Pid,_} ->
			restarter()
	end.			

critic() ->
	receive
		{From , Ref,{"Raging against the Turing Machine", "Unit Testify"}} ->
			From ! {Ref , "They are great"};
		{From , Ref,{_Band, _Album}} ->
			From ! {Ref, "They are terrible"}
	end,
	critic().
