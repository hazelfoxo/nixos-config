#!/usr/bin/env bash

# Get current hour (0-23)
hour=$(date +"%H")

# Common daytime messages
day_messages=(
    "You got this!"
    "Stay strong!"
    "Keep moving!"
    "Shine bright!"
    "Stay focused!"
    "Make it count!"
)

# Short night messages
night_messages=(
    "Rest well."
    "Sleep tight."
    "Time to relax."
    "Recharge for tomorrow."
    "Sweet dreams."
    "Good rest ahead."
)

# Choose greeting and message set
if [ "$hour" -lt 8 ]; then
    tod="Good night"
    messages=("${night_messages[@]}")
elif [ "$hour" -lt 18 ]; then
    tod="Good afternoon"
    messages=("${day_messages[@]}")
else
    tod="Good evening"
    messages=("${day_messages[@]}")
fi

# Pick random message
motivation=${messages[$((RANDOM % ${#messages[@]}))]}

# Capitalize username
user_cap=$(whoami | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')

# Show greeting
echo "$tod, $user_cap! $motivation"

