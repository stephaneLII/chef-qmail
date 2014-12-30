@test "check-qmailq is working" {
  run /etc/sensu/plugins/check-qmailq.rb
  [ $? -eq 0 ]
}