#! /bin/awk -f

{
    if($2 ~ TARGET) {
        print "|" $2 "|" $3 "|" $4 "| " VERSION " | " DATE " |"
    } else {
        print $0
    }
}
