#!/bin/bash

# Define color variables
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color

# Function to handle cleanup on SIGINT (Ctrl+C)
cleanup() {
    echo -e "\nStopping processes..."
    # Kill the two main processes with SIGKILL (-9)
    kill -9 $frontend_pid $backend_pid 2>/dev/null
    exit 1
}

# Trap SIGINT signal and call cleanup
trap cleanup SIGINT

# Start the front-end process in background.
# Its stdout/stderr are piped through a while loop that prefixes each line with [Client] in blue.
( cd app/frontend-app && npm run dev ) > >(while IFS= read -r line; do echo -e "${BLUE}[Client]${NC} $line"; done) 2>&1 &
frontend_pid=$!

# Start the back-end process in background.
# Its output is piped similarly, with [Server] in green.
( cd app/backend-app && .venv/bin/python main.py ) > >(while IFS= read -r line; do echo -e "${GREEN}[Server]${NC} $line"; done) 2>&1 &
backend_pid=$!

# Optionally display the recorded process IDs
echo "Frontend PID: $frontend_pid"
echo "Backend PID: $backend_pid"

# Wait for both processes to finish
wait $frontend_pid $backend_pid
