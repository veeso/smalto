-module(regex_ffi).
-export([compile/1, find/3, byte_slice/3, byte_length/1]).

%% Compile a PCRE pattern with unicode support.
%% Returns {ok, CompiledRegex} or {error, nil}.
compile(Pattern) ->
    case re:compile(Pattern, [unicode, ucp]) of
        {ok, MP} -> {ok, MP};
        {error, _} -> {error, nil}
    end.

%% Find the first match starting from the given byte offset.
%% Returns {ok, {ByteStart, MatchedText}} or {error, nil}.
find(Regex, Text, ByteOffset) ->
    case re:run(Text, Regex, [{offset, ByteOffset}]) of
        {match, [{Start, Len} | _]} ->
            Matched = binary:part(Text, Start, Len),
            {ok, {Start, Matched}};
        nomatch ->
            {error, nil}
    end.

%% Slice a binary string by byte offsets.
byte_slice(Text, Start, Length) ->
    binary:part(Text, Start, Length).

%% Get the byte length of a UTF-8 binary string.
byte_length(Text) ->
    byte_size(Text).
