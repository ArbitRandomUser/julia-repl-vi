# julia-repl-vi
Vi like bindings for julia-repl<br>
Very barebones emulation of vim, probably always will be ... 

_Some vimulation is better than being an emacsochist._


##### NOTE : You have to hit `esc` **twice** to get into vi mode 

`h,j,k,l` work as expected.<br>
`j,k` move through history as well as up and down through multi line code in the REPL. 
Works only with default `julia` mode though when going through history. (if you go through
history with `k` and encounter say `ls` which you typed out in `shell` mode. When you
go hit `i` it will paste `ls` to `julia` mode and not `shell` mode)

Vim's number prefix dont work `2de` will not delete run `de` twice.

This isn't a module yet.If you want to try this out , get `start.jl` from this repo and run it with (`include("start.jl")`) in the repl.
`julia -i start.jl` will not work.

Built on [ReplMaker.jl](https://github.com/MasonProtter/ReplMaker.jl) and a minor tweak on some
functions from LineEdit and REPL.

## Whats mapped

`h,j,k,l` : navigation 

`dd` : clear line

`de,db` : delete next / previous word

`e,b` : goto next /previous word

`i,a` : go back to julia-mode

~`j,k` do not do prefix completions .~

`j,k` scroll up and down as-though the lines in history were the lines in a vim buffer.

Prefix Search works too.<br>
If a something exists in repl buffer it goes up and down history only showing line starting
with that something

This needs the active repl to function. I havent figured out how auto-run things immediatly after the REPL starts.
For now i have a function `viminit() = include(path/to/start.jl)"` inside my startup.jl and run `viminit` when after julia startup.
