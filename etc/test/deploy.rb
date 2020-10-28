#!/usr/bin/env ruby

def test_deploy
  if File.exists?("Makefile")
    c, d = 0, 0
    list = []
    make_list = `make list 2>&1`
    exit 1 unless $? == 0

    list = make_list.rstrip.rstrip.split(/\r?\n/).map(&:chomp)
    list.each do |f|
      if f == '.config/'
        d += 1
        next
      end
      source = File.expand_path(f)
      dest = File.expand_path("~"+"/"+f)
      if File.symlink?(dest)
        c += 1 if File.readlink(dest) == source
      else
        puts "source is different from symlink(dest)"
        puts File.symlink?(dest)
        puts source
      end
    end
    # puts c
    # puts d
    # puts list.size
    exit 1 unless c == list.size - d
  else
    puts 'Makefile not found'
    exit 1
  end
end

test_deploy
