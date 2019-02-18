if [ -z "${ASSUME_ROLE}" ]; then
	if [ -f "/etc/motd" ]; then
		cat "/etc/motd"
		if [ "${ENABLE_K8_NOTIFICATION}"=="true" ]; then
			kubectl get pods --all-namespaces | grep -E 'CrashLoopBackOff|Pending|Error'
		fi
	fi

	if [ -n "${MOTD_URL}" ]; then
		curl --fail --connect-timeout 1 --max-time 1 --silent "${MOTD_URL}"
	fi
fi
