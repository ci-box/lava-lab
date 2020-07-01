#!/bin/sh

if [ "${TTY_AKEBI96}" ]; then
  [ ! -f "${TTY_AKEBI96}" ] && ln -s ${TTY_AKEBI96} /dev/tty.akebi96
fi

if [ "${TTY_96BOARD}" ]; then
  [ ! -f "${TTY_96BOARD}" ] && ln -s ${TTY_96BOARD} /dev/tty.96board
fi
