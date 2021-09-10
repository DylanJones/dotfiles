# Fish startup script

# Only needs to run for interactive shells.

if status --is-interactive
    function gen_color
        # <string to hash, saturation, value> 
        # outputs a hex color for prompt usage
        set -l hsv (math 0x(echo $argv[1] | md5sum | head -c 2)) $argv[2] $argv[3]
        set -l rgb (hsv-to-rgb $hsv)
        echo (printf "%02x" $rgb[1])(printf "%02x" $rgb[2])(printf "%02x" $rgb[3])
    end

    set -l rgb (hsv-to-rgb (math "0x80+0x"(echo $USER@(hostname) | md5sum | head -c 2)) 160 255)
    set fish_color_user (printf "%02x" $rgb[1])(printf "%02x" $rgb[2])(printf "%02x" $rgb[3])
    set fish_color_host (gen_color $USER@(hostname) 160 255)
    set fish_color_host_remote (gen_color $USER@(hostname) 160 255)
end
