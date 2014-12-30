@test "SMTP port is open (25)" {
  run bash -c "netstat -anpt | grep LISTEN | egrep ':25' | wc -l"
  [ "$output" -eq 1 ]
}

@test "POP3 port is open (110)" {
  run bash -c "netstat -anpt | grep LISTEN | egrep ':110' | wc -l"
  [ "$output" -eq 1 ]
}

@test "IMAP port is open (143)" {
  run bash -c "netstat -anpt | grep LISTEN | egrep ':143' | wc -l"
  [ "$output" -eq 1 ]
}
