#!/bin/bash

HOST="localhost"
PORT="73"
status="php-fpm_status"

function query() {
	curl -s http://${HOST}:${PORT}/${status}?xml | grep "<$1>" | awk -F'>|<' '{ print $3}'
}

if [ $# == 0 ]; then
		echo $"Usage $0 {pool|process-manager|start-time|start-since|accepted-conn|listen-queue|max-listen-queue|listen-queue-len|idle-processes|active-processes|total-processes|max-active-processes|max-children-reached|slow-requests}"
		exit
else
	query "$1"
fi

