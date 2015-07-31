-module(areaserver).
-export([loop/0]).

loop() ->
	receive
		{From , {rectangle , Width , Height}} -> 
			From ! Width * Height,
			loop();
		{From, {square , Side}} ->
			%%io:format("Area of the square is ~p ~n",[Side * Side]),
			From ! Side * Side,
			loop()
	end.
