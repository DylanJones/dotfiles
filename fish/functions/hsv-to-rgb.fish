#!/usr/bin/fish

function hsv-to-rgb
    set -l h (math "($argv[1] % 256)/255.0")
    set -l s (math "$argv[2]/255.0")
    set -l v (math "$argv[3]/255.0")

    # Literally no idea how this works but... stackoverflow :\
    set -l hh (math "$h*6")
    set -l i (math "floor($hh)")
    set -l ff (math "$hh-$i")
    set -l p (math "$v * (1.0 - $s)")
    set -l q (math "$v * (1.0 - ($s * $ff))")
    set -l t (math "$v * (1.0 - ($s * (1.0 - $ff)))")

    if [ $i = 0 ]
        set r $v
        set g $t
        set b $p
    else if [ $i = 1 ]
        set r $q
        set g $v
        set b $p
    else if [ $i = 2 ]
        set r $p
        set g $v
        set b $t
    else if [ $i = 3 ]
        set r $p
        set g $q
        set b $v
    else if [ $i = 4 ]
        set r $t
        set g $p
        set b $v
    else
        set r $v
        set g $p
        set b $q
    end
    
    set -l r (math "round($r * 255)")
    set -l g (math "round($g * 255)")
    set -l b (math "round($b * 255)")
    
    echo -e "$r\n$g\n$b"
end
