#let try/catch fail in the first line itelf if there is no active_repl

using ReplMaker
import REPL
import REPL.LineEdit
import Base
#using REPL.LineEdit
#import REPL.LineEdit : *
import REPL.LineEdit:edit_delete,TextInterface,keymap_data,match_input,accept_result,StringLike,keymap,prefix_history_keymap,HistoryProvider,Prompt,prefix_history_keymap,setup_prefix_keymap,history_prev_prefix,history_next_prefix,copybuf!,state,buffer,PrefixHistoryPrompt,enter_prefix_search,ModeState, edit_werase,edit_delete_next_word,on_enter,edit_move_word_left,edit_move_word_right,edit_undo!,commit_line,edit_move_right,edit_move_left,edit_move_up,edit_move_down,edit_kill_region, mode, MIState, transition,AnyDict
#LineEdit = REPL.LineEdit
#mode = LineEdit.mode
#MIState = LineEdit.MIState
#transition = LineEdit.transition
#edit_move_up
#import LineEdit: edit_move_up , mode , MIState, transition
sss = nothing



vim_norm_nav_keymap = AnyDict([
    #nav
    #'k' =>
    # (s::MIState, o...) -> (
    #            edit_move_up(s) || LineEdit.history_prev(s, LineEdit.mode(s).hist)
    #    ),
    #'j' =>
    #  (s::MIState, o...) -> (
    #            edit_move_down(s) || LineEdit.history_next(s, LineEdit.mode(s).hist)
    #    ),
    "h" => (s::MIState,o...)->edit_move_left(s),
    "l" => (s::MIState,o...)->edit_move_right(s),
    #delete line
    "dd" => (s::MIState,o...)->edit_kill_region(s),
    #word erase
    "de" => (s::MIState,o...)->edit_delete_next_word(s),
    "db" => (s::MIState,o...)->edit_werase(s),
    #navigate words
    "b" => (s::MIState,o...)->edit_move_word_left(s),
    "e" => (s::MIState,o...)->edit_move_word_right(s),
    "u" => (s::MIState,o...)->edit_undo!(s),
    "x" => (s::MIState,o...)->edit_delete(s),
    #"k" => (s::MIState,o...)->edit_move_up(s),
    #"j" => (s::MIState,o...)->edit_move_down(s),
    #'\r' => (s::MIState,o...)->begin
    #    if on_enter(s) || (eof(buffer(s)) && s.key_repeats > 1)
    #        commit_line(s)
    #        return :done
    #    else
    #        edit_insert_newline(s)
    #    end
    #end,
    #'\r' => (s::MIState,o...)->begin
    #        commit_line(s)
    #        return :done
    #    end,
    
    # on enter goto julia mode
    # TODO , figure out a working way to run code when enter is hit.
    '\r' => function (s::MIState, o...)
        buf = copy(LineEdit.buffer(s))
        transition(s, julia_prompt) do
            LineEdit.state(s, julia_prompt).input_buffer = buf
        end
        end,

    #back to julia_prompt
    "i" => function (s::MIState, o...)
        buf = copy(LineEdit.buffer(s))
        transition(s, julia_prompt) do
            LineEdit.state(s, julia_prompt).input_buffer = buf
        end
        end,

    "a" => function (s::MIState, o...) #TODO , make it append
        buf = copy(LineEdit.buffer(s))
        transition(s, julia_prompt) do
            LineEdit.state(s, julia_prompt).input_buffer = buf
        end
    end,
])

function run_vi_key()
    """
    runs the vi keymap c
    """

end

function gen_vi_prefix_bind(cc::StringLike)
    return cc => (s::MIState,data::ModeState,c::StringLike) -> begin
        sbuf = LineEdit.buffer(s)
        transition(s,vim_prompt)
        LineEdit.replace_line(s,sbuf)
        #println(c)
        vim_norm_nav_keymap[cc](s)
    end
end


vi_prefix_history_keymap = AnyDict(
        "k" => (s::MIState,data::ModeState,c)->history_prev_prefix(data, data.histprompt.hp, data.prefix),
        "j" => (s::MIState,data::ModeState,c)->history_next_prefix(data, data.histprompt.hp, data.prefix),
        # Up Arrow
        "\e[A" => (s::MIState,data::ModeState,c)->history_prev_prefix(data, data.histprompt.hp, data.prefix),
        # Down Arrow
        "\e[B" => (s::MIState,data::ModeState,c)->history_next_prefix(data, data.histprompt.hp, data.prefix),
        '\r' => function (s::MIState, o...)
                  buf = copy(LineEdit.buffer(s))
                  transition(s, julia_prompt) do
                      LineEdit.state(s, julia_prompt).input_buffer = buf
                  end
        end,
        "i" => function (s::MIState, o...)
        buf = copy(LineEdit.buffer(s))
        transition(s, julia_prompt) do
            LineEdit.state(s, julia_prompt).input_buffer = buf
        end
        end,
        "a" => function (s::MIState, o...)
        buf = copy(LineEdit.buffer(s))
        transition(s, julia_prompt) do
            LineEdit.state(s, julia_prompt).input_buffer = buf
        end
        end,
)

