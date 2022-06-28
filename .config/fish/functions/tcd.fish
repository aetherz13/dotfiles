function tcd
  if test -n "$argv[1]"
    set dir (realpath $argv[1])
  else
    set dir $PWD
  end

  printf "TFTPD_ARGS=-v --secure -B 4096 '$dir'\n" | \
    sudo tee /etc/conf.d/tftpd > /dev/null \
    && sudo systemctl restart tftpd \
    && printf "tftpd root directory is changed to $dir\n"
end
