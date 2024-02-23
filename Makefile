LANG = cc
TEST = test1 test2 test3 test_echo
IP = get_ip
ALL = $(IP)

CFLAGS = -g -Wall -Wextra -Werror -fno-inline
LDFLAGS = -pthread

all: $(ALL)

clean:
	rm -f $(ALL)