to_merge = Dict([gen_vi_prefix_bind(c) for c in Set(keys(vim_norm_nav_keymap)) if !(c in keys(vi_prefix_history_keymap)) ])

merge!(vi_prefix_history_keymap,to_merge)

function setup_prefix_keymap_vi(hp::HistoryProvider, parent_prompt::Prompt)
    p = PrefixHistoryPrompt(hp, parent_prompt)
    p.keymap_dict = LineEdit.keymap([vi_prefix_history_keymap])
    pkeymap = AnyDict(
        'k' => (s::MIState,o...)->(edit_move_up(s) || enter_prefix_search(s, p, true)),
        'j' => (s::MIState,o...)->(edit_move_down(s) || enter_prefix_search(s, p, false)),
        # Up Arrow
        "\e[A" => (s::MIState,o...)->(edit_move_up(s) || enter_prefix_search(s, p, true)),
        # Down Arrow
        "\e[B" => (s::MIState,o...)->(edit_move_down(s) || enter_prefix_search(s, p, false)),
    )
    return (p, pkeymap)
end

#vi_prefix_prompt.keymap_dict['\r'] = (s::MIState,o...)->begin
#            commit_line(s)
#            end,
#vi_prefix_prompt.keymap_dict['\r'] =  
#prefix_keymap['k'] = prefix_keymap["^P"]
#prefix_keymap['j'] = prefix_keymap["^N"]

function REPL.history_move(
    s::Union{LineEdit.MIState,LineEdit.PrefixSearchState},
    hist::REPL.REPLHistoryProvider,
    idx::Int,
    save_idx::Int = hist.cur_idx,
)
    max_idx = length(hist.history) + 1
    @assert 1 <= hist.cur_idx <= max_idx
    (1 <= idx <= max_idx) || return :none
    idx != hist.cur_idx || return :none

    # save the current line
    if save_idx == max_idx
        hist.last_mode = LineEdit.mode(s)
        hist.last_buffer = copy(LineEdit.buffer(s))
    else
        hist.history[save_idx] = LineEdit.input_string(s)
        if mode(s) == vim_prompt
            hist.modes[save_idx] = REPL.mode_idx(hist, julia_prompt) #we dont save vim_prompt in history 
        else
            hist.modes[save_idx] = REPL.mode_idx(hist, LineEdit.mode(s))
        end
    end

    # load the saved line
    if idx == max_idx
        last_buffer = hist.last_buffer
        LineEdit.transition(s, hist.last_mode) do
            LineEdit.replace_line(s, last_buffer)
        end
        hist.last_mode = nothing
        hist.last_buffer = IOBuffer()
    else
        if haskey(hist.mode_mapping, hist.modes[idx])
            if mode(s) == vim_prompt || s.parent == vim_prompt
                LineEdit.replace_line(s, hist.history[idx]) #if vim prompt we stay in vim prompt dont change to julia_prompt on history
            else
                LineEdit.transition(s, hist.mode_mapping[hist.modes[idx]]) do
                    LineEdit.replace_line(s, hist.history[idx])
                end
            end
        else
            return :skip
        end
    end
    hist.cur_idx = idx
    return :ok
end

vim_prompt = initrepl(
    (s) -> show(s),
    prompt_text = "vi > ",
    prompt_color = :light_green,
    start_key = "\e\e",
    mode_name = "vim_prompt",
    keymap = Dict([]),
    valid_input_checker= REPL.return_callback
)

julia_prompt = Base.active_repl.interface.modes[1]
hp = julia_prompt.hist
vi_prefix_prompt, prefix_keymap = setup_prefix_keymap_vi(hp, vim_prompt)

empty!(vim_prompt.keymap_dict)
vim_prompt.keymap_dict = LineEdit.keymap([vim_norm_nav_keymap,prefix_keymap])


norm_trigger_keymap = REPL.AnyDict("\e\e" => function (s::MIState, o...)
    buf = copy(LineEdit.buffer(s))
    LineEdit.transition(s, vim_prompt) do
        LineEdit.state(s, vim_prompt).input_buffer = buf
    end
end)#add esc-esc to julia_prompt mode

julia_prompt.keymap_dict =
    LineEdit.keymap_merge(julia_prompt.keymap_dict, norm_trigger_keymap)

