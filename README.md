# julia-vim-repl
a vi like repl for julia

Very barebones emulation of vim, probably always will be ... but ateast you dont 
have to ctl-p to go through history. 

you have to hit `esc` twice to get into vi mode

`h,j,k,l` work as expected.

`j,k` move through history as well as up and down through multi line code in the REPL. 
Works only with default `julia` mode though when going through history. (if you go through
history with `k` and encounter say `ls` which you typed out in `shell` mode. When you
go hit `i` it will paste `ls` to `julia` mode and not `shell` mode)

vims number prefix dont work `2de` will not delete run `de` twice.

This isn't a module yet.
If you want to try this out , get `start.jl` and run it with (`include("start.jl")`) in the repl.
`julia -i start.jl` will not work.

Built on [RepLMaker.jl](https://github.com/MasonProtter/ReplMaker.jl) and a minor tweak on 
LineEdit.
