-module(spawn_test).
-export([start/0,test_fun/0]).

start() -> spawn(?MODULE,test_fun,[]).

test_fun() ->
	receive
		test -> io:format("Test")
	end.