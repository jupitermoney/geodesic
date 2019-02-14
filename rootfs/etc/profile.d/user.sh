#!/usr/bin/env bash

id "${USER}" &>/dev/null
if [[ "$?" -ne 0 ]]; then
	if [[ -n "${USER_ID}" ]] && [[ -n "${GROUP_ID}" ]]; then
		adduser -D -u ${USER_ID} -g ${GROUP_ID} -h ${HOME} ${USER} &>/dev/null
	fi
fi

echo "LC_ALL=en_US.UTF-8" >> /etc/environment
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen en_US.UTF-8