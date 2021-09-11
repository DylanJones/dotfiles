function change_color
    function gen_color
        # <string to hash, saturation, value> 
        # outputs a hex color for prompt usage
        set -l hsv (math 0x(echo $argv[1] | md5sum | head -c 2)) $argv[2] $argv[3]
        set -l rgb (hsv-to-rgb $hsv)
        echo (printf "%02x" $rgb[1])(printf "%02x" $rgb[2])(printf "%02x" $rgb[3])
    end

    if [ -z $argv[1] ]
        set hue 
    end

    set -l salt (head -c 16 /dev/urandom | md5sum | head -c 8)
    echo Salt is $salt
    set -l rgb (hsv-to-rgb (math "0x80+0x"(echo $salt | md5sum | head -c 2)) 140 255)
    echo RGB is $rgb
    set fish_color_user (printf "%02x" $rgb[1])(printf "%02x" $rgb[2])(printf "%02x" $rgb[3])
    set fish_color_host (gen_color $salt 140 255)
    set fish_color_host_remote (gen_color $salt 140 255)
end
