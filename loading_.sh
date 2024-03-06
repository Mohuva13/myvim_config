function progress {
    bar=''
    for (( x=0; x <= $1; x++ )); do
        sleep 0.05
        bar="${bar} "

        echo -ne "\r"
        echo -ne "\e[43m$bar\e[0m"

        local left="$(( 100 - $x ))"
        printf " %${left}s"
        echo -n "${x}%"
    done
    echo -ne "\r                        \r"
}
progress $1