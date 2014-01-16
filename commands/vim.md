# Awesome Vim Commands

## Search (and/or replace)

### Remove/keep matching lines
Referenced here: http://lglinux.blogspot.com/2009/08/vim-keep-or-delete-lines-matching.html

__delete matching lines__

	:g/pattern/d

__keep only matching lines__

	:v/pattern/d

### Add padding to a given pattern match

This is useful for cleaning up log files

	:%s/\v<pattern>/\= submatch(0) . repeat(" ", <total_size> - len(submatch(0)))

## Sort

### by columns
	:%!sort -k1,1n -k2,2n -k3,3n -t: