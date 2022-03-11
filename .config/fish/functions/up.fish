
# Original script can be found here: https://gitlab.com/dwt1/dotfiles/-/blob/master/.bashrc
function up
    set -l d ""
    set -l limit "$argv[1]"

    if [ -z "$limit" ] || [ "$limit" -le 0 ]
        set limit 1
    end

    for i in (seq $limit)
        set d "../$d"
    end

    # I don't think this actually does something.
    # I will keep it just to follow the original source.
    if ! cd "$d"
        echo "Couldn't go up $limit dirs."
    end
end
