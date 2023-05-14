# Better package 
https://github.com/caleb-allen/VimBindings.jl is more complete, much more advanced and way ahead in vim emulation. I wont be working on this package anymore.

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

## Install
This isn't a package or module yet.If you want to try this out , get `start.jl` from this repo and run it with (`include("start.jl")`) in the repl.
`julia -i start.jl` will not work.

Built on [ReplMaker.jl](https://github.com/MasonProtter/ReplMaker.jl) and a minor tweak on some
functions from LineEdit and REPL.

This needs the active repl to function.
~I havent figured out how auto-run things immediatly after the REPL starts.
For now i have a function `viminit() = include(path/to/start.jl)"` inside my startup.jl and run `viminit` when after julia startup.~

silly me ... ReplMaker.jl has instructions on how to do this.
append this to your startup.jl
```
viminit() = include("/path/to/start.jl")
atreplinit() do repl
        try
            @async viminit()
        catch
        end
    end
```

## Whats mapped

`h,j,k,l` : navigation 

`dd` : clear line

`de,db` : delete next / previous word

`e,b` : goto next /previous word

`i,a` : go back to julia-mode

`x` : deletes a character

~`j,k` do not do prefix completions .~

`j,k` scroll up and down as-though the lines in history were the lines in a vim buffer.

`Enter` runs the line on the REPL buffer and sets the mode to julia mode.

Prefix Search works too.<br>
If a something exists in repl buffer it goes up and down history only showing line starting
with that something. 

I dont understand a lot of the code in REPL.jl and LineEdit.jl myself. So somethings you see in my code  might be a roundabout way to do things because i'm not aware of or dont fully understand the functions in REPL.jl and LineEdit.jl. Some day when i have the time i'll get around to writing a cleaner version of this. For now i get it to a point of working for my use. 
